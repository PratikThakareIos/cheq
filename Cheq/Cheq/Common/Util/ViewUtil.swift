//
//  ViewUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 10/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class ViewUtil {
    static let shared = ViewUtil()
    private init() {}
    
    func circularMask(_ view: inout UIView) {
        view.layer.masksToBounds = false
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
    }

    func circularButton(_ button: inout CButton) {
        button.layer.masksToBounds = false
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
    }
    
    func applyViewGradient(_ view:UIView, startingColor: UIColor, endColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = view.frame
        gradient.colors = [
            startingColor.cgColor,
            endColor.cgColor
        ]
        gradient.locations = [0, 1]
        gradient.startPoint = CGPoint(x: 1, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        view.layer.insertSublayer(gradient, at: 0)
    }
}
