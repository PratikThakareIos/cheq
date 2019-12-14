//
//  ViewUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 10/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/// radiusBy enum is used by **ViewUtil** **circularMask** method to determine whether we calculate the radius amount for a given view by its height or width. This will determine if the roundness is proportion. Because **circularMask** will calculate the radius as half of either width or height. The code to use **circularMask** should decide which edge is shorter to ensure the radius amount is not too large for the shorter sides.
enum radiusBy {
    case height
    case width
}

/**
 UIView utility class. Contains helper methods that applies configurable styling to given view. These helper methods works in complementary with AppConfig.shared.activeTheme's styling methods.
 */
class ViewUtil {
    
    /// Singleton instance of **ViewUtil**
    static let shared = ViewUtil()
    
    /// private init method to ensure **ViewUtil** will be Singleton
    private init() {}
    
    /// This method modifies the given to have rounded edges. Radius value is calculated by the sides specified by **radiusBy** enum.
    func circularMask(_ view: inout UIView, radiusBy: radiusBy) {
        view.layer.masksToBounds = false
        if radiusBy == .height {
            view.layer.cornerRadius = view.frame.height / 2
        } else {
            view.layer.cornerRadius = view.frame.width / 2
        }
        view.clipsToBounds = true
    }

    /**
     This method modifies the given **CButton** with rounded edges. The cornerRadius amount is defaulted to be based on height, because we don't have vertical buttons. But this logic is subjected to change if vertical button is introduced.
     */
    func circularButton(_ button: inout CButton) {
        button.layer.masksToBounds = false
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
    
    /**
     This method adds border to a given view's reference.
     - parameter view: reference of UIView to get modified.
     - parameter borderSize: thickness of the border
     - parameter color: color of the border size
     */
    func applyBorder(_ view: inout UIView, borderSize: CGFloat, color: UIColor) {
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = borderSize
    }
    
    /**
     Applying gradient border to the given view with borderSize and a list of colors
     - parameter view: reference of UIView to get modified.
     - parameter borderSize: thickness of the border
     - parameter colors: colors use for building the gradient border
     */
    func applyGradientBorder(_ view: inout UIView, borderSize: CGFloat, colors: [UIColor]) {
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: view.frame.size)
        gradient.colors = colors.map { $0.cgColor }
        
        // create the shape for masking the gradient
        let shape = CAShapeLayer()
        shape.lineWidth = borderSize
        shape.path = UIBezierPath(roundedRect: view.layer.bounds, cornerRadius: view.layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        gradient.mask = shape
        
        // apply to view
        view.layer.addSublayer(gradient)
    }
    
    /**
     Adding gradient background to the reference view.
     - parameter startingColor: starting color of the gradient background, this is left and bottom position.
     - parameter endColor: ending color of the gradient background, this is right and top position.
     */
    func applyViewGradient(_ view:UIView, startingColor: UIColor, endColor: UIColor)->CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [
            startingColor.cgColor,
            endColor.cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
