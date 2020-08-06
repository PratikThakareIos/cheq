//
//  AccountInfoTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 CTableViewCell subclass
 Please check the XIB for layout
 This cell is used in the AccountViewController, for user information
 But it is not restricted for any other use
 */
class AccountInfoTableViewCell: CTableViewCell {
    
    /// subHeader lies on top of information, we use this for labelling the nature of information. e.g. First name, Last name
    @IBOutlet weak var subHeader: UILabel!
    
    /// information is the content that subHeader is referring to
    @IBOutlet weak var information: UILabel!
    
    
    @IBOutlet weak var imgVwArrow: UIImageView!
    
    

    /// this method is called when cell is loaded from XIB
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// we always initialize the cell's viewModel inside **awkeFromNib**, then we populate the values we want and call **setupConfig** again to update the UI
        self.viewModel = AccountInfoTableViewCellViewModel()
        setupConfig()
    }
    
    /**
     setupConfig overrides the method from superclas **CTableViewCell**
     all the cells we build should override **setupConfig** specifically handling the styling of its appearance 
     */
    override func setupConfig() {
        self.backgroundColor = .clear 
        
        //subHeader.font = AppConfig.shared.activeTheme.mediumBoldFont
        subHeader.textColor = AppConfig.shared.activeTheme.lightGrayColor
        
        information.font = AppConfig.shared.activeTheme.mediumBoldFont
        information.textColor = AppConfig.shared.activeTheme.textColor
       
        let vm = self.viewModel as! AccountInfoTableViewCellViewModel
        subHeader.text = vm.subHeader
        information.text = vm.information

        imgVwArrow.isHidden = !vm.showDisclosureIcon

    }
}
