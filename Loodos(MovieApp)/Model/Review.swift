//
//  Review.swift
//  Loodos(MovieApp)
//
//  Created by admin on 18.02.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

struct Review: Codable {
    let content: String?
    let authorDetails: Author
    
    private enum CodingKeys: String, CodingKey {
        case content, authorDetails = "author_details"
    }
}

struct Author: Codable {
    let userName: String
    let rating: Double?
    
    private enum CodingKeys: String, CodingKey {
        case userName = "username", rating
    }
}

struct ReviewData: Codable {
    let review: [Review]
    
    private enum CodingKeys: String, CodingKey {
        case review = "results"
    }
}
