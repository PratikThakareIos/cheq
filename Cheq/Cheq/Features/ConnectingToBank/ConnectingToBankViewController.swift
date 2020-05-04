//
//  ConnectingToBankViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 28/11/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

/**
 ConnectingToBankViewController is a loading indication screen that is presented when we are doing linking of banks using **MoneySoft SDK**.
 */
class ConnectingToBankViewController: UIViewController {

    @IBOutlet weak var progressBar: CProgressView!
    /// refer to **ConnectingToBankViewController** on **Common** storyboard
    @IBOutlet weak var titleLabel: CLabel!
    @IBOutlet weak var descriptionLabel: CLabel!
    @IBOutlet weak var loadingLabel: UILabel!
    
    @IBOutlet weak var image: UIImageView!
    var viewModel = ConnectingToBankViewModel()
    let transparentView = UIView()
    @IBOutlet weak var progressBarContainer: UIView!
    var bankName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        transparentView.backgroundColor = .clear
        let rootVc = AppNav.shared.rootViewController()
        rootVc.view.addSubview(transparentView)
        rootVc.view.bringSubviewToFront(transparentView)
        AutoLayoutUtil.pinToSuperview(transparentView, padding: 0.0)
         registerObservables()
    }
    
    func registerObservables() {
        setupKeyboardHandling()
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.moneysoftEvent.rawValue), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTable(_:)), name: NSNotification.Name(UINotificationEvent.basiqEvent.rawValue), object: nil)
        
     
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.transparentView.removeFromSuperview()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservables()
    }
    
    func setupUI() {
        self.bankName = AppData.shared.selectedFinancialInstitution?.shortName ?? ""
        self.view.backgroundColor = AppConfig.shared.activeTheme.primaryColor
        self.titleLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        self.loadingLabel.text = "Connecting to \(bankName).."
        self.titleLabel.font = AppConfig.shared.activeTheme.headerBoldFont
        self.descriptionLabel.textColor = AppConfig.shared.activeTheme.altTextColor
        self.descriptionLabel.font = AppConfig.shared.activeTheme.mediumFont
        self.progressBar.setProgress(0.1, animated: true)
        self.progressBar.mode = .gradientMonetary
        self.progressBar.setupConfig()
    }
}

extension ConnectingToBankViewController {
    
    
//    //Handle Moneysoftevents to update progressbar
//    @objc func reloadTable(_ notification: NSNotification) {
//
//        guard let category = notification.userInfo?[NotificationUserInfoKey.moneysoftProgress.rawValue] as? MoneySoftLoadingEvents else { return }
//
//        DispatchQueue.main.async {
//              switch category {
//                case .connectingtoBank:
//                    self.loadingLabel.text = "Connecting to \(self.bankName).."
//                       self.progressBar.setProgress(0.3, animated: true)
//                case .requestingStatementsForAccounts:
//                       self.loadingLabel.text = "Requesting statements for accounts.."
//                       self.progressBar.setProgress(0.45, animated: true)
//                case .retrievingStatementsFromBank:
//                       self.loadingLabel.text = "Retrieving statements from bank.."
//                       self.progressBar.setProgress(0.60, animated: true)
//                case .analysingYourBankStatement:
//                        self.loadingLabel.text = "Analysing your bank statement.."
//                        self.progressBar.setProgress(0.75, animated: true)
//                case .categorisingYourTransactions:
//                        self.loadingLabel.text = "Categorising your transactions.."
//                        self.progressBar.setProgress(0.90, animated: true)
//                   DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                        //Load dashboard after 2seconds
//                        self.loadingLabel.text = "Loading Dashboard.."
//                        self.progressBar.setProgress(0.95, animated: true)
//                   }
//                default:
//                        self.progressBar.setProgress(0.3, animated: true)
//                }
//        }
//    }
    
    @objc func reloadTable(_ notification: NSNotification) {
       
        guard let step = notification.userInfo?[NotificationUserInfoKey.basiqProgress.rawValue] as? GetConnectionJobResponse.Step else { return }
        
       // NotificationUtil.shared.notify(UINotificationEvent.basiqEvent.rawValue, key: NotificationUserInfoKey.basiqProgress.rawValue, object: GetConnectionJobResponse.Step.verifyingCredentials)

        DispatchQueue.main.async {
              switch step {
                case .verifyingCredentials:
                       self.loadingLabel.text = "Connecting to \(self.bankName).."
                       self.progressBar.setProgress(0.25, animated: true)
                case .retrievingAccounts:
                       self.loadingLabel.text = "Retrieving statements from bank..."
                       self.progressBar.setProgress(0.50, animated: true)
                case .retrievingTransactions:
                       self.loadingLabel.text = "Analysing your bank statement..."
                       self.progressBar.setProgress(0.70, animated: true)
                case .categorisation:
                        self.loadingLabel.text = "Categorising your transactions..."
                        self.progressBar.setProgress(0.80, animated: true)

                   DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        //Load dashboard after 2seconds
                        self.loadingLabel.text = "Loading Dashboard.."
                        self.progressBar.setProgress(0.95, animated: true)
                   }
                
                default:
                        self.progressBar.setProgress(0.3, animated: true)
                }
        }
    }
    
}

