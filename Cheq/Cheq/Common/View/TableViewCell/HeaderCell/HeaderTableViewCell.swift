//
//  HeaderTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 HeaderTableViewCell implements the header on top of a list section. This type of header exist on Spending screens as well as Lending screens. e.g. header for list of transactions.
 */
class HeaderTableViewCell: CTableViewCell {
    
    /// refer to **xib** for layout
    @IBOutlet weak var headerTitle: CLabel!
    
    /// refer to **xib** for layout
    @IBOutlet weak var viewAllButton: UIButton!

    /// called when initialise from **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewModel = HeaderTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// method called when we want to update UI after assigning values to viewModel
    override func setupConfig() {
        // customise UI
        let vm = self.viewModel as! HeaderTableViewCellViewModel
        self.backgroundColor = .clear
        
         self.headerTitle.text = vm.title
        if let headerFont = vm.titleFont {
           self.headerTitle.font = headerFont
        }else{
           self.headerTitle.font = UIFont.init(name: FontConstant.SFProTextSemibold, size: 18.0) ?? UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        }
        
       
        self.viewAllButton.setTitleColor(AppConfig.shared.activeTheme.splashBgColor3, for: .normal)
        //self.viewAllButton.titleLabel?.font = AppConfig.shared.activeTheme.defaultFont
        self.viewAllButton.isHidden = !vm.showViewAll
        self.tag = vm.tag
    }

    /// Toggling method triggered when user taps on **viewAll** on the tableview cell. 
    @IBAction func viewAll(_ sender: Any) {
        LoggingUtil.shared.cPrint("view all")
        NotificationUtil.shared.notify(UINotificationEvent.viewAll.rawValue, key: "viewAll", object: self)
    }
}
