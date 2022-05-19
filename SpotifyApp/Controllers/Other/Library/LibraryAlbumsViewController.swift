//
//  LibraryAlbumsViewController.swift
//  SpotifyApp
//
//  Created by Dmitry Pyzhov on 13.05.2022.
//

import UIKit

private enum Constants {
    static let cellHeight: CGFloat = 65

    static let noAlbumsViewFrameWidth: CGFloat = 150
    static let noAlbumsViewFrameHeight: CGFloat = 150
}

class LibraryAlbumsViewController: UIViewController {
        
    var albums = [Album]()
    
    private let noAlbumsView = ActionLabelView()
    
    private var observer: NSObjectProtocol?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier
        )
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        setUpTableView()
        setUpNoAlbumsView()
        fetchAlbums()
        observer = NotificationCenter.default.addObserver(
            forName: .albumSavedNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                self?.fetchAlbums()
            }
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumsView.frame = CGRect(
            x: (view.width - Constants.noAlbumsViewFrameWidth) / 2,
            y: (view.height - Constants.noAlbumsViewFrameHeight) / 2,
            width: Constants.noAlbumsViewFrameWidth,
            height: Constants.noAlbumsViewFrameHeight
        )
        tableView.frame = view.bounds
    }
    
    private func updateUI() {
        if albums.isEmpty {
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        } else {
            noAlbumsView.isHidden = true
            tableView.reloadData()
            tableView.isHidden = false
        }
    }
    
    private func setUpNoAlbumsView() {
        noAlbumsView.delegate = self
        view.addSubview(noAlbumsView)
        noAlbumsView.configure(
            with: ActionLabelViewViewModel(
                text: "You have not saved any albums yet.",
                actionTitle: "Browse"
            )
        )
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }
    
    private func fetchAlbums() {
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Gestures
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
}

// MARK: - ActionLabelView Delegate

extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}

// MARK: - TableView DataSource

extension LibraryAlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultSubtitleTableViewCell.identifier
        ) as? SearchResultSubtitleTableViewCell else {
            return UITableViewCell()
        }
        
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(
            title: album.name,
            subtitle: album.artists.first?.name ?? "-",
            imageURL: URL(string: album.images.first?.url ?? ""))
        )
        
        return cell
    }
}

// MARK: - TableView Delegate

extension LibraryAlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        HapticsManager.shared.vibrateForSelection()
        
        let album = albums[indexPath.row]
        let albumViewController = AlbumViewController(album: album)
        albumViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(albumViewController, animated: true)
    }
}
