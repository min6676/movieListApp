//
//  movieCollectionViewCell.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet var rateImageViews: [UIImageView]!
    var rate: Int = 5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        movieImageView.snp.makeConstraints { make in
            make.width.equalTo(UIScreen.main.bounds.width * 0.33)
        }
        movieNameLabel.font = UIFont.NotoSans(.medium, size: 12)
    }
    
    func setRate() {
        for i in 0...rate {
            self.rateImageViews[i].image = UIImage.starFilled
        }
        
        for i in rate..<5 {
            self.rateImageViews[i].image = UIImage.starEmpty
        }
    }

}
