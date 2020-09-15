//
//  IdentityVerificationVC.swift
//  CheqDev
//
//  Created by Sachin Amrale on 09/09/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class IdentityVerificationVC: UIViewController {

    //MARK: View Outlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var legalIdLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: CNButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    func setUpUI(){
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.showCloseButton()
        self.startButton.createShadowLayer()
        
        self.legalIdLabel.attributedText = self.attributedText(withString: "Government Issued ID\n\nThis could be a Driver’s licence, Passport or Medicare that is not expired", boldString: "Government Issued ID")
        
        self.ageLabel.attributedText = self.attributedText(withString: "Must be over 18 years of age\n\nYou must be an Australian citizen, permanent resident or have an Australian visa", boldString: "Must be over 18 years of age")
        
        self.timeLabel.attributedText = self.attributedText(withString: "5 mins of your time\n\nIt’s important you enter your details as accurately as possible.", boldString: "5 mins of your time")
        
        self.startButton.addTarget(self, action: #selector(startVerificationButtonClicked), for: .touchUpInside)
    }
    
    func attributedText(withString string: String, boldString: String) -> NSAttributedString{
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: UIFont(name: "SFUIText-Medium", size: 16)!,NSAttributedString
                                                            .Key.foregroundColor : UIColor.lightGray])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont(name: "SFUIText-Bold", size: 16)!,NSAttributedString
        .Key.foregroundColor : UIColor.black]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    //MARK: User Actions
    @objc func backButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func startVerificationButtonClicked(){
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.verifyDocs.rawValue) as! DocumentVerificationViewController
        vc.kycService = .frankie
        self.navigationController?.pushViewController(vc, animated: true)

    }

}
