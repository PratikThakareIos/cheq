//
//  ViewUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 10/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

enum radiusBy {
    case height
    case width
}

class ViewUtil {
    static let shared = ViewUtil()
    private init() {}
    
    func circularMask(_ view: inout UIView, radiusBy: radiusBy) {
        view.layer.masksToBounds = false
        if radiusBy == .height {
            view.layer.cornerRadius = view.frame.height / 2
        } else {
            view.layer.cornerRadius = view.frame.width / 2
        }
        view.clipsToBounds = true
    }

    func circularButton(_ button: inout CButton) {
        button.layer.masksToBounds = false
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
    
    func applyBorder(_ view: inout UIView, borderSize: CGFloat, color: UIColor) {
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = borderSize
    }
    
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
