//
//  PasscodeViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class PasscodeViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var instructionLabel: CLabel!
    @IBOutlet weak var digit1: CPasscodeTextField!
    @IBOutlet weak var digit2: CPasscodeTextField!
    @IBOutlet weak var digit3: CPasscodeTextField!
    @IBOutlet weak var digit4: CPasscodeTextField!
    var viewModel = PasscodeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupDelegates()
        setupUI()
    }
    
    func setupDelegates() {
        self.digit1.delegate = self
        self.digit2.delegate = self
        self.digit3.delegate = self
        self.digit4.delegate = self
    }

    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.instructionLabel.font = AppConfig.shared.activeTheme.headerFont
        
        // dismiss when user taps outside the textfields
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKey))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKey() {
        NotificationUtil.shared.notify(NotificationEvent.dismissKeyboard.rawValue, key: "", value: "")
    }
}

extension PasscodeViewController {
    override func baseScrollView() -> UIScrollView? {
        return self.scrollView
    }
}

extension PasscodeViewController: UITextFieldDelegate {
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
////        guard let textFieldText = textField.text,
////            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
////                return false
////        }
////        let substringToReplace = textFieldText[rangeOfTextToReplace]
////        let count = textFieldText.count - substringToReplace.count + string.count
//        return true
//    }
}
