//
//  DocPlaceHolderCell.swift
//  Cheq
//
//  Created by Fawaz Faiz on 09/02/2020.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class DocPlaceHolderCell: UITableViewCell {

    @IBOutlet weak var docInfoLabel: UILabel!
    @IBOutlet weak var docImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
