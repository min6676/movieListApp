//
//  DetailView.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/29.
//

import Foundation

protocol DetailView: NSObjectProtocol {
    func setInfo(_ movieInfo: DetailMovieResponse)
}
