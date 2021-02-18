//
//  Video.swift
//  Loodos(MovieApp)
//
//  Created by admin on 18.02.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation

struct Video: Codable {
    let key: String
    
    private enum CodingKeys: String, CodingKey {
        case key
    }
}

struct VideoResults: Codable {
    let videos: [Video]
    
    private enum CodingKeys: String, CodingKey {
        case videos = "results"
    }
}
