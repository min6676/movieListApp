//
//  ListPresenter.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

class ListPresenter {
    private let service: ListService
    weak fileprivate var listView: ListView?
    
    init(listService: ListService) {
        self.service = listService
    }
    
    func attachView(view: ListView) {
        listView = view
    }
    
    func detachView() {
        listView = nil
    }
    
    func fetchGenre(language: String) {
        self.service.getGenreList(language: language) { genreList in
            var genreDictionary: [Int:String] = Dictionary()
            for genre in genreList {
                genreDictionary[genre.id] = genre.name
            }
            
            self.listView?.setGenreList(genreDictionary)
        }
    }
    
    func fetchData(type: Int, page: Int) {
        self.service.getList(type: type, page: page) { [weak self] movieList in
            if type == 0 {
                self?.listView?.setList(movieList, type: type)
            } else {
                if movieList.count > 3 {
                    let movies = movieList[0..<3]
                    self?.listView?.setList(Array(movies), type: type)
                } else {
                    self?.listView?.setList(movieList, type: type)
                }
            }
        }
    }
    
    func tappedCell(id: Int) {
        self.listView?.goToDetail(id: id)
    }
}
