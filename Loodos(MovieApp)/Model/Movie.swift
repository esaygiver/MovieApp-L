//
//  Movie.swift
//  Loodos(MovieApp)
//
//  Created by admin on 18.02.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

struct Movie: Codable {

    let title: String
    let posterPath: String?
    let releaseDate: String
    let overview: String
    let id: Int?
    let backDrop: String?
    let rate: Double
    let videoPath: String?
    
    var posterURL: URL {
        return URL(string: "\(getURL(on: .imageURL))\(posterPath ?? "")")!
    }
    var backdropURL: URL {
        return URL(string: "\(getURL(on: .imageURL))\(backDrop ?? "")")!
    }
    
    private enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path", backDrop = "backdrop_path", rate = "vote_average", releaseDate = "release_date", title, overview, id, videoPath
    }
}

struct DataResults: Codable {
    let page: Int
    let movies: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case movies = "results", page
    }
}



