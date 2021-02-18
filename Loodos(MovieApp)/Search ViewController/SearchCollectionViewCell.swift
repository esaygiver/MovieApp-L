//
//  SearchCollectionViewCell.swift
//  Loodos(MovieApp)
//
//  Created by admin on 18.02.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieImage: UIImageView!
    
    func configureOutlets(with model: Movie) {
        self.movieTitle.text = model.title
        self.movieImage.fetchImage(from: model.posterURL.absoluteString)
        }
}

