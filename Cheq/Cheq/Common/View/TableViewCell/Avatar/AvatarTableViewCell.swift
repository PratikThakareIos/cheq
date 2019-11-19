//
//  AvatarTableViewCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 20/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class AvatarTableViewCell: CTableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var avatarContainer: UIView! 

    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = AvatarTableViewCellViewModel()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func setupConfig() {
        self.backgroundColor = .clear 
        let vm = self.viewModel as! AvatarTableViewCellViewModel
        avatar.image = UIImage.init(named: vm.image)
        avatarContainer.backgroundColor = AppConfig.shared.activeTheme.lightGrayScaleColor
        ViewUtil.shared.circularMask(&avatarContainer, radiusBy: .width)
    }
}
