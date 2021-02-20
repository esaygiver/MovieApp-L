//
//  ExtraDetailViewController.swift
//  Loodos(MovieApp)
//
//  Created by admin on 18.02.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import UIKit
import Moya

class ExtraDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var webView: UIWebView!
    @IBOutlet var tableView: UITableView!
    
    private var review = [Review]()
    private var trailer = [Video]()
    var selectedMovieDetail: Movie!
    
    public var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getVideo()
        getReviews()
    }
}

//MARK: - Review and Trailer Request Part
extension ExtraDetailViewController {
    func getReviews() {
        networkManager.fetchReviews(movieID: self.selectedMovieDetail.id ?? 399566) { reviews in
            self.review = reviews
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func getVideo() {
        networkManager.fetchVideo(movieID: self.selectedMovieDetail.id ?? 399566) { videos in
            self.trailer = videos
            if let url = URL(string: "https://www.youtube.com/watch?v=\(self.trailer.first?.key ?? "" )") {
                DispatchQueue.main.async {
                    self.webView.loadRequest(URLRequest(url: url))
                }
            }
            
        }
    }
}

//MARK: - TableView Part
extension ExtraDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return review.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewTableViewCell
        cell.configureReviews(model: review[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

