//
//  DetailViewController.swift
//  Loodos(MovieApp)
//
//  Created by admin on 18.02.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit
import Moya
import SafariServices
import FirebaseAnalytics

class DetailViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet var movieImage: UIImageView!
    @IBOutlet var movieTitle: UILabel!
    @IBOutlet var movieOverview: UITextView!
    @IBOutlet var movieRate: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var trailerAndReviewButton: UIButton!
    @IBOutlet var releaseDate: UILabel!
    @IBOutlet weak var castCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var embeddedVCHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollHeight: NSLayoutConstraint!
    
    private var cast = [Cast]()
    var selectedMovie: Movie!
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegation()
        updatingOutlets()
        getCast()
        setupUI()
        logMovieScreenViewEntry()
    }
    
    func setupUI() {
        castCollectionViewHeightConstraint.constant = 0
        embeddedVCHeight.constant = 0
        scrollHeight.constant = 665
        getCurvyButton(trailerAndReviewButton)
    }
    
    func setupDelegation() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func logMovieScreenViewEntry() {
        Analytics.logEvent("opened_movie_detail_screen", parameters: [
            "movie_id": "id-\(selectedMovie.id!)",
            "movie_title": selectedMovie.title,
        ])
    }
}

//MARK: - Updating Outlets
extension DetailViewController {
    func updatingOutlets() {
        movieTitle.text = self.selectedMovie.title
        movieOverview.text = self.selectedMovie.overview
        movieImage.fetchImage(from: selectedMovie.backdropURL.absoluteString)
        releaseDate.text = self.selectedMovie.releaseDate
        let rate = selectedMovie.rate
        switch Int(rate) {
        case 8...10:
            movieRate.text = "\(String(rate)) ⭐️⭐️⭐️⭐️⭐️"
        case 6...8:
            movieRate.text = "\(String(rate)) ⭐️⭐️⭐️⭐️"
        case 4...6:
            movieRate.text = "\(String(rate)) ⭐️⭐️⭐️"
        case 2...4:
            movieRate.text = "\(String(rate)) ⭐️⭐️"
        case 1...2:
            movieRate.text = "\(String(rate)) ⭐️"
        default:
            movieRate.text = "No rate given"
        }
    }
}

//MARK: - Embedding ExtraDetailVC to DetailVC part
extension DetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExtraDetailVC" {
            let destinationVC = segue.destination as! ExtraDetailViewController
            destinationVC.selectedMovieDetail = selectedMovie
        }
    }
}

//MARK: - Scrollable Trailer and Review Button
extension DetailViewController {
    @IBAction func trailerAndReviewButtonTapped(_ sender: UIButton) {
        if embeddedVCHeight.constant == 0 {
            scrollHeight.constant = 1300
            embeddedVCHeight.constant = 635
        } else {
            embeddedVCHeight.constant = 0
            scrollHeight.constant = 665
        }
    }
}
//MARK: - Network Request
extension DetailViewController {
    func getCast() {
        networkManager.fetchCast(movieID: self.selectedMovie.id ?? 399566) { [weak self] casts in
            guard let self = self else { return }
            self.cast = casts
            DispatchQueue.main.async {
                self.castCollectionViewHeightConstraint.constant = 170
                self.collectionView.reloadData()
            }
        }
    }
}

//MARK: - CollectionView Delegate and DataSource
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath) as! CastCollectionViewCell
        let selectedCell = cast[indexPath.row]
        cell.configureCast(model: selectedCell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selectedCastID = cast[indexPath.row].id
        let url = "\(getURL(on: .castTMDBPage))\(selectedCastID ?? 12345)"
        let vc = SFSafariViewController(url: URL(string: url)!)
        vc.modalPresentationStyle = .popover
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
}
//MARK: - Button with curves and shadows
extension DetailViewController {
    func getCurvyButton(_ button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2
    }
}
