//
//  CSwitchWithLabel.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CSwitchWithLabel: UIStackView {
    let defaultSpacing: CGFloat = 4.0
    var titleLabel: String = ""
    var label: CLabel = CLabel(frame: CGRect.zero)
    var toggle = UISwitch()
    
    init(frame: CGRect, title: String) {
        super.init(frame: frame)
        self.titleLabel = title
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupMargin() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.spacing = UIStackView.spacingUseSystem
        self.isLayoutMarginsRelativeArrangement = true
        self.directionalLayoutMargins = NSDirectionalEdgeInsets(top: defaultSpacing, leading: defaultSpacing, bottom: defaultSpacing, trailing: defaultSpacing)
        self.alignment = .fill
        self.distribution = .fill
    }
    
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
    
    func setTitleLabel(_ value: String) {
        self.label.text = value
        self.setNeedsDisplay()
    }
    
    func switchValue()->Bool {
        return self.toggle.isOn
    }
}
