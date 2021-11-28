//
//  CastCollectionViewCell.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/29.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
    }

}
