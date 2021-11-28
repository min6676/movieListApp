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
    
    fileprivate let presenter = DetailPresenter(detailService: DetailService())
    
    var id: Int = 0
    
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
        
        self.presenter.attachView(view: self)
        self.presenter.fetchData(id: self.id)
    }
    
    func setRate(rate: Double) {
        let starsCount = Int(rate / 2)
        
        for i in 0...starsCount {
            self.rateImageViews[i].image = UIImage.starFilled
        }
        
        for i in starsCount..<5 {
            self.rateImageViews[i].image = UIImage.starEmpty
        }
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
        
        let posterDownsamplingProcessor = DownsamplingImageProcessor(size: self.posterImageView.frame.size)
        let roundCornerProcessor = RoundCornerImageProcessor(cornerRadius: self.posterImageView.layer.cornerRadius)
        self.posterImageView.kf.setImage(with: URL(string: Constant.BASE_IMAGE_URL + movieInfo.poster_path), options: [.processor(posterDownsamplingProcessor |> roundCornerProcessor), .scaleFactor(UIScreen.main.scale), .cacheOriginalImage])
    }
    
}
