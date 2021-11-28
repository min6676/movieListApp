//
//  Movie.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

struct MovieResponse: Decodable {
    let results: [Movie]
    let total_pages: Int
}

struct Movie: Decodable {
    let id: Int
    let backdrop_path: String
    let title: String
    let poster_path: String
    let vote_average: Double
}
