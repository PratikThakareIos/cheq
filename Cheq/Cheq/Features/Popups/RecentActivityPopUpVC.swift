//
//  RecentActivityPopUpVC.swift
//  Cheq
//
//  Created by Amit.Rawal on 26/06/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit


//[SlimTransactionResponse(
//    _description: Optional("LIQUOR EMPORIUM ALEXANDRIA NS AUS Card xx3481 Value Date: 24/06/2020"),
//    amount: Optional(-109.85),
//    date: Optional("2020-06-25"),
//    categoryTitle: Optional("Tobacco & Alcohol"),
//    categoryCode: Optional(Cheq_DEV.SlimTransactionResponse.CategoryCode.tobaccoAndAlcohol),
//    merchant: nil,
//    merchantLogoUrl: nil,
//    financialAccountName:
//    Optional("Credit Card"),
//    financialInstitutionLogoUrl: Optional("https://d388vpyfrt4zrj.cloudfront.net/AU00001.svg")
//    ),


@objc protocol RecentActivityPopUpVCDelegate {
    @objc func recentActivityPopUpClosed()
}

class RecentActivityPopUpVC: UIViewController {

    @IBOutlet weak var vwContainer: UIView!
    @IBOutlet weak var vwTopIcon: UIView!
    @IBOutlet weak var imgVwTopIcon: UIImageView!
    
    @IBOutlet weak var lblHeading:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblAmount:UILabel!
     
    @IBOutlet weak var vwCategoryContainer: UIView!
    @IBOutlet weak var lblCategoryTitle:UILabel!
    @IBOutlet weak var imgVwCategoryLogo: UIImageView!
    
    @IBOutlet weak var vwAccountContainer: UIView!
    @IBOutlet weak var lblAccountName:UILabel!
    @IBOutlet weak var imgVwAccountLogo: UIImageView!
    
    @IBOutlet weak var popViewBottom: NSLayoutConstraint!
    
    var delegate : RecentActivityPopUpVCDelegate?
    var slimTransactionResponse: SlimTransactionResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }

    private func setupUI(){
        
        guard let data = slimTransactionResponse else { return  }
        
        self.vwTopIcon.layer.cornerRadius = 16
        self.vwTopIcon.layer.masksToBounds = true
        
        self.vwCategoryContainer.layer.cornerRadius = 16
        self.vwCategoryContainer.layer.borderColor = UIColor.init(hex: "E0E0E0").cgColor
        self.vwCategoryContainer.layer.borderWidth = 0.5
        self.vwCategoryContainer.layer.masksToBounds = true
        
        self.vwAccountContainer.layer.cornerRadius = 16
        self.vwAccountContainer.layer.borderColor = UIColor.init(hex: "E0E0E0").cgColor
        self.vwAccountContainer.layer.borderWidth = 0.5
        self.vwAccountContainer.layer.masksToBounds = true
        
        self.vwTopIcon.layer.masksToBounds = false;
        self.vwTopIcon.layer.shadowRadius  = 3.0;
        self.vwTopIcon.layer.shadowColor   = UIColor.init(r: 146, g: 146, b: 210).cgColor; //rgba(146,146,210,0.1)
        self.vwTopIcon.layer.shadowOffset  = CGSize(width: 2.0, height: 4.0);
        self.vwTopIcon.layer.shadowOpacity = 0.1;
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        vwContainer.addGestureRecognizer(tap)
        vwContainer.isUserInteractionEnabled = true
       
        let code = DataHelperUtil.shared.categoryAmountStateCodeFromTransaction(data.categoryCode ?? SlimTransactionResponse.CategoryCode.others)
        let iconImage = DataHelperUtil.shared.iconFromCategory(code, largeIcon: true)
        let smallIconImage = DataHelperUtil.shared.iconFromCategory(code, largeIcon: false)
        
        self.imgVwTopIcon.image = UIImage.init(named: iconImage)
        self.lblHeading.text = data._description ?? ""
        self.lblDate.text = getFormattedDate()
        self.lblAmount.text = getAmount()

        self.imgVwCategoryLogo.image = UIImage.init(named: smallIconImage)
        self.lblCategoryTitle.text = data.categoryTitle ?? ""
                
        //ToDo : need to add bank logo name in response
        //financialInstitutionLogoUrl: Optional("https://d388vpyfrt4zrj.cloudfront.net/AU00001.svg")
        
        if let img = UIImage.init(named: data.financialInstitutionId ?? ""){
            self.imgVwAccountLogo.image = img
        }else{
            self.imgVwAccountLogo.image =  UIImage.init(named: BankLogo.placeholder.rawValue)
        }
        
        self.lblAccountName.text = data.financialAccountName ?? ""
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

private extension RecentActivityPopUpVC{
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.hidePopup()
        self.delegate?.recentActivityPopUpClosed()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.dismiss(animated: false, completion: nil)
        }
    }

}

extension RecentActivityPopUpVC {
  
    func getFormattedDate()->String{
        
        guard let slimTransactionResponse = slimTransactionResponse else { return "" }
        if let strDate = self.convertDateFormater(slimTransactionResponse.date ?? ""){
           return strDate
        }
        return ""
    }
    
    func getAmount() -> String {
        guard let data = slimTransactionResponse else { return "" }
        
        var strAmount = FormatterUtil.shared.currencyFormatWithComma(data.amount ?? 0.0, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: false)
             
         if (strAmount.contains("-")){
             strAmount = strAmount.replacingOccurrences(of: "-", with: "")
             strAmount = "-" + strAmount
             //self.transactionAmount.textColor = AppConfig.shared.activeTheme.textColor
         }else{
             //self.transactionAmount.textColor = UIColor(hex: "00B662")
         }
         return strAmount
    }
}


extension RecentActivityPopUpVC {
    
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

