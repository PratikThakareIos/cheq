//
//  PayCycleViewController.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 2/3/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class PayCycleViewController: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    var selectedRow:PostSalaryTransactionsRequest.PayFrequency? = .weekly
    @IBOutlet weak var btnConfirm: CNButton!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    enum choises: CaseIterable {
        case weekly, fortnightly, monthly
        var string: String {
            switch self {
            case .weekly: return "Weekly"
            case .fortnightly: return "Fortnightly"
            case .monthly: return "Monthly"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackButton()
        btnConfirm.createShadowLayer()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableView.backgroundColor = .clear
        

        let qVm = QuestionViewModel()
        qVm.loadSaved()
        let companyName = qVm.fieldValue(QuestionField.employerName) // "Acme Corp"
        self.lblSubTitle.text = "How often do you get  paid from \(companyName)?"
    }
}

extension PayCycleViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("choises.allCases.count = \(choises.allCases.count)")
        return choises.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayCycleCell", for: indexPath) as! SelectionTableViewCell
         //cell.selectionStyle = .none
         cell.title.text = choises.allCases[indexPath.row].string
         cell.backgroundColor = .clear
         AppConfig.shared.activeTheme.cardStyling(cell.content, addBorder: false)
         cell.content.backgroundColor = UIColor.init(hex: "FFFFFF")
                
         // cell.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 8, bottom: 20, right: 0))
         return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let choice = choises.allCases[indexPath.row]
        switch choice {
        case .weekly:
             selectedRow = .weekly
            break
        case .monthly:
             selectedRow = .monthly
            break
        case .fortnightly:
             selectedRow = .fortnightly
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @IBAction func btnConfirmAction(_ sender: Any) {
        
      //  putBankAccountRequest = PostSalaryTransactionsRequest(salaryTransactionIDs: Optional([353719, 352714]), payFrequency: Optional(Cheq_DEV.PostSalaryTransactionsRequest.PayFrequency.weekly), noSalary: Optional(false), isInAnotherBank: Optional(false))

       let putBankAccountRequest = PostSalaryTransactionsRequest(salaryTransactionIDs:  SalaryPaymentViewController.selectedTansactionList, payFrequency: selectedRow, noSalary:false, isInAnotherBank: false)
        
        print("putBankAccountRequest = \(putBankAccountRequest)")
        
        AppConfig.shared.showSpinner()
        CheqAPIManager.shared.postSalaryTransactions(req : putBankAccountRequest)
       .done{ success in
                AppConfig.shared.hideSpinner {
                   print(success)
                   NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
                   AppNav.shared.dismissModal(self)
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err) {
                      print("error")
                    }
                }
            }
    }
}
