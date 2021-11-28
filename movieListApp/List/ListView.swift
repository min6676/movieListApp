//
//  ListView.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

import Foundation

protocol ListView: NSObjectProtocol {
    func setList(_ movies: [Movie], moreFetch: Bool)
}
