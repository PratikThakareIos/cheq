//
//  PayCyclePopUpVC.swift
//  Cheq
//
//  Created by Amit.Rawal on 07/06/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

protocol PayCyclePopUpVCDelegate {
     func tappedOnBtnFirst(popUpType : PopUpType)
     func tappedOnBtnSecond(popUpType : PopUpType)
     func tappedOnCloseButton(popUpType : PopUpType)
}

class PayCyclePopUpVC: UIViewController {
    
   @IBOutlet weak var btnFirst:UIButton!
   @IBOutlet weak var btnSecond:UIButton!
   @IBOutlet weak var btnClose:UIButton!
   @IBOutlet weak var popUpView: UIView!
   @IBOutlet weak var popViewBottom: NSLayoutConstraint!
   var delegate:PayCyclePopUpVCDelegate?
    
   var popUpType : PopUpType = PopUpType.minTransactionSelection
        
   var strFirst : String?
   var strSecond : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI(){
        popUpView.layer.cornerRadius = 24
        
        if let strFirst = strFirst {
            self.btnFirst.setTitle(strFirst, for: .normal)
            self.btnFirst.isHidden = false
        }else{
            self.btnFirst.isHidden = true
        }
        
        if let strSecond = strSecond {
            self.btnSecond.setTitle(strSecond, for: .normal)
            self.btnSecond.isHidden = false
        }else{
            self.btnSecond.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showPopup()
    }
    
    private func showPopup(){
        popViewBottom.constant = 20
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hidePopup(){
        popViewBottom.constant = -800
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
}

private extension PayCyclePopUpVC {
    
    @IBAction func close(){
        self.hidePopup()
        self.delegate?.tappedOnCloseButton(popUpType : self.popUpType)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btnFirstAction(){
        self.hidePopup()
        self.delegate?.tappedOnBtnFirst(popUpType : self.popUpType)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func btnSecondAction(){
        self.hidePopup()
        self.delegate?.tappedOnBtnSecond(popUpType : self.popUpType)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
