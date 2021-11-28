//
//  DetailPresenter.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/29.
//

class DetailPresenter {
    private let service: DetailService
    weak fileprivate var detailView: DetailView?
    
    init(detailService: DetailService) {
        self.service = detailService
    }
    
    func attachView(view: DetailView) {
        detailView = view
    }
    
    func detachView() {
        detailView = nil
    }
    
    func fetchData(id: Int) {
        self.service.getDetail(id: id, language: "ko-KR") { [weak self] movieInfo in
            self?.detailView?.setInfo(movieInfo)
        }
    }
    
}
