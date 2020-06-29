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
            
            /// top-left corner of the screen (x = 0.0, y = 0.0), bottom-right corner is the ending point (x = 1.0, y = 1.0)
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }
    }
}


public class CGradientViewDisable: UIView {
    

    /// startColor is inspectable in storyboard
    @IBInspectable var startColor: UIColor! =  UIColor(hex: "FF8141") //UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1.0)
    
    /// endColor is inspectable in storyboard
    @IBInspectable var endColor: UIColor! =  UIColor(hex: "D60A5F")  //UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 1.0)

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
            
            gradient.locations = (0..<colors.count).map(NSNumber.init) //[0, 1]
            
            /// top-left corner of the screen (x = 0.0, y = 0.0), bottom-right corner is the ending point (x = 1.0, y = 1.0)
            gradient.startPoint = CGPoint(x: 0.5, y: 0) //(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 1.0) //CGPoint(x: 0.5, y: 1.0)
        }
    }
}







extension CAGradientLayer {
    enum Point {
        case topLeft
        case centerLeft
        case bottomLeft
        case topCenter
        case center
        case bottomCenter
        case topRight
        case centerRight
        case bottomRight
        var point: CGPoint {
            switch self {
            case .topLeft:
                return CGPoint(x: 0, y: 0)
            case .centerLeft:
                return CGPoint(x: 0, y: 0.5)
            case .bottomLeft:
                return CGPoint(x: 0, y: 1.0)
            case .topCenter:
                return CGPoint(x: 0.5, y: 0)
            case .center:
                return CGPoint(x: 0.5, y: 0.5)
            case .bottomCenter:
                return CGPoint(x: 0.5, y: 1.0)
            case .topRight:
                return CGPoint(x: 1.0, y: 0.0)
            case .centerRight:
                return CGPoint(x: 1.0, y: 0.5)
            case .bottomRight:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
    
    convenience init(start: Point, end: Point, colors: [CGColor], type: CAGradientLayerType) {
        self.init()
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.locations = (0..<colors.count).map(NSNumber.init)
        self.type = type
    }
}


//let fistColor = UIColor.white
//let lastColor = UIColor.black
//let gradient = CAGradientLayer(start: .topLeft, end: .topRight, colors: [fistColor.cgColor, lastColor.cgColor], type: .radial)
//gradient.frame = yourView.bounds
//yourView.layer.addSublayer(gradient)
