//
//  HeaderLabelView.swift
//  Cheq
//
//  Created by Sachin Amrale on 10/09/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class HeaderLabelView: UIView {

    @IBOutlet var headerLabelView: UIView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var valueLabel: UITextView!
    
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
        Bundle.main.loadNibNamed("HeaderLabelView", owner: self, options: nil)
        headerLabelView.fixInView(self)
        self.valueLabel.textContainerInset = UIEdgeInsets.zero
        self.valueLabel.textContainer.lineFragmentPadding = 0
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}

