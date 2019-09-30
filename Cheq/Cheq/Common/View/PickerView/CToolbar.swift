//
//  CToolbar.swift
//  Cheq
//
//  Created by Xuwei Liang on 25/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

protocol CToolbarDelegate {
    func done(_ sender: Any)
}

class CToolbar: UIToolbar {
    
    var field: QuestionField = .maritalStatus
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
