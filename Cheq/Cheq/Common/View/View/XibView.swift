//
//  XibView.swift
//  CheqDev
//
//  Created by Alexey on 07.09.2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class XibControlView: UIControl {
    var containerView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let nibFileName = "\(type(of: self))".components(separatedBy: ".").first!
        let bundle = Bundle(for: type(of: self))
        if let topView = UINib(nibName: nibFileName, bundle: bundle).instantiate(withOwner: self, options: nil)[0] as? UIView {
            containerView = topView
            addSubview(topView)
            AutoLayoutUtil.pinToSuperview(topView, padding: 0.0)
        }
        configure()
    }
    
    func configure() { }

}

class XibView: UIView {
    @IBOutlet var containerView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let nibFileName = "\(type(of: self))".components(separatedBy: ".").first!
        let bundle = Bundle(for: type(of: self))
        if let topView = UINib(nibName: nibFileName, bundle: bundle).instantiate(withOwner: self, options: nil)[0] as? UIView {
            containerView = topView
            addSubview(topView)
            AutoLayoutUtil.pinToSuperview(topView, padding: 0.0)
        }
        configure()
    }
    
    func configure() { }
}
