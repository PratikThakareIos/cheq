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
    }

}
extension PayCycleViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choises.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayCycleCell", for: indexPath) as! SelectionTableViewCell
         cell.selectionStyle = .none
        cell.title.text = choises.allCases[indexPath.row].string
         cell.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 8, bottom: 20, right: 0))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        var footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0.0, height:0.0))

        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100.0))
    
        let nextButton = UIButton(frame: CGRect(x: 0, y: 40, width: tableView.frame.width - 24, height: 56.0))
        // here is what you should add:
        nextButton.center = footerView.center

        nextButton.setTitle("Confirm", for: .normal)
        nextButton.backgroundColor = ColorUtil.hexStringToUIColor(hex: "#4A0067")
        nextButton.layer.cornerRadius = 28.0
        nextButton.addTarget(self, action: #selector(confirmButtonClick(sender:)), for: .touchUpInside)
        footerView.addSubview(nextButton)
        
        return footerView
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @objc func confirmButtonClick(sender: UIButton!) {
        print("clicked",selectedRow!)
         AppConfig.shared.showSpinner()
        CheqAPIManager.shared.postSalaryTransactions(salaryTransactionIds: SalaryPaymentViewController.selectedTansactionList, payFrequency: selectedRow, _noSalary: SalaryPaymentViewController.selectedSalaryOption[0], _isInAnotherBank: SalaryPaymentViewController.selectedSalaryOption[1])
        .done{ success in
                 AppConfig.shared.hideSpinner {
                    print(success)
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
