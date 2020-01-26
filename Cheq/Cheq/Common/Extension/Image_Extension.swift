//
//  Image_Extension.swift
//  Cheq
//
//  Created by Xuwei Liang on 7/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// turns UIImage into gradient bar with given colors
    static func gradientImage(with bounds: CGRect,
                              colors: [CGColor],
                              locations: [NSNumber]?) -> UIImage? {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        // This makes it horizontal
        gradientLayer.startPoint = CGPoint(x: 0.0,
                                           y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0,
                                         y: 0.5)
        
        UIGraphicsBeginImageContext(gradientLayer.bounds.size)
        gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
