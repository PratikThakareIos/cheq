//
//  AutoLayout.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 9/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

enum VeriticalAlignment {
    case top
    case centre
    case bottom
}

struct AutoLayoutUtil {

    static func pinToSuperview(_ view: UIView, height: CGFloat, alignment: VeriticalAlignment) {
        guard let superview = view.superview else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        switch alignment {
        case .top:
            let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: 0.0)
            let left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: 0.0)
            let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height)
            superview.addConstraints([top, left, right, heightConstraint])
        case .centre:
            let left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: 0.0)
            let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height)
            let verticalAlign = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            superview.addConstraints([verticalAlign, left, right, heightConstraint])
        case .bottom:
            let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            let left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: 0.0)
            let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: height)
            superview.addConstraints([bottom, left, right, heightConstraint])
        }
    }

    static func pinToSuperview(_ view: UIView, horizontalPadding: CGFloat, verticalPadding: CGFloat) {
        guard let superview = view.superview else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: verticalPadding)
        let left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: horizontalPadding)
        let right = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: -1*horizontalPadding)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: -1*verticalPadding)
        superview.addConstraints([top, left, right, bottom])
    }

    static func pinToSuperview(_ view: UIView, padding: CGFloat) {
        guard let superview = view.superview else { return }
        
        view.translatesAutoresizingMaskIntoConstraints = false 
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: padding)
        let left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: padding)
        let right = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: padding)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: padding)
        superview.addConstraints([top, left, right, bottom])
    }
}
