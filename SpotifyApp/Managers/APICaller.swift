//
//  APICaller.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 14.04.2022.
//

import Foundation

private enum BaseAPI {
    static let url = "https://api.spotify.com/v1"
    static let scheme = "https"
    static let host = "api.spotify.com"
    static let verison = "/v1"
    
    static let searchQueryType = "album,artist,playlist,track"
    static let successCode: Int = 200
    
    static let HTTPHeaderFieldName = "Content-Type"
    static let HTTPHeaderFieldValue = "application/json"
}

private enum APIQueryItems {
    static let ids = "ids"
    static let limit = "limit"
    static let seedGenres = "seed_genres"
    static let type = "type"
    static let query = "q"
}

final class APICaller {
    static let shared = APICaller()
    
    private var decoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    private enum APIError: Error {
        case failedToGetData
    }
    
    private enum HTTPMethod: String {
        case DELETE
        case GET
        case POST
        case PUT
    }
    
    private init() {}
    
    // MARK: - Albums
    
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: "/albums/\(album.id)") { [weak self] request in
            self?.makeRequest(with: request, for: AlbumDetailsResponse.self, completion: completion)
        }
    }
    
    public func getCurrentUserAlbums(completion: @escaping (Result<[Album], Error>) -> Void) {
        createRequest(with: "/me/albums") { [weak self] request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil, let self = self else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try self.decoder.decode(LibraryAlbumsResponse.self, from: data)
                    completion(.success(result.items.compactMap { $0.album }))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func saveAlbum(album: Album, completion: @escaping (Bool) -> Void) {
        createRequest(
            with: "/me/albums",
            urlQuery: [URLQueryItem(name: "ids", value: String(album.id))],
            type: .PUT
        ) { request in
            let task = URLSession.shared.dataTask(with: request) { _, response, error in
                guard let code = (response as? HTTPURLResponse)?.statusCode,
                      error == nil else {
                    completion(false)
                    return
                }
                
                completion(code == BaseAPI.successCode)
            }
            task.resume()
        }
    }
    
    // MARK: - Playlists
    
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        createRequest(with: "/playlists/\(playlist.id)") { [weak self] request in
            self?.makeRequest(with: request, for: PlaylistDetailsResponse.self, completion: completion)
        }
    }
    
    public func getCurrentUserPlaylists(completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(
            with: "/me/playlists",
            urlQuery: [URLQueryItem(name: APIQueryItems.limit, value: "50")]
        ) { [weak self] request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil, let self = self else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try self.decoder.decode(LibraryPlaylistsResponse.self, from: data)
                    completion(.success(result.items))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func createPlaylist(with name: String, completion: @escaping (Bool) -> Void) {
        getCurrentUserProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.createRequest(with: "/users/\(profile.id)/playlists", type: .POST) { baseRequest in
                    var request = baseRequest
                    let json = [
                        "name": name
                    ]
                    request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
                    
                    let task = URLSession.shared.dataTask(with: request) { data, _, error in
                        guard let data = data, error == nil else {
                            completion(false)
                            return
                        }
                        
                        do {
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            if let response = result as? [String: Any], response["id"] as? String  != nil {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        } catch {
                            print(error.localizedDescription)
                            completion(false)
                        }
                    }
                    task.resume()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func addTrackToPlaylist(
        track: AudioTrack,
        playlist: Playlist,
        completion: @escaping (Bool) -> Void
    ) {
        createRequest(with: "/playlists/\(playlist.id)/tracks", type: .POST) { baseRequest in
            var request = baseRequest
            let json = [
                "uris": [
                    "spotify:track:\(track.id)"
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue(BaseAPI.HTTPHeaderFieldValue, forHTTPHeaderField: BaseAPI.HTTPHeaderFieldName)
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    completion(false)
                }
            }
            task.resume()
        }
    }
    
    public func removeTrackFromPlaylist(
        track: AudioTrack,
        playlist: Playlist,
        completion: @escaping (Bool) -> Void
    ) {
        createRequest(with: "/playlists/\(playlist.id)/tracks", type: .DELETE) { baseRequest in
            var request = baseRequest
            let json = [
                "tracks": [
                    [
                        "uri": "spotify:track:\(track.id)"
                    ]
                ]
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json, options: .fragmentsAllowed)
            request.setValue(BaseAPI.HTTPHeaderFieldValue, forHTTPHeaderField: BaseAPI.HTTPHeaderFieldName)
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(false)
                    return
                }
                
                do {
                    let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    if let response = result as? [String: Any], response["snapshot_id"] as? String != nil {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } catch {
                    completion(false)
                }
            }
            task.resume()
        }
    }

    
    // MARK: - Profile
    
    public func getCurrentUserProfile(completion: @escaping (Result<UserProfile, Error>) -> Void) {
        createRequest(with: "/me") { [weak self] request in
            self?.makeRequest(with: request, for: UserProfile.self, completion: completion)
        }
    }
    
    // MARK: - Browse / Home
    
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
        createRequest(
            with: "/browse/new-releases",
            urlQuery: [URLQueryItem(name: APIQueryItems.limit, value: "50")]
        ) { [weak self] request in
            self?.makeRequest(with: request, for: NewReleasesResponse.self, completion: completion)
        }
    }
    
    public func getFeaturedPlaylists(completion: @escaping ((Result<FeaturedPlaylistsResponse, Error>) -> Void)) {
        createRequest(
            with: "/browse/featured-playlists",
            urlQuery: [URLQueryItem(name: APIQueryItems.limit, value: "20")]
        ) { [weak self] request in
            self?.makeRequest(with: request, for: FeaturedPlaylistsResponse.self, completion: completion)
        }
    }
    
    public func getRecommendedGenres(completion: @escaping ((Result<RecommendedGenreResponse, Error>) -> Void)) {
        createRequest(with: "/recommendations/available-genre-seeds") { [weak self] request in
            self?.makeRequest(with: request, for: RecommendedGenreResponse.self, completion: completion)
        }
    }
    
    public func getRecommendations(genres: Set<String>, completion: @escaping ((Result<RecommendationsResponse, Error>) -> Void)) {
        let seeds = genres.joined(separator: ",")
        createRequest(
            with: "/recommendations",
            urlQuery: [
                URLQueryItem(name: APIQueryItems.limit, value: "50"),
                URLQueryItem(name: APIQueryItems.seedGenres, value: "\(seeds)")
            ]
        ) { [weak self] request in
            self?.makeRequest(with: request, for: RecommendationsResponse.self, completion: completion)
        }
    }
    
    // MARK: - Categories
    
    public func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        createRequest(
            with: "/browse/categories",
            urlQuery: [URLQueryItem(name: APIQueryItems.limit, value: "50")]
        ) { [weak self] request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil, let self = self else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try self.decoder.decode(AllCategoriesResponse.self, from: data)
                    completion(.success(result.categories.items))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    public func getCategoryPlaylists(category: Category, completion: @escaping (Result<[Playlist], Error>) -> Void) {
        createRequest(
            with: "/browse/categories/\(category.id)/playlists",
            urlQuery: [URLQueryItem(name: APIQueryItems.limit, value: "50")]
        ) { [weak self] request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil, let self = self else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try self.decoder.decode(CategoryPlaylistsResponse.self, from: data)
                    let playlists = result.playlists.items
                    completion(.success(playlists))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Search
    
    public func search(with query: String, completion: @escaping (Result<[SearchResult], Error>) -> Void) {
        createRequest(
            with: "/search",
            urlQuery: [
                URLQueryItem(name: APIQueryItems.limit, value: "10"),
                URLQueryItem(name: APIQueryItems.type, value: BaseAPI.searchQueryType),
                URLQueryItem(name: APIQueryItems.query, value: query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            ]
        ) { [weak self] request in
            let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                guard let data = data, error == nil, let self = self else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                
                do {
                    let result = try self.decoder.decode(SearchResultsResponse.self, from: data)
                    var searchResults = [SearchResult]()
                    searchResults.append(contentsOf: result.albums.items.compactMap(SearchResult.album))
                    searchResults.append(contentsOf: result.artists.items.compactMap(SearchResult.artist))
                    searchResults.append(contentsOf: result.playlists.items.compactMap(SearchResult.playlist))
                    searchResults.append(contentsOf: result.tracks.items.compactMap(SearchResult.track))
                    
                    completion(.success(searchResults))
                } catch {
                    print(error.localizedDescription)
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Private
    
    private func makeRequest<T: Codable>(with request: URLRequest, for type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil, let self = self else {
                completion(.failure(APIError.failedToGetData))
                return
            }
            
            do {
                let result = try self.decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    private func createRequest(
        with path: String,
        urlQuery items: [URLQueryItem]? = nil,
        type: HTTPMethod = .GET,
        completion: @escaping (URLRequest) -> Void
    ) {
        var compontens = URLComponents()
        compontens.scheme = BaseAPI.scheme
        compontens.host = BaseAPI.host
        compontens.path = BaseAPI.verison + path
        compontens.queryItems = items
        
        AuthManager.shared.withValidToken { token in
            guard let apiURL = compontens.url else {
                return
            }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
