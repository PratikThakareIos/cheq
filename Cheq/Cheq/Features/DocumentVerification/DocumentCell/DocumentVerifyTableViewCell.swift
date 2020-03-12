//
//  DocumentVerifyTableViewCell.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 2/11/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class DocumentVerifyTableViewCell: UITableViewCell {

    @IBOutlet weak var DocumnerVerifyLabel: UILabel!
    @IBOutlet weak var content: UIView!
    
    @IBOutlet weak var documentVerifyImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        content.backgroundColor = .white
               content.layer.cornerRadius = 22.0

               //cardView.layer.shadowColor = UIColor.gray.cgColor

               content.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)

               content.layer.shadowRadius = 2.0

               content.layer.shadowOpacity = 0.7
               self.content.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       if selected {
                   self.content.backgroundColor = AppConfig.shared.activeTheme.alternativeColor3
               } else {
        self.content.backgroundColor = .white
        }
        // Configure the view for the selected state
    }
    
  override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))

    }

}
