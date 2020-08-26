//
//  PreviewLoanViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 19/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import PullToRefreshKit
import FBSDKCoreKit


protocol PreviewLoanViewControllerProtocol {
    func previewLoanViewControllerDismissedWithSucess(cashOutAmount : Int)
}

class PreviewLoanViewController: CTableViewController {

    @IBOutlet weak var viewForGradient: UIView!
    @IBOutlet weak var viewForScrollDown: UIView!
    @IBOutlet weak var btnScrollDown: UIButton!
    var delegate: PreviewLoanViewControllerProtocol!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = PreviewLoanViewModel()
        setupUI()
        setupDelegate()
    }
    
    override func registerCells() {
         let cellModels: [TableViewCellViewModelProtocol] = [SpacerTableViewCellViewModel(),SwipeToConfirmTableViewCellViewModel(),TransferCardTableViewCellViewModel(),AgreementItemTableViewCellViewModel()]
               for vm: TableViewCellViewModelProtocol in cellModels {
                   let nib = UINib(nibName: vm.identifier, bundle: nil)
                   self.tableView.register(nib, forCellReuseIdentifier: vm.identifier)
          }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        registerCells()
        registerObservables()
        hideBackTitle()
        NotificationUtil.shared.notify(UINotificationEvent.previewLoan.rawValue, key: "", value: "")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         AppData.shared.acceptedAgreement = false
        AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_cashout.rawValue, FirebaseEventKey.lend_cashout.rawValue, FirebaseEventContentType.screen.rawValue)
    }
    
    func setupUI() {
        self.tableView.addPullToRefreshAction {
            NotificationUtil.shared.notify(UINotificationEvent.previewLoan.rawValue, key: "", value: "")
        }
        
        showNavBar()
        showCloseButton()
        
        self.title = "Cash out summary "
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        
        viewForGradient.backgroundColor = .clear

        self.viewForGradient.isHidden = true
        self.viewForScrollDown.isHidden = true
        
        let fistColor =  UIColor(red: 244/255.0, green: 243/255.0, blue: 245/255.0, alpha: 0.1)
        let lastColor =  UIColor(red: 244/255.0, green: 243/255.0, blue: 245/255.0, alpha: 1.0)//rgba(244,243,245,1)
        let gradient = CAGradientLayer(start: .topCenter, end: .bottomCenter, colors: [fistColor.cgColor, lastColor.cgColor], type: .axial)
        gradient.frame = viewForGradient.bounds
        viewForGradient.layer.addSublayer(gradient)
    
        self.btnScrollDown.layer.masksToBounds = false
        self.btnScrollDown.layer.cornerRadius = 25.0 //self.frame.height/2
        self.btnScrollDown.layer.shadowColor = UIColor(red: 74/255.0, green: 0/255.0, blue: 103/255.0, alpha: 0.5).cgColor
        self.btnScrollDown.layer.shadowPath = UIBezierPath(roundedRect: self.btnScrollDown.bounds, cornerRadius: self.btnScrollDown.layer.cornerRadius).cgPath
        self.btnScrollDown.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        self.btnScrollDown.layer.shadowOpacity = 0.5
        self.btnScrollDown.layer.shadowRadius = 1.0
    }
    
    func registerObservables() {
        
        //setupKeyboardHandling()
        
        NotificationCenter.default.addObserver(self, selector: #selector(confirm(_:)), name: NSNotification.Name(UINotificationEvent.swipeConfirmation.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(previewLoan(_:)), name: NSNotification.Name(UINotificationEvent.previewLoan.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableLayout(_:)), name: NSNotification.Name(UINotificationEvent.reloadTableLayout.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openAgreement(_:)), name: NSNotification.Name(UINotificationEvent.openLink.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrolledToButtom(_:)), name: NSNotification.Name(UINotificationEvent.scrolledToButtom.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(webViewLoaded(_:)), name: NSNotification.Name(UINotificationEvent.webViewLoaded.rawValue), object: nil)
    }
    
    
    //Upon swiping the agreement this will evoke
    @objc func confirm(_ notification: NSNotification) {
        
        if (AppData.shared.acceptedAgreement == false){
            AppData.shared.acceptedAgreement = true
            LoggingUtil.shared.cPrint("confirm loan")
            
            //Firebase Event
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_cashout_agree.rawValue, FirebaseEventKey.lend_cashout_agree.rawValue, FirebaseEventContentType.button.rawValue)
            //Facebook Event
            AppConfig.shared.logCHEQ_FB_EVENTEvent(SOURCE: PassModuleScreen.Lend.rawValue, ITEM_ID: FacebookEventKey.lend_cashout_agree.rawValue, ITEM_NAME: FacebookEventKey.lend_cashout_agree.rawValue, CONTENT_TYPE: FirebaseEventContentType.button.rawValue)
            
            // return to LendingViewController and load
            AppConfig.shared.showSpinner()
            CheqAPIManager.shared.borrow().done { _ in
                AppConfig.shared.hideSpinner {
                    // return to LendingViewController and load
                    self.dismiss(animated: true) {
                        AppData.shared.acceptedAgreement = true
                        let borrowAmount = Int(AppData.shared.amountSelected) ?? 0
                        self.delegate!.previewLoanViewControllerDismissedWithSucess(cashOutAmount: borrowAmount)
                    }
                }
            }.catch { err in
                    AppData.shared.acceptedAgreement = false
                    AppConfig.shared.hideSpinner {
                        self.showError(err) {
                            NotificationUtil.shared.notify(UINotificationEvent.reloadTableLayout.rawValue, key: "", value: "")
                        }
                    }
            }
        }
    }
}


