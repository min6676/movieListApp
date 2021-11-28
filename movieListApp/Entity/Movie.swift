//
//  Movie.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

import Foundation

struct MovieResponse: Decodable {
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}

struct Movie: Decodable {
    let id: Int
    let title: String
    let poster_path: String?
    let vote_average: Double
    let release_date: String
    let genre_ids: [Int]
}
