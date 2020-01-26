//
//  UIView_Extension.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/// enum to represent different side of view
enum ViewSide {
    case Left, Right, Top, Bottom
}

extension UIView {
    
    /// This extension method makes corners of current view round. We have other methods that does the same thing. I don't recommend using this method. Use **ViewUtil** or **AppConfig.shared.activeTheme.cardStyling** method instead
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

extension UIView {
    
    /// Wraps the logic to load view from NIB
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
