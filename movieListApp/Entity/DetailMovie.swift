//
//  DetailMovie.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/29.
//

import Foundation

struct DetailMovieResponse: Decodable {
    let adult: Bool
    let backdrop_path: String?
    let genres: [Genre]
    let id: Int
    let overview: String?
    let title: String
    let poster_path: String?
    let release_date: String
    let vote_average: Double   
}
