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
    //@IBOutlet weak var refreshButton: UIButton!
    //@IBOutlet weak var securityView: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.viewModel = DeclineDetailViewModel()
        setupConfig()

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
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
        
        if let declineDetails = vm.declineDetails, let reason = declineDetails.declineReason{
            self.titleLabel.text = declineDetails.declineTitle
            self.caption.text = declineDetails.declineDescription
            
            
            let introductionViewModel = IntroductionViewModel()
            let introType = IntroductionViewModel.introTypeFromDeclineReason(reason) ?? IntroductionType.noPayCycle
            let introCoordinator = IntroductionViewModel.coordinatorFor(introType)
            introductionViewModel.coordinator = introCoordinator
            
            
            //self.titleLabel.text = introductionViewModel.coordinator.type.rawValue
            //self.caption.text = introductionViewModel.caption()
            self.imgVw.image = UIImage(named: introductionViewModel.imageName())
            self.confirmButton.setTitle(introductionViewModel.confirmButtonTitle(), for: .normal)
            self.secondaryButton.setTitle(introductionViewModel.nextButtonTitle(), for: .normal)
    }
    
//        switch viewModel.coordinator.type {
//           case .email, .enableLocation, .notification, .verifyIdentity, .employee, .employmentTypeDeclined, .creditAssessment, .jointAccount, .hasWriteOff, .noPayCycle, .monthlyPayCycle, .kycFailed, .identityConflict:
//                self.secondaryButton.isHidden = false
//                self.securityView.isHidden = true
//
//            case .setupBank:
//                self.titleLabel.text = "Connect your Bank"
//                self.titleLabel.font.withSize(35)
//                self.secondaryButton.isHidden = true
//                self.securityView.isHidden = false
//
//            default:
//                self.secondaryButton.isHidden = true
//       }
        
        
        
//            let declineReasons = DeclineDetailViewModel.declineReasons()
//            if declineReasons.contains(self.viewModel.coordinator.type) {
//                self.refreshButton.isHidden = false
//            } else {
//                self.refreshButton.isHidden = true
//            }
    }
}

extension DeclineDetailTableViewCell {
    
    @IBAction func btnFirstAction(_ sender: Any) {
        print("btnFirstAction")
    }
    
    @IBAction func btnSecondAction(_ sender: Any) {
        print("btnSecondAction")
    }
    
}
