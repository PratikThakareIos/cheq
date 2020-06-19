//
//  DocumentVerificationViewController.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 2/11/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class DocumentVerificationViewController: UIViewController {
    
    @IBOutlet weak var guidLineView: UIView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var tableview: UITableView!
    let cellSpacingHeight: CGFloat = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNavBar()
        showBackButton()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
            
        self.tableview.separatorStyle = .none
        self.mainContainer.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.guidLineView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableview.backgroundView?.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableview.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableview.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.reloadData()
    }
}

extension DocumentVerificationViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentVerifyTableViewCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear //AppConfig.shared.activeTheme.backgroundColor
        cell.content.backgroundColor = .white
        //cell.contentView.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        AppConfig.shared.activeTheme.cardStyling(cell.content, addBorder: true)
        cell.DocumnerVerifyLabel.text =  indexPath.row == 0 ? "Passport" : "Driver license"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        
        var kycSelectDoc : KycDocType?
        if indexPath.row == 0 {
            kycSelectDoc = .Passport //KycDocType(fromRawValue: "Passport")
        }else{
            kycSelectDoc = .DriversLicense //KycDocType(fromRawValue:"Driver license")
        }
        
        AppConfig.shared.showSpinner()
        let req = DataHelperUtil.shared.retrieveUserDetailsKycReq()
        CheqAPIManager.shared.retrieveUserDetailsKyc(req).done { response in
            let sdkToken = response.sdkToken ?? ""
            AppData.shared.saveOnfidoSDKToken(sdkToken)
            self.inittiateOnFido(kycSelectDoc: kycSelectDoc)
            
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(CheqAPIManagerError.unableToPerformKYCNow, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func inittiateOnFido(kycSelectDoc:KycDocType?)  {
        OnfidoManager.shared.fetchSdkToken().done { response in
            AppConfig.shared.hideSpinner {
                let onfidoSdkToken = response.sdkToken ?? ""
                AppData.shared.saveOnfidoSDKToken(onfidoSdkToken)
                AppNav.shared.navigateToKYCFlow(kycSelectDoc ?? KycDocType.Passport , viewController: self)
            }
            
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
                return
            }
        }
    }
    
}
