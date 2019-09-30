//
//  CPickerView.swift
//  Cheq
//
//  Created by Xuwei Liang on 25/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//
import Foundation
import UIKit

class CPickerView: UIPickerView {
    
    var field: QuestionField = .maritalStatus
    
    init(_ field: QuestionField) {
        super.init(frame: CGRect.zero)
        self.field = field
        setupConfig()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConfig()
    }
    
    func setupConfig() {
        self.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tintColor = AppConfig.shared.activeTheme.primaryColor
    }
}
