//
//  DetailViewController.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/29.
//

import UIKit
import Kingfisher

class DetailViewController: BaseViewController {
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var isAdultLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet var rateImageViews: [UIImageView]!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var castLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    fileprivate let presenter = DetailPresenter(detailService: DetailService())
    
    fileprivate var castList = [Cast]()
    fileprivate var reviewList = [Review]()
    
    var id: Int = 0
    
    lazy var castCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cellWidth = 60
        let cellHeight = 60
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 17
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: CGFloat(cellHeight+8))
        collectionView.register(UINib(nibName: Constant.CastCollectionViewCellIdentifer, bundle: nil), forCellWithReuseIdentifier: Constant.CastCollectionViewCellIdentifer)
        
        return collectionView
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.text = "리뷰"
        label.textColor = .black
        label.font = UIFont.NotoSans(.bold, size: 16)
        
        return label
    }()
    
    lazy var reviewTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 116
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isScrollEnabled = false
        tableView.register(UINib(nibName: Constant.ReviewTableViewCellIdentifier, bundle: nil), forCellReuseIdentifier: Constant.ReviewTableViewCellIdentifier)
        return tableView
    }()
    
    init(id: Int) {
        super.init(nibName: nil, bundle: nil)
        self.id = id
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoView.layer.cornerRadius = 16

        posterImageView.layer.cornerRadius = 8
        
        let shadows = UIView()
        shadows.frame = posterImageView.frame
        shadows.clipsToBounds = false
        posterImageView.addSubview(shadows)

        let shadowPath0 = UIBezierPath(roundedRect: shadows.bounds, cornerRadius: 8)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 4
        layer0.shadowOffset = CGSize(width: 0, height: 0)
        layer0.bounds = shadows.bounds
        layer0.position = shadows.center
        shadows.layer.addSublayer(layer0)
        
        self.isAdultLabel.layer.cornerRadius = 2
        self.isAdultLabel.layer.borderWidth = 1
        
        setLayout()
        
        self.presenter.attachView(view: self)
        self.presenter.fetchInfo(id: self.id)
        self.presenter.fetchCast(id: self.id)
        self.presenter.fetchReview(id: self.id)
    }
    
    func setLayout() {
        self.infoView.addSubview(castCollectionView)
        castCollectionView.snp.makeConstraints { make in
            make.top.equalTo(self.castLabel.snp.bottom).offset(16)
            make.height.equalTo(70)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        self.infoView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(self.castCollectionView.snp.bottom).offset(24)
            make.leading.equalToSuperview().inset(16)
        }
        
        self.infoView.addSubview(reviewTableView)
        reviewTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(400)
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.bottom.equalTo(scrollView.snp.bottom).inset(50)
        }
    }
    
    func setRate(rate: Double) {
        let starsCount = Int(rate / 2)
        
        if starsCount == 5 {
            for i in 0..<starsCount {
                self.rateImageViews[i].image = UIImage.starFilled
            }
        } else {
            for i in 0...starsCount {
                self.rateImageViews[i].image = UIImage.starFilled
            }
            
            for i in starsCount..<5 {
                self.rateImageViews[i].image = UIImage.starEmpty
            }
        }
    }
}

//MARK: - CollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CastCollectionViewCellIdentifer, for: indexPath) as! CastCollectionViewCell
        
        let data = self.castList[indexPath.row]
        
        if let profilePath = data.profile_path {
            let downsamplingProcessor = DownsamplingImageProcessor(size: cell.profileImageView.frame.size)
            let roundCornerProcessor = RoundCornerImageProcessor(cornerRadius: cell.profileImageView.layer.cornerRadius)
            cell.profileImageView.kf.setImage(with: URL(string: Constant.BASE_IMAGE_URL + profilePath), options: [.processor(downsamplingProcessor |> roundCornerProcessor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage])
        } else {
            cell.profileImageView.image = UIImage()
        }
        
        cell.nameLabel.text = data.name
        cell.nameLabel.textColor = .black
        
        return cell
    }

}

//MARK: - TableViewDelegate
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.ReviewTableViewCellIdentifier, for: indexPath) as! ReviewTableViewCell
        
        cell.contentLabel.text = reviewList[indexPath.row].content
        cell.authorLabel.text = reviewList[indexPath.row].author
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
}

//MARK: - Detail View
extension DetailViewController: DetailView {
    
    func setInfo(_ movieInfo: DetailMovieResponse) {
        
        if let backdropPath = movieInfo.backdrop_path {
            let backDropDownsamplingProcessor = DownsamplingImageProcessor(size: self.backDropImageView.frame.size)
            self.backDropImageView.kf.setImage(with: URL(string: Constant.BASE_IMAGE_URL + backdropPath), options: [.processor(backDropDownsamplingProcessor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage])
        }
        
        self.nameLabel.text = movieInfo.title
        
        if movieInfo.adult {
            self.isAdultLabel.textColor = UIColor(red: 0.965, green: 0.376, blue: 0.376, alpha: 1)
        } else {
            self.isAdultLabel.textColor = UIColor(red: 0.725, green: 0.725, blue: 0.725, alpha: 1)
        }
        self.isAdultLabel.layer.borderColor = self.isAdultLabel.textColor.cgColor
        
        var genreArray: [String] = []
        
        for genre in movieInfo.genres {
            genreArray.append(genre.name)
        }
        let stringGenres = genreArray.joined(separator: ", ")
        self.genreLabel.text = stringGenres
        
        self.releaseDateLabel.text = movieInfo.release_date + " 발매"
        
        setRate(rate: movieInfo.vote_average)
        self.rateLabel.text = String(movieInfo.vote_average)
        
        self.overviewLabel.text = movieInfo.overview
        
        if let profilePath = movieInfo.poster_path {
            let posterDownsamplingProcessor = DownsamplingImageProcessor(size: self.posterImageView.frame.size)
            let roundCornerProcessor = RoundCornerImageProcessor(cornerRadius: self.posterImageView.layer.cornerRadius)
            self.posterImageView.kf.setImage(with: URL(string: Constant.BASE_IMAGE_URL + profilePath), options: [.processor(posterDownsamplingProcessor |> roundCornerProcessor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage])
        } else {
            self.posterImageView.image = UIImage()
        }
        
    }
    
    func setCast(_ castList: [Cast]) {
        self.castList = castList
        self.castCollectionView.reloadData()
    }
    
    func setReview(_ reviewList: [Review]) {
        self.reviewList = reviewList
        reviewTableView.reloadData()
        reviewTableView.snp.updateConstraints { make in
            make.height.equalTo(reviewTableView.contentSize.height)
        }
    }
}
