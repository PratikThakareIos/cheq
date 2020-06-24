//
//  CashOutActivityPopUp.swift
//  Cheq
//
//  Created by Amit.Rawal on 23/06/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

@objc protocol CashOutActivityPopUpDelegate {
    @objc func tappedOnTermConditionButton()
}

class CashOutActivityPopUp: UIViewController {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwTopIcon: UIView!
    @IBOutlet weak var imgVwTopIcon: UIImageView!
    
    @IBOutlet weak var lblHeading:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
    @IBOutlet weak var lblFees:UILabel!
    @IBOutlet weak var lblReference:UILabel!
    @IBOutlet weak var btnTermsAndCondition: UIButton!

    @IBOutlet weak var popViewBottom: NSLayoutConstraint!
    
    var delegate : CashOutActivityPopUpDelegate?
    
    var loanActivity: LoanActivity?
    
    
//    var emojiImage = UIImage()
//    var strHeading = ""
//    var strDate = ""
//    var strAmount = ""
//    var strFees = ""
//    var strReference = ""
//
//    var isShowFeesLable = false
//    var isShowTermButton = false
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }

    private func setupUI(){
        
//         guard let loanActivity = loanActivity, let type = loanActivity.type, let status = loanActivity.status else {
//            self.dismiss(animated: false, completion: nil)
//            return
//         }
        
        self.vwTopIcon.layer.cornerRadius = 16
        self.vwTopIcon.layer.masksToBounds = true
        
        self.vwTopIcon.layer.masksToBounds = false;
        self.vwTopIcon.layer.shadowRadius  = 3.0;
        self.vwTopIcon.layer.shadowColor   = UIColor.init(r: 146, g: 146, b: 210).cgColor; //rgba(146,146,210,0.1)
        self.vwTopIcon.layer.shadowOffset  = CGSize(width: 2.0, height: 4.0);
        self.vwTopIcon.layer.shadowOpacity = 0.1;
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwContainer.addGestureRecognizer(tap)
        vwContainer.isUserInteractionEnabled = true
       
        self.imgVwTopIcon.image = UIImage.init(named: self.getImageIcon())
        self.lblHeading.text = getHeaderTitle()
        self.lblDate.text = getFormattedDate()
        self.lblAmount.text = getAmount()
        self.lblFees.text = getFees()
        self.lblReference.text = getReference()
         
        self.btnTermsAndCondition.isHidden = !get_isShowTermButton()
        self.lblFees.isHidden = (self.lblFees.text == "")
        
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

private extension CashOutActivityPopUp{
    
    @IBAction func btnTermsAndConditionAction(_ sender: Any) {
        self.delegate?.tappedOnTermConditionButton()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.hidePopup()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.dismiss(animated: false, completion: nil)
        }
    }

}

extension CashOutActivityPopUp {
    
    func getImageIcon() -> String {
        guard let loanActivity = loanActivity, let type = loanActivity.type, let status = loanActivity.status else { return "" }
        switch status {
            case .credited:
                return "icon-withdrawal"
            case .debited:
                return "icon-repayment"
            case .failed:
                return "icon-repaymentFailed"
            case .unprocessed, .pending, .unsuccessfulAttempt:
                return "icon-pendingRepayment"
        }
    }
    
    func getHeaderTitle() -> String {
        guard let loanActivity = loanActivity, let type = loanActivity.type, let status = loanActivity.status else { return "" }
        
        var strTitle = ""
        var strType = ""
        var strStatus = ""
        
        switch type {
        case .cashout:
            strType = "Cash out"
        case .repayment:
            strType = "Repayment"
        }
        
        switch status {
            case .credited:
                strStatus = ""
            case .debited:
                strStatus = ""
            case .failed:
                strStatus = " - Failed"
            case .unprocessed:
                strStatus = " - Unprocessed"
            case .pending, .unsuccessfulAttempt:
                strStatus = " - Pending"
        }
        
        strTitle = strType + strStatus
        LoggingUtil.shared.cPrint(strTitle)
        return strTitle
    }
    
    func getFormattedDate()->String{
       guard let loanActivity = loanActivity, let type = loanActivity.type, let status = loanActivity.status else { return "" }
       
        if(type == .cashout){
            if let strDate = self.convertDateFormater(loanActivity.date ?? ""){
               return strDate
            }
        }else{
           if let strDate = self.convertDateFormater(loanActivity.repaymentDate ?? ""){
              return strDate
           }
        }
        return ""
    }
    
    func getAmount() -> String {
          guard let loanActivity = loanActivity, let type = loanActivity.type, let status = loanActivity.status else { return "" }
          let amount = loanActivity.amount ?? 0.0
          let amt = floor(amount)
          let strAmount = String(format: "$%.1f", amt)
          return strAmount
    }
    
    func getFees() -> String {
          guard let loanActivity = loanActivity, let type = loanActivity.type, let status = loanActivity.status else { return "" }              
          switch type {
          case .cashout:
              return ""
          case .repayment:
                  if let fee = loanActivity.exactFee {
                      return "Incl. $\(fee) fee"
                  } else {
                      return ""
                  }
          }
    }
    
    func getReference() -> String {
          guard let loanActivity = loanActivity, let type = loanActivity.type, let status = loanActivity.status else { return "" }
          
          if let cheqPayReference = loanActivity.cheqPayReference {
             return " CheqPay Reference: \(cheqPayReference)"
          }
          return ""
    }
    
    func get_isShowTermButton() -> Bool {
        guard let loanActivity = loanActivity, let type = loanActivity.type, let status = loanActivity.status else { return false }
        if let loanAgreement = loanActivity.loanAgreement {
            return true
        }
        return false
    }
    
}


extension CashOutActivityPopUp {
    
    func convertDateFormater(_ date: String) -> String? {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "yyyy-MM-dd"
         dateFormatter.locale = Locale(identifier: "en_US_POSIX")
         
         if let date = dateFormatter.date(from: date) {
             dateFormatter.dateFormat = "EEEE, d MMM yyyy"
             return  dateFormatter.string(from: date)
         }
         return nil
     }
}
