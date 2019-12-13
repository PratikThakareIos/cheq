//
//  CSwitchWithLabel.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CSwitchWithLabel is part layout with **CSwitch** and **CLabel** next to it.
 */
class CSwitchWithLabel: UIStackView {
    
    /// Adjustable horizontal spacing
    let defaultSpacing: CGFloat = 4.0
    
    /// String variable for title label. Refer to UX/UI design.
    var titleLabel: String = ""
    
    /// **CLabel** is a subclass of UILabel with embeded logics to styling
    var label: CLabel = CLabel(frame: CGRect.zero)
    
    /// Toggle is the embeded **UISwitch** of this UI layout
    var toggle = UISwitch()
    
    /// Custom init method with **title** included
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.titleLabel = title
        setupUI()
    }
    
    /// Added **setupUI** to default init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    /// Added **setupUI** to default init
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    /// Setting up the layout margin and attributes for view and stackview that contains the **CLabel** and **UISwitch**
    func setupMargin() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.spacing = UIStackView.spacingUseSystem
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: defaultSpacing, leading: defaultSpacing, bottom: defaultSpacing, trailing: defaultSpacing)
        self.alignment = .fill
        self.distribution = .fill
    }
    
    /// Applying style and adding subviews to stackview
    func setupUI() {
        setupMargin()
        self.toggle = CSwitch(frame: CGRect.zero)
        let spacer = UIView(frame: CGRect.zero)
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        let label = CLabel(frame: CGRect.zero)
        label.text = titleLabel
        label.textAlignment = .right
        spacer.addSubview(label)
        AutoLayoutUtil.pinToSuperview(label, padding: 0)
        self.axis = .horizontal
        self.addArrangedSubview(spacer)
        self.addArrangedSubview(toggle)
    }
    
    /// helper method to add String to label and trigger a refresh using **setNeedsDisplay**
    func setTitleLabel(_ value: String) {
        self.label.text = value
        self.setNeedsDisplay()
    }
    
    /// helper method to toggle the switch, without update the toggle variable directly 
    func switchValue()->Bool {
        return self.toggle.isOn
    }
}
