//
//  SelectionTableViewCell.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 2/4/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    @IBOutlet weak var content: UIView!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        content.backgroundColor = .white
        content.layer.cornerRadius = 22.0

        //cardView.layer.shadowColor = UIColor.gray.cgColor
        // content.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        //content.layer.shadowRadius = 2.0
        //content.layer.shadowOpacity = 0.7
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        if selected {
//                   self.content.backgroundColor = AppConfig.shared.activeTheme.alternativeColor3
//               } else {
//                   self.content.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
//        }
        // Configure the view for the selected state
        
        if selected {
           self.content.layer.borderWidth = 2
           self.content.layer.borderColor = UIColor(hex: "2CB4F6").cgColor
           //self.content.backgroundColor = .white
        }
        else {
           self.content.layer.borderWidth = 2
           self.content.layer.borderColor = UIColor.white.cgColor
           //self.content.backgroundColor = .white
        }
        
    }
    
}
