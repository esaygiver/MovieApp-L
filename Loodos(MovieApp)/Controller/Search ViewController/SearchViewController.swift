//
//  ViewController.swift
//  Loodos(MovieApp)
//
//  Created by admin on 18.02.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

enum SearchListState {
    case loading, loaded, empty
}

class SearchViewController: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var movieListActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var emptyStateView: UIView!
    
    var movies = [Movie]()
    var popularMovies = [Movie]()
    var networkManager = NetworkManager()
    
    var screenState: SearchListState? {
        didSet {
            if screenState == .loading {
                emptyStateView.isHidden = true
                movieListActivityIndicator.isHidden = false
                movieListActivityIndicator.startAnimating()
                collectionView.isHidden = true
            } else if screenState == .loaded {
                emptyStateView.isHidden = true
                movieListActivityIndicator.isHidden = true
                movieListActivityIndicator.stopAnimating()
                collectionView.isHidden = false
            } else {
                emptyStateView.isHidden = false
                movieListActivityIndicator.isHidden = true
                movieListActivityIndicator.stopAnimating()
                collectionView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegations()
        fetchPopularMovies()
    }
    
    func setupDelegations() {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
    }
}

//MARK: - Network Request
extension SearchViewController {
    func fetchMovies(query: String) {
        self.screenState = .loading
        networkManager.searchMovies(query: query) { [weak self] (results) in
            guard let self = self else { return }
            if results.isEmpty {
                self.screenState = .empty
            } else {
                self.movies = results
                self.screenState = .loaded
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchPopularMovies() {
        self.screenState = .loading
        networkManager.fetchPopularMovies { [weak self] (results) in
            guard let self = self else { return }
            if results.isEmpty {
                self.screenState = .empty
            } else {
                self.movies = results
                self.popularMovies = results
                self.screenState = .loaded
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
         searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.movies = popularMovies
        self.screenState = movies.isEmpty ? .empty : .loaded
        searchBar.endEditing(true)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let query = searchBar.text else { return }
        if !query.isEmpty {
            fetchMovies(query: query)
        } else {
            self.movies = popularMovies
            self.screenState = movies.isEmpty ? .empty : .loaded
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: - Search CollectionViewCell Delegate & Datasource & FlowLayout
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchMovieCell", for: indexPath) as! SearchCollectionViewCell
        let selectedCell = movies[indexPath.row]
        cell.configureOutlets(with: selectedCell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedMovieInSearchVC = movies[indexPath.row]
        let detailViewController = storyboard?.instantiateViewController(identifier: "DetailViewController") as! DetailViewController
        detailViewController.selectedMovie = selectedMovieInSearchVC
        detailViewController.modalTransitionStyle = .flipHorizontal
        self.present(detailViewController, animated: true)

    }
    
}
