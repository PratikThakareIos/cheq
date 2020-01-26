//
//  AutoLayout.swift
//  CheqDemo
//
//  Created by XUWEI LIANG on 9/8/19.
//  Copyright © 2019 WiseTree Solutions Pty Ltd. All rights reserved.
//

import UIKit

/**
 Enum used by **AutoLayoutUtil** to determine how to align a given view to its superview.
 */
enum VeriticalAlignment {
    case top
    case centre
    case bottom
}

/**
 Helper method for applying autolayout constraints for a given view and its superview. Use **AutoLayoutUtil** when we want to programmatically setup autolayout constraints.
 */
struct AutoLayoutUtil {

    /**
     This version of **pinToSuperview** takes a view with given height and pin its edge to its superview depending on the provided **VeriticalAlignment** configuration.
     - parameter view: View to have autolayout constraints setup against its superview.
     - parameter height: Given height for the view, this is useful when we know our view has a constant height calculated or defined.
     - parameter alignment: VeriticalAlignment.top will have the view pin itself to the top, left, right margin of its superview. VeriticalAlignment.bottom will have the view pin itself to the bottom, left, right margin of its superview. VeriticalAlignment.center will align the view's vertical center to superview's vertical center and pin to left, right of the superview's margin.
     */
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

    /**
     This version of **pinToSuperview** will pin the given view to all margins of its superview with paddings. **horizontalPadding** and **verticalPadding** provided drives the spacing.
     - parameter view: view to be added with autolayout constraints
     - parameter horizontalPadding: this is the spacing between the left and right margins of view and its superview
     - parameter verticalPadding: this is the spacing between the top and bottom margins of view and its superview
     */
    static func pinToSuperview(_ view: UIView, horizontalPadding: CGFloat, verticalPadding: CGFloat) {
        guard let superview = view.superview else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1.0, constant: verticalPadding)
        let left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: superview, attribute: .left, multiplier: 1.0, constant: horizontalPadding)
        let right = NSLayoutConstraint(item: view, attribute: .right, relatedBy: .equal, toItem: superview, attribute: .right, multiplier: 1.0, constant: -1*horizontalPadding)
        let bottom = NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1.0, constant: -1*verticalPadding)
        superview.addConstraints([top, left, right, bottom])
    }

    /**
     This version of **pinToSuperview** will pin the given view to all margins of its superview with a constant spacing on all sides.
     - parameter view: view to have autolayout constraints added
     - parameter padding: the constant padding on all sides between view and its superview 
     */
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
