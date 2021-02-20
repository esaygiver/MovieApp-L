//
//  NetworkManager.swift
//  Loodos(MovieApp)
//
//  Created by admin on 18.02.2021.
//  Copyright © 2021 esaygiver. All rights reserved.
//

import Foundation
import Moya

class NetworkManager {
    
    var provider = MoyaProvider<MovieAPI>(plugins: [NetworkLoggerPlugin()])

        func searchMovies(query: String, completion: @escaping ([Movie]) -> ()) {
            provider.request(.search(query: query)) { result in
                switch result {
                case let .success(response):
                    do {
                        let results = try JSONDecoder().decode(DataResults.self, from: response.data)
                        completion(results.movies)
    //                    print(results.movies.first?.title)
                    } catch let error {
                        dump(error)
                    }
                case let .failure(error):
                    dump(error)
                }
            }
        }
        
        func fetchPopularMovies(completion: @escaping ([Movie]) -> ()) {
            provider.request(.popular) { result in
                switch result {
                case let .success(response):
                    do {
                        let results = try JSONDecoder().decode(DataResults.self, from: response.data)
                        completion(results.movies)
                    } catch let error {
                        dump(error)
                    }
                case let .failure(error):
                    dump(error)
                }
            }
        }
        
        
        func fetchCast(movieID: Int, completion: @escaping ([Cast]) -> ()) {
            provider.request(.cast(movieID: movieID)) { result in
                switch result {
                case let .success(response):
                    do {
                        let results = try JSONDecoder().decode(CastResponseModel.self, from: response.data)
                        completion(results.cast)
                    } catch let error {
                        dump(error)
                    }
                case let .failure(error):
                    dump(error)
                }
            }
        }
        
        public func fetchVideo(movieID: Int, completion: @escaping ([Video]) -> ()) {
            provider.request(.video(movieID: movieID)) { result in
                switch result {
                case let .success(response):
                    do {
                        let results = try JSONDecoder().decode(VideoResults.self, from: response.data)
                        completion(results.videos)
                    } catch let error {
                        dump(error)
                    }
                case let .failure(error):
                    dump(error)
                }
            }
        }
        
        public func fetchReviews(movieID: Int, completion: @escaping ([Review]) -> ()) {
            provider.request(.review(movieID: movieID)) { result in
                switch result {
                case let .success(response):
                    do {
                        let results = try JSONDecoder().decode(ReviewData.self, from: response.data)
                        completion(results.review)
                    } catch let error {
                        dump(error)
                    }
                case let .failure(error):
                    dump(error)
                }
            }
        }
    }
