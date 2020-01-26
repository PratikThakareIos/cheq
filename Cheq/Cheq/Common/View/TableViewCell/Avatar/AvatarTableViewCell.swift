//
//  AvatarTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 AvatarTableViewCell is used for display user profile avatar
 */
class AvatarTableViewCell: CTableViewCell {
    
    /// the imageView for avatar image
    @IBOutlet weak var avatar: UIImageView!
    
    /// container of avatar image
    @IBOutlet weak var avatarContainer: UIView! 

    /// awakeFromNib is called when cell is initialised by **xib**
    override func awakeFromNib() {
        super.awakeFromNib()
        
        /// viewModel is initialised with dummy values, after updating, call **setupConfig** again to update cell
        self.viewModel = AvatarTableViewCellViewModel()
        
        /// setupConfig is for updating the UI whenever we assign viewModel
        setupConfig()
    }

    /// Override this method to add custom logic when cell is selected. Alternatively add tap gesture to trigger a method that applies custom logic. 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// setupConfig method should be override by all subclass of **CTableViewCell** 
    override func setupConfig() {
        self.backgroundColor = .clear 
        let vm = self.viewModel as! AvatarTableViewCellViewModel
        avatar.image = UIImage.init(named: vm.image)
        avatarContainer.backgroundColor = AppConfig.shared.activeTheme.lightGrayScaleColor
        ViewUtil.shared.circularMask(&avatarContainer, radiusBy: .width)
    }
}
