//
//  CMultipleChoiceWithImageCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 17/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CMultipleChoiceWithImageCell: UITableViewCell {

    @IBOutlet weak var choiceTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var disableContainerView: UIView!
    @IBOutlet weak var lblDescription: UILabel!
    var coordinatorType: MultipleChoiceQuestionType?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       // == .onDemand
        if let coordinatorType = coordinatorType, (coordinatorType == .financialInstitutions || coordinatorType == .onDemand ){
            if selected {
              self.containerView.layer.borderWidth = 2
              self.containerView.layer.borderColor = UIColor(hex: "2CB4F6").cgColor
           }
           else {
              self.containerView.layer.borderWidth = 2
              self.containerView.layer.borderColor = UIColor.white.cgColor
           }
        }else{
            if selected {
                 self.containerView.backgroundColor = AppConfig.shared.activeTheme.alternativeColor3
             }
             else {
                 self.containerView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
             }
        }
        
   

        // Configure the view for the selected state
//        if selected {
//            self.containerView.backgroundColor = AppConfig.shared.activeTheme.alternativeColor3
//        }
//        else {
//            self.containerView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
//        }
    }
    
    func setupConfig() {
        self.iconImageView.image = UIImage.init(named: "bankPlaceholder")
        self.choiceTitleLabel.font = AppConfig.shared.activeTheme.mediumBoldFont
        self.choiceTitleLabel.textColor = AppConfig.shared.activeTheme.textColor
        self.backgroundColor = .white
        self.containerView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
    }

}
