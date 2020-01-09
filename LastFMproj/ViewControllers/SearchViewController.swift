//
//  ViewController.swift
//  LastFMproj
//
// 
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    
    let viewModel = ViewModel()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearch()
        createSearch()
        
    }
    //Create Search
    
    func createSearch() {
        searchController.searchBar.placeholder = "Search .FM Station "
        //searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    @objc func searchUpdate() {
        
        DispatchQueue.main.async {
            self.searchTableView.reloadData()
        }
        
        print("Search Reloaded")
    }
    
    //Setup Search
    
    func setupSearch() {
        searchTableView.register(UINib(nibName: ContentTableCell.identifier, bundle: Bundle.main), forCellReuseIdentifier: ContentTableCell.identifier)
        searchTableView.tableFooterView = UIView(frame: .zero)
        NotificationCenter.default.addObserver(self, selector: #selector(searchUpdate), name: Notification.Name.ArtistNotification, object: nil)
    }
}

//TableView

extension SearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableCell.identifier, for: indexPath) as! ContentTableCell
        
        let artist = viewModel.artists[indexPath.row]
        let content = Content.artist(artist)
        cell.configure(with: content)
        
        return cell
    }
    
    
}

extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let artist = viewModel.artists[indexPath.row]
        viewModel.currentArtist = artist
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let albumVC = storyboard.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
        albumVC.viewModel = viewModel
        albumVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(albumVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

//SearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let search = searchBar.text?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        viewModel.getArtists(with: search)
    }
}
