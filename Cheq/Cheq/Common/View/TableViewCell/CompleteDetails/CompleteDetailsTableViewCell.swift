//
//  CompleteDetailsTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CompleteDetailsTableViewCell is the tableview cell implementation for each row representing "Complete Details" stages on Lending screen before the user is "eligible" to proceed with loan applications.
 */
class CompleteDetailsTableViewCell: CTableViewCell {
    
    //@IBOutlet weak var linkButtonTopMargin: NSLayoutConstraint!
    @IBOutlet weak var verifyWorkimageView: UIImageView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var btnFirst: UIButton!
    
    /// refer to **xib**
    @IBOutlet weak var icon: UIImageView!
    
    /// refer to **xib**
    @IBOutlet weak var expandButton: UIButton!
    
    /// refer to **xib**
    @IBOutlet weak var headerSection: UIView!
    
    /// refer to **xib**
    @IBOutlet weak var header: CLabel!
    
    /// refer to **xib**
    @IBOutlet weak var detailsSection: UIView!
    
    /// refer to **xib**
    @IBOutlet weak var detailsText: UILabel!

    /// called when init from **xib**
    override func awakeFromNib() {
        self.viewModel = CompleteDetailsTableViewCellViewModel()
        super.awakeFromNib()
    }

   /// Override this method to add custom logic when cell is selected. Alternatively add tap gesture to trigger a method that applies custom logic.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    /// Call setupConfig when viewModel is updated
    override func setupConfig() {
        
         self.headerSection.backgroundColor = .clear
         self.detailsSection.backgroundColor = .clear
        
        /// Notice by default the viewModel from **CTableViewCell** is defined as **TableViewCellViewModelProtocol**, if we want to access subclass viewModel class, we need to cast back to the subclass's viewModel type.
         guard let vm = self.viewModel as? CompleteDetailsTableViewCellViewModel else { return }
         
         self.header.text = vm.headerText()
         self.header.font = AppConfig.shared.activeTheme.mediumBoldFont
         self.header.textColor = vm.headerTextColor()
         
         self.detailsText.text = vm.detailsText()
         self.detailsText.font = AppConfig.shared.activeTheme.defaultMediumFont
         self.detailsText.textColor =  AppConfig.shared.activeTheme.lightGrayColor
        
        //mediumBoldFont


         self.detailsSection.isHidden = !vm.expanded
         self.icon.image = UIImage(named: vm.imageIcon())
         self.expandButton.isHidden = vm.isHideRightArrow()//manish
        
         self.verifyWorkimageView.translatesAutoresizingMaskIntoConstraints = false
         self.detailsText.translatesAutoresizingMaskIntoConstraints = false
         self.detailsSection.translatesAutoresizingMaskIntoConstraints = false
         let tapGestureForView = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
         tapGestureForView.delegate = self
         self.detailsSection.addGestureRecognizer(tapGestureForView)
         
         self.btnFirst.layer.cornerRadius = 25
         self.btnFirst.layer.borderWidth = 2
         self.btnFirst.layer.borderColor = UIColor(hex: "2CB4F6").cgColor
         self.btnFirst.setTitleColor( UIColor(hex: "2CB4F6"), for: .normal)
         self.linkButton.setTitleColor( UIColor(hex: "2CB4F6"), for: .normal)
            
        
        if (vm.type == .workVerify){
            if vm.showSecondaryButton() {
                detailsSection.heightAnchor.constraint(equalToConstant: 280).isActive = true
            }else {
                detailsSection.heightAnchor.constraint(equalToConstant: 400).isActive = true
         }
          self.verifyWorkimageView.image =  UIImage(named: vm.verifyWorkImage())
          self.verifyWorkimageView.isHidden = false
          self.linkButton.setTitle(vm.linkButtonText(), for: .normal)
          self.linkButton.isHidden = false
          self.btnFirst.isHidden = vm.showSecondaryButton()
          let margin = vm.showSecondaryButton() ? 210.0 : 260.0
          //self.linkButtonTopMargin.constant = CGFloat(margin)
          self.btnFirst.setTitle(vm.setWorkVerifyRoundedButtonTitle(), for: .normal)
            
         }else if (vm.type == .verifyYourDetails && vm.completionState == .failed){
                        
            self.detailsText.textColor =  AppConfig.shared.activeTheme.mediumGrayColor
            
            let attributedString = NSMutableAttributedString(string:  self.detailsText.text ?? "")
            attributedString.applyHighlightTwo(text1: "Driver licences", text2: "Passports", color: .black, font: AppConfig.shared.activeTheme.mediumBoldFont14)
            self.detailsText.attributedText = attributedString
            self.detailsText.setLineSpacing(lineSpacing: 8.0)
                     
            self.icon.image = UIImage(named: "workVerifyFailed")
            detailsSection.heightAnchor.constraint(greaterThanOrEqualToConstant: 350).isActive = true
            self.verifyWorkimageView.image =  UIImage(named: "verifyIdentity")
            self.verifyWorkimageView.isHidden = false
            self.linkButton.setTitle("Learn more", for: .normal)
            self.linkButton.isHidden = false
            self.btnFirst.setTitle("Chat with us", for: .normal)
            self.btnFirst.isHidden = false
            //let margin = 210.0
            //self.linkButtonTopMargin.constant = CGFloat(margin)
 
         }else{
            
          detailsSection.heightAnchor.constraint(equalToConstant: 50).isActive = true
          self.btnFirst.isHidden = true
          self.verifyWorkimageView.isHidden = true
          self.linkButton.isHidden = true
        }
    }
    
