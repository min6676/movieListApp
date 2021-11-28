//
//  ListService.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

import Alamofire

class ListService {
    func getList(type: Int, page: Int, completion: @escaping ([Movie], Bool) -> Void ) {
        var url: String?
        
        switch type {
        case 1:
            url = Constant.BASE_URL + "search/users?&page=1"
        case 2:
            url = Constant.BASE_URL + "search/users?&page=1"
        case 3:
            url = Constant.BASE_URL + "search/users?&page=1"
        default:
            url = Constant.BASE_URL + "/now_playing?page=\(page)"
        }
        url = url! + "&language=en-US&api_key=\(K.API_KEY)"
        
        let encodedString = url!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? url
        
        AF.request(encodedString!, method: .get, encoding: JSONEncoding.default).validate().responseDecodable(of: MovieResponse.self) { response in
            switch response.result {
            case .success(let response):
                var isResult = true
                if response.total_pages >= page {
                    isResult = true
                } else {
                    isResult = false
                }
                completion(response.results, isResult)
            case .failure:
                print("Network Error")
            }
        }
    }
    
}

