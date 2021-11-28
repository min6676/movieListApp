//
//  Genre.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

import Foundation

struct GenreResponse: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
