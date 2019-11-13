//
//  CNavigationTitleWithIcon.swift
//  Cheq
//
//  Created by Xuwei Liang on 13/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CNavStackView: UIStackView {

    var subViews: [UIView] = []
    
    init(subViews: [UIView]) {
        super.init(frame: CGRect.zero)
        self.subViews = subViews
        setupConfig()
    }
    
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

    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
}
