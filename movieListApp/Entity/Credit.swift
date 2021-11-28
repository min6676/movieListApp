//
//  Credit.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/29.
//

import Foundation

struct CreditResponse: Decodable {
    let cast: [Cast]
}

struct Cast: Decodable {
    let name: String
    let profile_path: String?
}
