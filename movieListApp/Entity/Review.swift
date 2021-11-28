//
//  Review.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/29.
//

import Foundation

struct ReviewResponse: Decodable {
    let results: [Review]
}

struct Review: Decodable {
    let author: String
    let content: String
}
