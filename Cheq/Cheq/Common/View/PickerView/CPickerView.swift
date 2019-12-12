//
//  CPickerView.swift
//  Cheq
//
//  Created by Xuwei Liang on 25/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//
import Foundation
import UIKit

/**
 CPickerView extend from **UIPickerView**
 */
class CPickerView: UIPickerView {
    
    /// storing the **QuestionField** type is important, so we know which **QuestionField** the picker is matching its value to.
    var field: QuestionField = .maritalStatus
    
    
    /// CPickerView can be initialised by **QuestionField**. Which ever question needs a picker to select values for.
    init(_ field: QuestionField) {
        super.init(frame: CGRect.zero)
        self.field = field
        setupConfig()
    }
    
    /// Default init method by frame. Custom UI logic embeded in **setupConfig** method.
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
    }
    
    /// Default init method by storyboard. Custom UI logic embeded in **setupConfig** method.
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConfig()
    }
    
    /// Stlying is dependent on **activeTheme**. This is a pattern consistent across the app. 
    func setupConfig() {
        self.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tintColor = AppConfig.shared.activeTheme.primaryColor
    }
}
