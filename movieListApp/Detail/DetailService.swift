//
//  DetailService.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/29.
//

import Alamofire
import Foundation

class DetailService {
    
    func getDetail(id: Int, language: String, completion: @escaping (DetailMovieResponse) -> Void ) {
        
        let url = Constant.BASE_URL + "/movie/\(id)?api_key=\(K.API_KEY)&language=\(language)"
        
        let encodedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        
        AF.request(encodedString, method: .get, encoding: JSONEncoding.default).validate().responseDecodable(of: DetailMovieResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(response)
            case .failure:
                print("Network Error")
            }
        }
    }
    
}
