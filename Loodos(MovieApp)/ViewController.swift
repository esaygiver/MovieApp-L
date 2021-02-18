//
//  ViewController.swift
//  Loodos(MovieApp)
//
//  Created by admin on 18.02.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var collectionView: UICollectionView!
    
    var movies = [Movie]()
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
}

//MARK: - Search CollectionViewCell Delegate&Datasource
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchMovieCell", for: indexPath)
        return cell
    }
    
    
}
