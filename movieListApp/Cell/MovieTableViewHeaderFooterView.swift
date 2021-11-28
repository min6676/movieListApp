//
//  MovieTableViewHeaderFooterView.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

import UIKit

class MovieTableViewHeaderFooterView: UITableViewHeaderFooterView {

    var headerName: String?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var headerLable: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.NotoSans(.bold, size: 20)
        label.textColor = .black
        
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(headerLable)
    }
    
    func setLayout() {
        self.headerLable.text = headerName ?? ""
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        headerLable.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}
