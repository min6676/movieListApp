//
//  ListService.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

import Alamofire
import Foundation

class ListService {
    var locale: NSLocale
    var country: String?
    
    init() {
        locale = NSLocale.current as NSLocale
        country = locale.countryCode
    }
    
    func getList(type: Int, page: Int, completion: @escaping ([Movie]) -> Void ) {
        
        var url: String?
        
        switch type {
        case 1:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let today = formatter.string(from: Date())
            let weekLaterDay = formatter.string(from: Calendar.current.date(byAdding: .day, value: 10, to: Date())!)
            url = Constant.BASE_URL + "/discover/movie?release_date.gte=\(today)&release_date.lte=\(weekLaterDay)&with_release_type=2|3&"
        case 2:
            url = Constant.BASE_URL + "/movie/popular?"
        case 3:
            url = Constant.BASE_URL + "/movie/top_rated?"
        default:
            url = Constant.BASE_URL + "/movie/now_playing?"
        }
        url = url! + "api_key=\(K.API_KEY)&page=\(page)&language=en-US&region=\(country ?? "US")"
        
        let encodedString = url!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        
        AF.request(encodedString!, method: .get, encoding: JSONEncoding.default).validate().responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(response.results)
            case .failure:
                print(response)
                print("Network Error")
            }
        }
    }
    
    func getGenreList(language: String, completion: @escaping ([Genre]) -> Void ) {
        
        let url = Constant.BASE_URL + "/genre/movie/list?language=\(language)&api_key=\(K.API_KEY)"
        
        let encodedString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        
        AF.request(encodedString, method: .get, encoding: JSONEncoding.default).validate().responseDecodable(of: GenreResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(response.genres)
            case .failure:
                print("Network Error")
            }
        }
    }
}

