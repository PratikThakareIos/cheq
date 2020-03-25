//
//  CustomProgressBar.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 3/23/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class CustomProgressBar: UIView {

    @IBOutlet weak var customProgressBar: CProgressView!
    
    @IBOutlet weak var backgroundView: UIView!
    override func awakeFromNib() {
       
        setupConfig()
    }
    
    func setupConfig() {
        
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        backgroundView.isOpaque = false
        self.customProgressBar.setProgress(0.5, animated: true)
        self.customProgressBar.mode = .information
        self.customProgressBar.setupConfig()
    }

}
