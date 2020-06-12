//
//  RequestForBankVC.swift
//  Cheq
//
//  Created by Amit.Rawal on 27/05/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit
import PromiseKit
import UITextView_Placeholder

class RequestForBankVC: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var titleLabel: CLabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var sendRequestButton: CNButton!
    @IBOutlet weak var txtViewComment : UITextView!
    var viewModel = RequestForBankViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        
        txtViewComment.placeholder = "Bank name"
        txtViewComment.placeholderColor = AppConfig.shared.activeTheme.placeHolderColor
        
        showCloseButton()
        //self.txtViewComment.text = "Bank name"
        //self.titleLabel.font = AppConfig.shared.activeTheme.headerBoldFont
        //self.caption.font = AppConfig.shared.activeTheme.mediumMediumFont
        self.sendRequestButton.createShadowLayer()
        
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.viewContainer.layer.cornerRadius = 12
        })

        self.txtViewComment.textColor = AppConfig.shared.activeTheme.placeHolderColor
        self.txtViewComment.font = AppConfig.shared.activeTheme.mediumFont
        self.setShadow()
    }
    
    func setShadow() {
        //rgba(146,146,210,0.05)
        self.viewContainer.layer.masksToBounds = false;
        self.viewContainer.layer.shadowRadius  = 3.0;
        self.viewContainer.layer.shadowColor   = UIColor.init(r: 146, g: 146, b: 210).cgColor;
        self.viewContainer.layer.shadowOffset  = CGSize(width: 2.0, height: 4.0);
        self.viewContainer.layer.shadowOpacity = 0.05;
    }
    
    @IBAction func sendRequestButton(_ sender: Any) {
       
        self.view.endEditing(true)
        self.viewModel.strComment = txtViewComment.text ?? ""
        if let error = self.viewModel.validateInput() {
            showError(error, completion: nil)
            return
        }
        
        AppConfig.shared.showSpinner()
        self.viewModel.postReview().done { _ in
            AppConfig.shared.hideSpinner {
                self.txtViewComment.text = ""
                LoggingUtil.shared.cPrint("postReview successfull")
                self.showMessage("Message has been sent", completion: nil)
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
}
