//
//  CGradientView.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//
import UIKit

/**
 Custom UIVIew to have a gradient background color.
 */
public class CGradientView: UIView {
    
    /// startColor is inspectable in storyboard
    @IBInspectable var startColor: UIColor! = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
    
    /// endColor is inspectable in storyboard
    @IBInspectable var endColor: UIColor! = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)

    /// returning gradient layer for its layerClass
    override public class var layerClass : AnyClass {
        return CAGradientLayer.self
    }
    
    /// called when initialized using xib or storyboard
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    /// overriding **prepareForInterfaceBuilder** allows view to be rendered while in storyboard
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupUI()
    }
    
    func setupUI() {
        let colors = [ startColor.cgColor, endColor.cgColor ]
        if let gradient = self.layer as? CAGradientLayer {
            gradient.colors = colors
            gradient.locations = [0, 1]
            gradient.startPoint = CGPoint(x: 1, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
        }
    }
}
