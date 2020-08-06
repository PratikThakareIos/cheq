//
//  DeclineDetailTableViewCell.swift
//  Cheq
//
//  Created by Amit.Rawal on 30/05/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class DeclineDetailTableViewCell: CTableViewCell {
    
    //    decline: Optional(Cheq_DEV.DeclineDetail(declineReason: Optional(Cheq_DEV.DeclineDetail.DeclineReason.monthlyPayCycle), declineTitle: Optional("Aaaww, We\'re sorry..."), declineDescription: Optional("Currently, we do not offer on-demand pay to people who get paid monthly. We\'ll be offering this soon and keep you updated."), learnMoreLink: Optional("https://help.cheq.com.au/en/articles/3446079-can-anyone-use-on-demand-pay"))))]
    
    @IBOutlet weak var imgVw: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var secondaryButton: UIButton!
    @IBOutlet weak var viewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = DeclineDetailViewModel()
        setupConfig()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    /// call this method when UI is updated
    override func setupConfig() {
        self.backgroundColor = .clear
        self.viewContainer.layer.cornerRadius = 10
        self.confirmButton.layer.cornerRadius = 23
        self.confirmButton.layer.borderWidth = 2
        self.confirmButton.layer.borderColor = AppConfig.shared.activeTheme.splashBgColor3.cgColor
        self.titleLabel.font = UIFont.init(name: FontConstant.SFUITextBold, size: 20.0) ?? UIFont.systemFont(ofSize: 20.0, weight: .bold)
        self.caption.font = UIFont.init(name: FontConstant.SFUITextMedium, size: 14.0) ?? UIFont.systemFont(ofSize: 14.0, weight: .medium)
        
        let vm = self.viewModel as! DeclineDetailViewModel
        if let declineDetails = vm.declineDetails, let declineReason = declineDetails.declineReason{
            
            let imgNamme = getImageIconName(declineReason)
            self.imgVw.image = UIImage(named: imgNamme) ?? UIImage()
            
            if let declineTitle = declineDetails.declineTitle, declineTitle != "" {
                self.titleLabel.text = declineTitle
                self.titleLabel.isHidden = false
            }else{
                self.titleLabel.isHidden = true
            }
            
            if let declineDescription = declineDetails.declineDescription, declineDescription != "" {
                self.caption.text = declineDescription
                self.caption.isHidden = false
            }else{
                self.caption.isHidden = true
            }

            let buttonsName = getButtonsTitle(declineReason)
            
            if  buttonsName.confirmButtonTitle != "" {
                self.confirmButton.setTitle(buttonsName.confirmButtonTitle, for: .normal)
                self.confirmButton.isHidden = false
            }else{
                self.confirmButton.isHidden = true
            }
            
            if  buttonsName.secondaryButton != "" {
                self.secondaryButton.setTitle(buttonsName.secondaryButton, for: .normal)
                self.secondaryButton.isHidden = false
            }else{
                self.secondaryButton.isHidden = true
            }
            
        }
    }
}

extension DeclineDetailTableViewCell {
    
    @IBAction func btnFirstAction(_ sender: Any) {
         LoggingUtil.shared.cPrint("btnFirstAction")
        confirmButtonAction()
    }
    
    @IBAction func btnSecondAction(_ sender: Any) {
         LoggingUtil.shared.cPrint("btnSecondAction")
        secondaryButtonAction()
    }
}

extension DeclineDetailTableViewCell {
    
    func getImageIconName(_ declineReason: DeclineDetail.DeclineReason) -> String {
        
        //    case - CreditAssessment - cry - IntroEmoji.cry.rawValue
        //    case - HasNameConflict - nameNotMatch - IntroEmoji.nameNotMatch.rawValue //case has been removed
        //    case - All Other generic - needMoreInfo - IntroEmoji.needMoreInfo.rawValue
        
        switch declineReason {
        case ._none: return ""
        case .employmentType:return IntroEmoji.needMoreInfo.rawValue
        case .hasWriteOff: return IntroEmoji.needMoreInfo.rawValue
        case .jointAccount: return IntroEmoji.needMoreInfo.rawValue
        case .monthlyPayCycle: return IntroEmoji.needMoreInfo.rawValue
        case .reachedCapacity: return IntroEmoji.needMoreInfo.rawValue
        case .hasOverdueLoans : return IntroEmoji.needMoreInfo.rawValue
        case .salaryInDifferentBank : return IntroEmoji.needMoreInfo.rawValue
        case .noEnoughSalaryInfo : return IntroEmoji.needMoreInfo.rawValue
        case .selectYourSalary : return IntroEmoji.needMoreInfo.rawValue
        case .payCycleStopped:  return IntroEmoji.needMoreInfo.rawValue
        case .identityConflict: return IntroEmoji.needMoreInfo.rawValue
            
        case .creditAssessment: return IntroEmoji.cry.rawValue
            
        }
    }
    
