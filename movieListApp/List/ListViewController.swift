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
    fileprivate var upcomingList = [Movie]()
    fileprivate var popularList = [Movie]()
    fileprivate var topRatedList = [Movie]()
    fileprivate var genreDictionary = [Int:String]()
    
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
        collectionView.register(UINib(nibName: Constant.MovieCollectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constant.MovieCollectionViewCellIdentifier)
        
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
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(MovieTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: Constant.MovieTableViewHeaderFooterViewIdentifier)
        tableView.register(UINib(nibName: Constant.MovieTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: Constant.MovieTableViewCellIdentifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        presenter.attachView(view: self)
        self.presenter.fetchGenre(language: "en-US")
        self.presenter.fetchData(type: 0, page: self.currentPage)
        self.presenter.fetchData(type: 1, page: 1)
        self.presenter.fetchData(type: 2, page: 1)
        self.presenter.fetchData(type: 3, page: 1)
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
            make.bottom.equalToSuperview()
        }
    }
    
}


//MARK: - TableViewDelegate
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return upcomingList.count
        } else if section == 1 {
            return popularList.count
        } else {
            return topRatedList.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var data: Movie?
        var genres: [String] = []
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.MovieTableViewCellIdentifier, for: indexPath) as! MovieTableViewCell
        
        if indexPath.section == 0 {
            data = self.upcomingList[indexPath.row]
        } else if indexPath.section == 1 {
            data = self.popularList[indexPath.row]
        } else {
            data = self.topRatedList[indexPath.row]
        }
                
        cell.movieNameLabel.text = data!.title
        
        for id in data!.genre_ids {
            genres.append(self.genreDictionary[id] ?? "")
        }
        
        let stringGenres = genres.joined(separator: ", ")
        cell.movieGenreLable.text = stringGenres
        
        cell.movieDateLabel.text = data!.release_date
        let downsamplingProcessor = DownsamplingImageProcessor(size: cell.movieImageView.frame.size)
        let roundCornerProcessor = RoundCornerImageProcessor(cornerRadius: cell.movieImageView.layer.cornerRadius)
        cell.movieImageView.kf.setImage(with: URL(string: Constant.BASE_IMAGE_URL + data!.poster_path), options: [.processor(downsamplingProcessor |> roundCornerProcessor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage])

        cell.rate = data!.vote_average
        cell.setRate()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: Constant.MovieTableViewHeaderFooterViewIdentifier) as! MovieTableViewHeaderFooterView
        
        header.headerName = Constant.movieListHeaders[section]
        header.setLayout()
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            self.presenter.tappedCell(id: upcomingList[indexPath.row].id)
        } else if indexPath.section == 1 {
            self.presenter.tappedCell(id: popularList[indexPath.row].id)
        } else {
            self.presenter.tappedCell(id: topRatedList[indexPath.row].id)
        }
        
    }
}

//MARK: - CollectionViewDelegate
extension ListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.nowPlayingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.MovieCollectionViewCellIdentifier, for: indexPath) as! MovieCollectionViewCell
        let data = self.nowPlayingList[indexPath.row]
        cell.id = data.id
        cell.movieNameLabel.text = data.title
        let downsamplingProcessor = DownsamplingImageProcessor(size: cell.movieImageView.frame.size)
        let roundCornerProcessor = RoundCornerImageProcessor(cornerRadius: cell.movieImageView.layer.cornerRadius)
        cell.movieImageView.kf.setImage(with: URL(string: Constant.BASE_IMAGE_URL + data.poster_path), options: [.processor(downsamplingProcessor |> roundCornerProcessor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage])
        
        cell.rate = data.vote_average
        cell.setRate()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == nowPlayingList.count - 1 {
            DispatchQueue.main.async {
                self.currentPage += 1
                self.presenter.fetchData(type: 0, page: self.currentPage)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter.tappedCell(id: self.nowPlayingList[indexPath.row].id)
    }
}

//MARK: - ListView
extension ListViewController: ListView {
    
    func setGenreList(_ genres: [Int:String]) {
        self.genreDictionary = genres
    }
    
    func setList(_ movies: [Movie], type: Int) {
        
        if type == 0 {
            self.nowPlayingList += movies
            self.movieCollectionView.reloadData()
        } else if type == 1 {
            self.upcomingList = movies
            self.tableView.reloadData()
        } else if type == 2 {
            self.popularList = movies
            self.tableView.reloadData()
        } else {
            self.topRatedList = movies
            self.tableView.reloadData()
        }
        
    }
    
    func goToDetail(id: Int) {
        let detailVC = DetailViewController(id: id)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
