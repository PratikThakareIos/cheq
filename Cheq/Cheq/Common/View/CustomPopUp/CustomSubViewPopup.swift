//
//  CustomSubViewPopup.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 2/4/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit
import SwiftEntryKit

class CustomSubViewPopup: UIView {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var popupHeight: NSLayoutConstraint!
    @IBOutlet weak var content: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var popupImageView: UIImageView!
    
     /// viewModel is always initialised, so it's not nil
      var viewModel = CustomPopupViewModel()
    
    override func awakeFromNib() {
         setupUI()
    }
    
    func setupUI() {
        cancelBtn.isHidden =  true
        content.layer.cornerRadius = 28
        self.label.text = viewModel.data.description
        self.popupHeight.constant = viewModel.data.modalheight ?? 502.0
        self.headerLabel.text =  viewModel.data.headerTitle
        if viewModel.data.imageName != ""{
            self.popupImageView.image = UIImage(named: viewModel.data.imageName!)
        }
    }

    
    func setupTapToDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissAction))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissAction() {
          SwiftEntryKit.dismiss()
      }
}


