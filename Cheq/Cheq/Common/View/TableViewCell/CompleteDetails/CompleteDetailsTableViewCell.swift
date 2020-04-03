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
    
    @IBOutlet weak var linkButtonTopMargin: NSLayoutConstraint!
    @IBOutlet weak var verifyWorkimageView: UIImageView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var turnOnLocationButton: UIButton!
    
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
        self.detailsText.text = vm.detailsText()
        self.detailsSection.isHidden = !vm.expanded
        self.icon.image = UIImage(named: vm.imageIcon())
        self.expandButton.isHidden = vm.isHideRightArrow()//manish
        
        self.verifyWorkimageView.translatesAutoresizingMaskIntoConstraints = false
        self.detailsText.translatesAutoresizingMaskIntoConstraints = false
        self.detailsSection.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureForView = UITapGestureRecognizer(target: self, action: #selector(clickView(_:)))
        tapGestureForView.delegate = self
        self.detailsSection.addGestureRecognizer(tapGestureForView)
        self.turnOnLocationButton.layer.cornerRadius = 28
        self.turnOnLocationButton.layer.borderWidth = 2
        self.turnOnLocationButton.layer.borderColor = UIColor.blue.cgColor
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
          self.turnOnLocationButton.isHidden = vm.showSecondaryButton()
          let margin = vm.showSecondaryButton() ? 210.0 : 260.0
          self.linkButtonTopMargin.constant = CGFloat(margin)
          self.turnOnLocationButton.setTitle(vm.setWorkVerifyRoundedButtonTitle(), for: .normal)
            
        }else{
          detailsSection.heightAnchor.constraint(equalToConstant: 50).isActive = true
          self.turnOnLocationButton.isHidden = true
          self.verifyWorkimageView.isHidden = true
          self.linkButton.isHidden = true
        }
    }
    
    //tap guesture for teh whole view
    @objc func clickView(_ sender: UIView) {
        print("You clicked on view")
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
    
    @IBAction func linkButtonClicked(_ sender: Any) {
         LoggingUtil.shared.cPrint("open link")
    }
    
    @IBAction func turnOnBtnClick(_ sender: Any) {
         LoggingUtil.shared.cPrint("turnOnBtnClick")
         guard let vm = self.viewModel as? CompleteDetailsTableViewCellViewModel else { return }
        NotificationUtil.shared.notify(UINotificationEvent.turnOnLocation.rawValue, key: "turnOnLocation", value: vm.userAction.rawValue)
    }
    
    
}