    func getButtonsTitle(_ declineReason: DeclineDetail.DeclineReason) -> (confirmButtonTitle : String, secondaryButton : String){
        
        //    IdentityConflict - "Chat with us"
        //    CreditAssessment - "Tell me why", "Chat with us"
        //    SelectYourSalary - "Select salary payments", "Learn more"
        //    SalaryInDifferentBank - "Chat with us"
        //    Other - "Chat with us"
        
        switch declineReason {
        case ._none: return ("", "")
            
        case .identityConflict: return (IntroButtonTitle.chatWithUs.rawValue, "")
        case .creditAssessment: return (IntroButtonTitle.tellMeWhy.rawValue, IntroButtonTitle.chatWithUs.rawValue)
        case .selectYourSalary : return (IntroButtonTitle.selectSalaryPayments.rawValue, IntroButtonTitle.learnMore.rawValue)
        case .salaryInDifferentBank : return (IntroButtonTitle.chatWithUs.rawValue, "")
            
        case .employmentType:return (IntroButtonTitle.chatWithUs.rawValue, "")
        case .hasWriteOff: return  (IntroButtonTitle.chatWithUs.rawValue, "")
        case .jointAccount: return (IntroButtonTitle.chatWithUs.rawValue, "")
        case .monthlyPayCycle: return (IntroButtonTitle.chatWithUs.rawValue, "")
        case .reachedCapacity: return  (IntroButtonTitle.chatWithUs.rawValue, "")
        case .hasOverdueLoans : return  (IntroButtonTitle.chatWithUs.rawValue, "")
        case .noEnoughSalaryInfo : return  (IntroButtonTitle.chatWithUs.rawValue, "")
        case .payCycleStopped:  return  (IntroButtonTitle.chatWithUs.rawValue, "")
            
        }
    }
    
    func confirmButtonAction() {
        
        let vm = self.viewModel as! DeclineDetailViewModel
        guard let declineDetails = vm.declineDetails, let declineReason = declineDetails.declineReason else { return  }
        
        switch declineReason {
        case ._none: break
            
        //tellMeWhy, chatWithUs
        case .creditAssessment:
            LoggingUtil.shared.cPrint("tellMeWhy - creditAssessment")
            NotificationUtil.shared.notify(UINotificationEvent.creditAssessment.rawValue, key: NotificationUserInfoKey.link.rawValue, value: declineDetails.learnMoreLink ?? "")
            break
            
        //selectSalaryPayments, learnMore
        case .selectYourSalary :
            LoggingUtil.shared.cPrint("selectYourSalary")
            NotificationUtil.shared.notify(UINotificationEvent.selectYourSalary.rawValue, key: "", value: "")
            break
            
                    
        //chatWithUs, ""
        case .salaryInDifferentBank :
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            break
        case .identityConflict:
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            break
        case .employmentType:
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            break
        case .hasWriteOff:
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            break
        case .jointAccount:
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            break
        case .monthlyPayCycle:
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            break
        case .reachedCapacity:
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            break
        case .hasOverdueLoans :
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            break
        case .noEnoughSalaryInfo :
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            break
        case .payCycleStopped:
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            break
        }
    }
    
    
    func secondaryButtonAction() {
        
        let vm = self.viewModel as! DeclineDetailViewModel
        guard let declineDetails = vm.declineDetails, let declineReason = declineDetails.declineReason else { return  }
        
        switch declineReason {
        case ._none: break
            
        //tellMeWhy, chatWithUs
        case .creditAssessment:
            LoggingUtil.shared.cPrint("present intercom")
            NotificationUtil.shared.notify(UINotificationEvent.intercom.rawValue, key: "", value: "")
            break
            
        //selectSalaryPayments, learnMore
        case .selectYourSalary :
            LoggingUtil.shared.cPrint("learnMore")
            NotificationUtil.shared.notify(UINotificationEvent.learnMore.rawValue, key: NotificationUserInfoKey.link.rawValue, value: declineDetails.learnMoreLink ?? "")
            break
                        
        //No Action required - Button not appear
        case .salaryInDifferentBank : break
        case .identityConflict: break
        case .employmentType:break
        case .hasWriteOff: break
        case .jointAccount: break
        case .monthlyPayCycle: break
        case .reachedCapacity: break
        case .hasOverdueLoans : break
        case .noEnoughSalaryInfo : break
        case .payCycleStopped: break
            
        }
    }
}
