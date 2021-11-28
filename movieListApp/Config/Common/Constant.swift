//
//  Constant.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

struct Constant {
    static let BASE_URL = "https://api.themoviedb.org/3"
    static let BASE_IMAGE_URL = "https://image.tmdb.org/t/p/original"
    
    // 본인의 api 키를 입력해주세요.
    static let API_KEY = K.API_KEY
    
    // Cell Identifer
    static let MovieCollectionViewCellIdentifier = "MovieCollectionViewCell"
    static let MovieTableViewCellIdentifier = "MovieTableViewCell"
    static let MovieTableViewHeaderFooterViewIdentifier = "MovieTableViewHeaderFooterView"
    static let CastCollectionViewCellIdentifer = "CastCollectionViewCell"
    
    // List Headers
    static let movieListHeaders = ["개봉 예정", "인기", "높은 평점"]
}
