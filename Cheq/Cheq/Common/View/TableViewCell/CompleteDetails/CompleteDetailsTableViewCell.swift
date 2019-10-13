//
//  CompleteDetailsTableViewCell.swift
//  Cheq
//
//  Created by XUWEI LIANG on 13/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class CompleteDetailsTableViewCell: CTableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var headerSection: UIView!
    @IBOutlet weak var header: CLabel!
    @IBOutlet weak var detailsSection: UIView!
    @IBOutlet weak var detailsText: CLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func setupConfig() {
        self.headerSection.backgroundColor = .clear
        self.detailsSection.backgroundColor = .clear
        guard let vm = self.viewModel as? CompleteDetailsTableViewCellViewModel else { return }
        self.header.text = vm.headerText()
        self.detailsText.text = vm.detailsText()
        self.detailsSection.isHidden = !vm.expanded
    }

    @IBAction func expand(_ sender: Any) {
        LoggingUtil.shared.cPrint("expand")
    }
}
