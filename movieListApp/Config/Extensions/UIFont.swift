//
//  UIFont.swift
//  movieListApp
//
//  Created by 김민순 on 2021/11/28.
//

import Foundation
import UIKit

extension UIFont {
    public enum NotoSansType: String {
        case medium = "Medium"
        case bold = "Bold"
        case regular = "Regular"
    }

    static func NotoSans(_ type: NotoSansType, size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansCJKkr-\(type.rawValue)", size: size)!
    }
}
