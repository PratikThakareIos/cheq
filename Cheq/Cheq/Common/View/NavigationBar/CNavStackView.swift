//
//  CNavigationTitleWithIcon.swift
//  Cheq
//
//  Created by Xuwei Liang on 13/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CNavStackView is in a nutshell, designed as a horizontal stackview to hold subviews on the navigation bar titleView
 */
class CNavStackView: UIStackView {

    /// subViews which **CNavStackView** will hold horizontally
    var subViews: [UIView] = []
    
    init(subViews: [UIView]) {
        super.init(frame: CGRect.zero)
        self.subViews = subViews
        setupConfig()
    }
    
    /// **awakeFromNib** is called when
    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfig()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupConfig()
    }
    
    /// **setupConfig** should be called again whenever **subViews** are updated
    func setupConfig() {
        self.distribution = .fillProportionally
        self.alignment = .center
        self.axis = .horizontal
        self.spacing = 10.0
        self.backgroundColor = .red
        for view in self.subViews {
            self.addArrangedSubview(view)
        }
    }

    /// **intrinsicContentSize** is calculated automatically 
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}
