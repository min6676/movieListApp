//
//  MovieTableViewCell.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet var rateImageViews: [UIImageView]!
    @IBOutlet weak var movieGenreLable: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    var rate: Double = 10

    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageView.layer.cornerRadius = 8
        movieImageView.clipsToBounds = true
        
        let shadows = UIView()
        shadows.frame = movieImageView.frame
        shadows.clipsToBounds = false
        movieImageView.addSubview(shadows)

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
        
        movieNameLabel.font = UIFont.NotoSans(.medium, size: 10)
        movieNameLabel.textColor = .black
        movieGenreLable.font = UIFont.NotoSans(.regular, size: 9)
        movieGenreLable.textColor = UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
        movieDateLabel.font = UIFont.NotoSans(.regular, size: 9)
        movieDateLabel.textColor = UIColor(red: 0.604, green: 0.604, blue: 0.604, alpha: 1)
    }
    
    func setRate() {
        let starsCount = Int(self.rate / 2)
        
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
