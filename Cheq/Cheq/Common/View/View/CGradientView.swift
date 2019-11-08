//
//  CGradientView.swift
//  Cheq
//
//  Created by Xuwei Liang on 8/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

public class CGradientView: UIView {
    
    @IBInspectable var startColor: UIColor! = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
    @IBInspectable var endColor: UIColor! = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)

    override public class var layerClass : AnyClass {
        return CAGradientLayer.self
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
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
