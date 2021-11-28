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
                print(response)
                print("Network Error")
            }
        }
    }
    
    func getCast(id: Int, language: String, completion: @escaping ([Cast]) -> Void ) {
        
        let url = Constant.BASE_URL + "/movie/\(id)/credits?api_key=\(K.API_KEY)&language=\(language)"
        
        let encodedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        
        AF.request(encodedString, method: .get, encoding: JSONEncoding.default).validate().responseDecodable(of: CreditResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(response.cast)
            case .failure:
                print("Network Error")
            }
        }
    }
    
    func getReview(id: Int, language: String, completion: @escaping ([Review]) -> Void ) {
        
        let url = Constant.BASE_URL + "/movie/\(id)/reviews?api_key=\(K.API_KEY)&language=\(language)"
        
        let encodedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        
        AF.request(encodedString, method: .get, encoding: JSONEncoding.default).validate().responseDecodable(of: ReviewResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(response.results)
            case .failure:
                print("Network Error")
            }
        }
    }
}