    //tap guesture for teh whole view
    @objc func clickView(_ sender: UIView) {
         LoggingUtil.shared.cPrint("You clicked on view")
        guard let vm = self.viewModel as? CompleteDetailsTableViewCellViewModel else { return }
           if vm.completionState == .pending {
               /// In fact, this is triggering a **UINotificationEvent.completeDetails** event that tells the observing viewController to update the tableview to render this cell
               NotificationUtil.shared.notify(UINotificationEvent.completeDetails.rawValue, key: "type", value: vm.type.rawValue)
           }
    }
    
    /// The expand/collapse toggle for "Complete Details" table view  cells.
    @IBAction func expand(_ sender: Any) {
        LoggingUtil.shared.cPrint("expand")
        
        guard let vm = self.viewModel as? CompleteDetailsTableViewCellViewModel else { return }
        if vm.completionState == .pending {
            /// In fact, this is triggering a **UINotificationEvent.completeDetails** event that tells the observing viewController to update the tableview to render this cell 
            NotificationUtil.shared.notify(UINotificationEvent.completeDetails.rawValue, key: "type", value: vm.type.rawValue)
        }
    }
        
    @IBAction func btnFirstAction(_ sender: Any) {
         LoggingUtil.shared.cPrint("btnFirstAction")
        guard let vm = self.viewModel as? CompleteDetailsTableViewCellViewModel else { return }
        if (vm.type == .verifyYourDetails && vm.completionState == .failed){
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
        }else{
            NotificationUtil.shared.notify(UINotificationEvent.turnOnLocation.rawValue, key: "turnOnLocation", value: vm.userAction.rawValue)
        }
    }
    
    @IBAction func linkButtonClicked(_ sender: Any) {
        LoggingUtil.shared.cPrint("Learn more")
        guard let vm = self.viewModel as? CompleteDetailsTableViewCellViewModel else { return }
        if (vm.type == .verifyYourDetails && vm.completionState == .failed){
            let strLink = links.whatFormsOfIdDoesCheqAccept.rawValue
            NotificationUtil.shared.notify(UINotificationEvent.learnMore.rawValue, key: NotificationUserInfoKey.link.rawValue, value: strLink)
        }else{
        
        }
    }
}
