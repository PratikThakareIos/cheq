//
//  CMultipleChoiceWithCaptionCell.swift
//  Cheq
//
//  Created by Xuwei Liang on 17/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CMultipleChoiceWithCaptionCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    var coordinatorType: MultipleChoiceQuestionType?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupConfig()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        // Configure the view for the selected state
//        if selected {
//            self.containerView.backgroundColor = AppConfig.shared.activeTheme.alternativeColor3
//        } else {
//            self.containerView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
//        }
        
        if let coordinatorType = coordinatorType, coordinatorType == .employmentType{
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
    }

    func setupConfig() {
        
        self.titleLabel.font = AppConfig.shared.activeTheme.mediumBoldFont
        self.captionLabel.font = AppConfig.shared.activeTheme.defaultMediumFont
        
       // self.titleLabel.font = AppConfig.shared.activeTheme.headerBoldFont
       // self.captionLabel.font = AppConfig.shared.activeTheme.defaultFont
        self.backgroundColor = .white
        self.containerView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
    }
}
