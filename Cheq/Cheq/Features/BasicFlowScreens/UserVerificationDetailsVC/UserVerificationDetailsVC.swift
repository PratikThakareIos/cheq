//
//  UserVerificationDetailsVC.swift
//  Cheq
//
//  Created by Sachin Amrale on 10/09/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class UserVerificationDetailsVC: UIViewController {

    @IBOutlet weak var startButton: CNButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var dobView: HeaderLabelView!
    @IBOutlet weak var addressView: HeaderLabelView!
    @IBOutlet weak var nameView: HeaderLabelView!
    @IBOutlet weak var userIDView: UserIDView!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        // Do any additional setup after loading the view.
    }
    
    func setUpUI(){
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.startButton.createShadowLayer()
        self.userIDView.layer.cornerRadius = 15
        self.userIDView.clipsToBounds = true
        self.checkmarkButton.setImage(UIImage(named: "unchecked-1"), for: .normal)
        self.checkmarkButton.addTarget(self, action: #selector(checkMarkClicked(sender:)), for: .touchUpInside)
        self.startButton.isEnabled = false
        
        self.nameView.headerLabel.text = "Name"
        self.nameView.valueLabel.text = "Sachin Amrale"
        
        self.dobView.headerLabel.text = "DOB"
        self.dobView.valueLabel.text = "03-08-1990"
        
        self.addressView.headerLabel.text = "Current address"
        self.addressView.valueLabel.text = "11 York Street, Sydney, NSW 2000, Australia"
        
        self.userIDView.idImageView.image = UIImage(named: "icon-passport")
        self.userIDView.headerLabel.text = "Passport"
        self.userIDView.idInfoView1.headerLabel.text = "Number"
        self.userIDView.idInfoView1.valueLabel.text = "1234"
    }
    
    @objc func checkMarkClicked(sender: UIButton){
        if sender.image(for: .normal) == UIImage(named: "unchecked-1"){
            self.checkmarkButton.setImage(UIImage(named: "checked"), for: .normal)
            self.startButton.isEnabled = true
        }else{
            self.checkmarkButton.setImage(UIImage(named: "unchecked-1"), for: .normal)
            self.startButton.isEnabled = false
        }
    }

}