extension PreviewLoanViewController {
    
    @objc func previewLoan(_ notification: NSNotification) {
        AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_cashout_TC.rawValue, FirebaseEventKey.lend_cashout_TC.rawValue, FirebaseEventContentType.button.rawValue)
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.loanPreview().done{ loanPreview in
            AppData.shared.loanFee = loanPreview.fee ?? 0.0
            AppConfig.shared.hideSpinner {
                
                 LoggingUtil.shared.cPrint("\n\n>>loanPreview = \(loanPreview)")
                
                self.viewModel.sections.removeAll()
                var section = TableSectionViewModel()
                LoggingUtil.shared.cPrint("build view model here...")
                
                guard let vm = self.viewModel as?  PreviewLoanViewModel else { return }
                section.rows.append(SpacerTableViewCellViewModel())

                vm.addTransferToCard(loanPreview, section: &section)
                section.rows.append(SpacerTableViewCellViewModel())
                
                vm.addRepaymemtCard(loanPreview, section: &section)
                section.rows.append(SpacerTableViewCellViewModel())
                
                vm.addLoanAgreementCard(loanPreview, section: &section)
//                section.rows.append(SpacerTableViewCellViewModel())
                
//                vm.addDirectDebitAgreementCard(loanPreview, section: &section)
//                section.rows.append(SpacerTableViewCellViewModel())
                
//                section.rows.append(SpacerTableViewCellViewModel())
//                section.rows.append(SpacerTableViewCellViewModel())
//                section.rows.append(SpacerTableViewCellViewModel())
//                section.rows.append(SpacerTableViewCellViewModel())
//                section.rows.append(SpacerTableViewCellViewModel())
                
                section.rows.append(SwipeToConfirmTableViewCellViewModel())
                section.rows.append(SpacerTableViewCellViewModel())
                section.rows.append(SpacerTableViewCellViewModel())
                
                self.viewModel.addSection(section)
                self.tableView.reloadData()
                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
//                    self.viewForGradient.isHidden = false
//                    self.viewForScrollDown.isHidden = false
//
//                }
                    
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
    
    ///This will open up theterms and conditions one a webview
    @objc func openAgreement(_ notification: NSNotification) {
        guard let link =  notification.userInfo?[NotificationUserInfoKey.link.rawValue] else {
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle:nil)
        let termsViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
        termsViewController.url = link as? String
        termsViewController.modalPresentationStyle = .fullScreen
        self.present(termsViewController, animated:true, completion:nil)
    }
    
    @objc func webViewLoaded(_ notification: NSNotification) {
        self.viewForGradient.isHidden = false
        self.viewForScrollDown.isHidden = false
    }
}
extension PreviewLoanViewController {
    
    @IBAction func btnScrollDownAction(_ sender: Any) {
        NotificationUtil.shared.notify(UINotificationEvent.scrollDownToButtom.rawValue, key: "", value: "")
//        UIView.animate(withDuration: 0.7, delay: 0.25, options: .curveEaseOut, animations: {
//
//        }, completion: { finished in
//          self.viewForGradient.isHidden = true
//          self.viewForScrollDown.isHidden = true
//          self.view.layoutIfNeeded()
//        })
    }
    
    @objc func scrolledToButtom(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.7, delay: 0.25, options: .curveEaseOut, animations: {

        }, completion: { finished in
          self.viewForGradient.isHidden = true
          self.viewForScrollDown.isHidden = true
          self.view.layoutIfNeeded()
        })
    }
}
