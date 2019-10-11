//
//  LendingViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

class LendingViewController: UIViewController {

    var viewModel = LendingViewModel()
    
    // Loan amount control
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var loanAmountHeader: UILabel!
    @IBOutlet weak var loanAmount: UILabel!
    @IBOutlet weak var loanAmountCaption: UILabel!
    @IBOutlet weak var increaseLoanAmouontButton: UIButton!
    @IBOutlet weak var decreaseLoanAmouontButton: UIButton!
    
    // Complete Details section
    @IBOutlet weak var completeDetailsCardView: UIView!
    
    @IBOutlet weak var controlViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var stackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ViewUtil.shared.circularMask(&self.controlView)
        ViewUtil.shared.circularMask(&self.infoView)
        ViewUtil.shared.applyBorder(&self.infoView, borderSize: 20.0, color: AppConfig.shared.activeTheme.backgroundColor)
    }

    func setupUI() {
        if let completeDetails = UINib(nibName: "CompleteDetailsCardView", bundle: Bundle.main).instantiate(withOwner: self, options: nil)[0] as? CompleteDetailsCardView {
            completeDetails.frame.size = self.completeDetailsCardView.frame.size
            self.completeDetailsCardView.addSubview(completeDetails)
        }
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        AppConfig.shared.activeTheme.cardStyling(self.completeDetailsCardView, addBorder: true)
        
        // loan amount
        self.infoView.backgroundColor = AppConfig.shared.activeTheme.altTextColor
        self.controlView.backgroundColor = AppConfig.shared.activeTheme.lightGrayColor
        self.loanAmount.font = AppConfig.shared.activeTheme.headerFont
        self.loanAmount.textColor = AppConfig.shared.activeTheme.textColor
        self.loanAmountHeader.font = AppConfig.shared.activeTheme.defaultFont
        self.loanAmountHeader.textColor = AppConfig.shared.activeTheme.grayTextColor
        self.loanAmountCaption.font = AppConfig.shared.activeTheme.defaultFont
        self.loanAmountCaption.textColor = AppConfig.shared.activeTheme.grayTextColor
        self.updateControlButtons()
        
    }
    
    @IBAction func minusPressed(_ sender: Any) {
        LoggingUtil.shared.cPrint("minusPressed")
        viewModel.minus()
        self.updateControlButtons()
    }
    
    @IBAction func plusPressed(_ sender: Any) {
        LoggingUtil.shared.cPrint("plusPressed")
        viewModel.plus()
        self.updateControlButtons()
    }
    
    func updateControlButtons() {
        self.decreaseLoanAmouontButton.isEnabled = viewModel.minusEnabled
        self.increaseLoanAmouontButton.isEnabled = viewModel.plusEnabled
        let amount: WithdrawalAmount = viewModel.currentSelectedAmount()
        let loanAmount = String("$\(amount.rawValue)")
        let attributedString = NSMutableAttributedString(string: loanAmount)
        attributedString.applyHighlight(amount.rawValue, color: AppConfig.shared.activeTheme.textColor, font: AppConfig.shared.activeTheme.extraLargeFont)
        self.loanAmount.attributedText = attributedString
    }
}

extension LendingViewController {
    @objc override func baseScrollView() -> UIScrollView? {
        return self.scrollView
    }
}
