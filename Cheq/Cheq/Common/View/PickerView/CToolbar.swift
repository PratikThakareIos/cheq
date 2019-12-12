//
//  CToolbar.swift
//  Cheq
//
//  Created by Xuwei Liang on 25/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/// Delegate callback for the handling viewController
protocol CToolbarDelegate {
    func done(_ sender: Any)
}

/**
 Custom CToolbar is part of the UI for maritalStatus question screen. MartialStatus question screen is currently taken out from **Onboarding** flow.
 */
class CToolbar: UIToolbar {
    
    /// QuestionField specifies what question is the answer/UI mapping ifself to
    var field: QuestionField = .maritalStatus
    
    /// callback instance for **CToolbarDelegate** 
    var toolbarDelegate: CToolbarDelegate?
    
    init(_ field: QuestionField, delegate: CToolbarDelegate) {
        super.init(frame: CGRect.zero)
        self.field = field
        self.toolbarDelegate = delegate 
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
        self.barStyle = .default
        self.isTranslucent = true
        self.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tintColor = AppConfig.shared.activeTheme.primaryColor
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(done(_:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spaceButton2 = spaceButton
        self.setItems([spaceButton, spaceButton2, doneButton], animated: false)
        self.isUserInteractionEnabled = true
        self.sizeToFit()
    }
    
    @objc func done(_ sender: Any) {
        guard let delegate = toolbarDelegate else { return }
        LoggingUtil.shared.cPrint("Done")
        delegate.done(self)
    }
}
