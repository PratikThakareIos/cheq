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
    @IBOutlet weak var detailsText: CLabel!

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
}
