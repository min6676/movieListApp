//
//  ListPresenter.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

class ListPresenter {
    private let service: ListService
    weak fileprivate var listView: ListView?
    
    var movieList: [Movie] = []
    
    init(listService: ListService) {
        self.service = listService
    }
    
    func attachView(view: ListView) {
        listView = view
    }
    
    func detachView() {
        listView = nil
    }
    
    func fetchData(type: Int, page: Int) {
        self.service.getList(type: type, page: page) { [weak self] movieList, isResult in
            if isResult {
                self?.listView?.setList(movieList, moreFetch: true)
            }
        }
    }
    
}
