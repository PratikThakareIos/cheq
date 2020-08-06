//
//  DocumentVerifyTableViewCell.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 2/11/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class DocumentVerifyTableViewCell : UITableViewCell {

    @IBOutlet weak var DocumnerVerifyLabel: UILabel!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var documentVerifyImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        //self.contentView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        content.backgroundColor = .white
        

       //cardView.layer.shadowColor = UIColor.gray.cgColor
       //content.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
       //content.layer.shadowRadius = 2.0
       //content.layer.shadowOpacity = 0.7
       //self.content.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
         if selected {
           self.content.layer.borderWidth = 2
           self.content.layer.borderColor = UIColor(hex: "2CB4F6").cgColor
        }
        else {
           self.content.layer.borderWidth = 2
           self.content.layer.borderColor = UIColor.white.cgColor
        }
        
        
//       if selected {
//                   self.content.backgroundColor = AppConfig.shared.activeTheme.alternativeColor3
//               } else {
//                 self.content.backgroundColor = .white
//        }
      
    }
    
  override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

    }

}
