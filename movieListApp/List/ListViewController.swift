//
//  ListViewController.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

import UIKit
import SnapKit
import Kingfisher

class ListViewController: BaseViewController {
    
    fileprivate var nowPlayingList = [Movie]()
    fileprivate let presenter = ListPresenter(listService: ListService())
    
    private var moreFetch: Bool = false
    private var currentPage = 1
    
    lazy var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellWidth = UIScreen.main.bounds.width * 0.33
        let cellHeight = cellWidth * 1.65 + 28
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 17
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: cellHeight+8)
        collectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "movieCollectionViewCell")
        
        return collectionView
    }()
    
    lazy var headerView: UIView = {
        let header = UIView()
        header.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: movieCollectionView.bounds.height + 69)
        
        let label = UILabel()
        label.text = "현재 상영중"
        label.font = UIFont.NotoSans(.bold, size: 20)
        label.textColor = .black
        
        header.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().inset(20)
        }
        
        header.addSubview(movieCollectionView)
        movieCollectionView.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        return header
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 77
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        presenter.attachView(view: self)
        self.presenter.fetchData(type: 0, page: self.currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setLayout() {
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
}


//MARK: - TableViewDelegate
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

//MARK: - CollectionViewDelegate
extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nowPlayingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let data = self.nowPlayingList[indexPath.row]
        cell.movieNameLabel.text = data.title
        let downsamplingProcessor = DownsamplingImageProcessor(size: cell.movieImageView.frame.size)
        let roundCornerProcessor = RoundCornerImageProcessor(cornerRadius: cell.movieImageView.layer.cornerRadius)
        cell.movieImageView.kf.setImage(with: URL(string: Constant.BASE_IMAGE_URL + data.poster_path), options: [.processor(downsamplingProcessor |> roundCornerProcessor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage])
        
        cell.rate = data.vote_average
        cell.setRate()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == nowPlayingList.count - 3 {
            DispatchQueue.main.async {
                self.currentPage += 1
                self.presenter.fetchData(type: 0, page: self.currentPage)
            }
        }
    }
}

//MARK: - ListView

extension ListViewController: ListView {
    func setList(_ movies: [Movie], moreFetch: Bool) {
        self.nowPlayingList += movies
        self.movieCollectionView.reloadData()
    }
}
