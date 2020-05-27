//
//  SetupBankVC.swift
//  Cheq
//
//  Created by Amit.Rawal on 26/05/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit
import Onfido
import PromiseKit
import MobileSDK

class SetupBankVC: UIViewController {

    @IBOutlet weak var imageViiew: UIImageView!
    @IBOutlet weak var titleLabel: CLabel!
    @IBOutlet weak var caption: CLabel!
    @IBOutlet weak var confirmButton: CNButton!
    @IBOutlet weak var secondaryButton: UIButton!
    var viewModel = IntroductionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        registerObservables()
      
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }
    
    func registerObservables() {
        setupKeyboardHandling()
        NotificationCenter.default.addObserver(self, selector: #selector(self.intercom(_:)), name: NSNotification.Name(UINotificationEvent.intercom.rawValue), object: nil)
    }
    

    func setupUI() {
        self.confirmButton.createShadowLayer()
        hideBackButton()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor //f4f3f5
        self.titleLabel.font = AppConfig.shared.activeTheme.headerBoldFont
        self.titleLabel.text = self.viewModel.coordinator.type.rawValue
        self.caption.font = AppConfig.shared.activeTheme.mediumMediumFont
        self.caption.text = self.viewModel.caption()
        self.imageViiew.image = UIImage(named: self.viewModel.imageName())
        self.confirmButton.setTitle(viewModel.confirmButtonTitle(), for: .normal)
        self.secondaryButton.setTitle(viewModel.nextButtonTitle(), for: .normal)
        
//        self.secondaryButton.type = .alternate
//        self.secondaryButton.setType(.alternate)
    }
    
    @IBAction func confirm(_ sender: Any) {
        AppNav.shared.pushToMultipleChoice(.financialInstitutions, viewController: self)
    }

    @IBAction func secondaryButton(_ sender: Any) {
        self.navigateToBankSetupLearnMore()
    }
}

extension SetupBankVC {
    
    func navigateToBankSetupLearnMore() {
         LoggingUtil.shared.cPrint("navigateToBankSetupLearnMore")
        
         let heading = "Connect to your bank"
         let message =

        """
Cheq uses third party technology providers to sync your bank transactions with Cheq. They regularly get security audits to ensure all your data is secure and encrypted.

What Cheq have access to
Account names and types, Account balances, Transactions

What Cheq won’t be able to do
Make payments, Transfer money to/from your accounts
"""
        
        let attributedString = NSMutableAttributedString(string: message)
        attributedString.applyHighlightTwo(text1: "What Cheq have access to", text2: "What Cheq won’t be able to do", color: .black, font: AppConfig.shared.activeTheme.mediumBoldFont)
        self.openPopupWith(heading: heading, message: "", attr_message: attributedString, buttonTitle: "", showSendButton: false, emoji: UIImage(named: "successEmo"))
    
    }
}


//MARK: - Verification popup
extension SetupBankVC: VerificationPopupVCDelegate{
    
    func openPopupWith(heading:String?, message:String?, attr_message:NSMutableAttributedString, buttonTitle:String?, showSendButton:Bool?, emoji:UIImage?){
        
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: StoryboardName.Popup.rawValue, bundle: Bundle.main)
        if let popupVC = storyboard.instantiateInitialViewController() as? VerificationPopupVC{
            popupVC.delegate = self
            popupVC.heading = heading ?? ""
            popupVC.message = message ?? ""
            popupVC.attributedMessage = attr_message
            popupVC.buttonTitle = buttonTitle ?? ""
            popupVC.showSendButton = showSendButton ?? false
            popupVC.emojiImage = emoji ?? UIImage()
            
            popupVC.isChangeLineHight = true
            popupVC.isShowViewSecurityImage = true
            
            self.present(popupVC, animated: false, completion: nil)
        }
    }
    
    func tappedOnSendButton(){
    }
    
    func tappedOnCloseButton(){
    }
}
