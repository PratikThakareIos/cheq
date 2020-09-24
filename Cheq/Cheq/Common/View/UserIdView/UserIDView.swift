//
//  UserIDView.swift
//  Cheq
//
//  Created by Sachin Amrale on 10/09/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class UserIDView: UIView {

    @IBOutlet var userIdView: UIView!
    @IBOutlet weak var idImageView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var idInfoView1: HeaderLabelView!
    @IBOutlet weak var idInfoView2: HeaderLabelView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("UserIDView", owner: self, options: nil)
        userIdView.fixInView(self)
    }
    
}
