//
//  SalaryPaymentViewController.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 1/31/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

public enum PopUpType: String {
    case minTransactionSelection = "MinTransactionSelection"
    case salaryTransactionNotAvailable = "SalaryTransactionNotAvailable"
}

class SalaryPaymentViewController: UIViewController {
    

    @IBOutlet weak var viewMessage: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnNextAction: CNButton!
    @IBOutlet weak var lblSubTitle: UILabel!
    
    private let TABLE_CELL_TAGS = (checkbox:10, title:20, value:30)
    private var sateOfNewTansactionArray = [Bool]()
    static var selectedTansactionList = [Int] ()
    static var selectedSalaryOption = [false,false]
    private var tansactionDetailsArray = [SalaryTransactionResponse]()
    var isFromLendingScreen : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
    }
    
    func setupDelegate() {
         self.tableView.delegate = self
         self.tableView.dataSource = self
     }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        btnNextAction.createShadowLayer()
        
        let qVm = QuestionViewModel()
        qVm.loadSaved()
        let companyName = qVm.fieldValue(QuestionField.employerName) // "Acme Corp"
        self.lblSubTitle.text = "Help our bot detect your salary from \(companyName)"
        
        showNavBar()
        if isFromLendingScreen {
            showCloseButton()
        }else{
            showBackButton()
        }

        viewMessage.backgroundColor = .white
        viewMessage.layer.cornerRadius = 24
        
        self.tableView.estimatedRowHeight = AppConfig.shared.activeTheme.defaultButtonHeight
        self.tableView.backgroundColor = .white
        tableView.layer.cornerRadius = 24
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        SalaryPaymentViewController.selectedTansactionList.removeAll()
        getData()
    }
    
    private func getData() {
        
        if AppData.shared.employeePaycycle.count == 0 {
            AppConfig.shared.showSpinner()
            CheqAPIManager.shared.getSalaryPayCycleTimeSheets()
                .done{ paycyles in
                    AppConfig.shared.hideSpinner {
                        self.tansactionDetailsArray = paycyles as [SalaryTransactionResponse]
                        self.sateOfNewTansactionArray = Array(repeating: false, count: self.tansactionDetailsArray.count)
                        self.tableView.reloadData()
                    }
                }.catch { err in
                    AppConfig.shared.hideSpinner {
                        self.showError(err) {
                          print("error")
                        }
                    }
                }
        }else {
            self.tansactionDetailsArray = AppData.shared.employeePaycycle
            self.sateOfNewTansactionArray = Array(repeating: false, count: self.tansactionDetailsArray.count)
            self.tableView.reloadData()
            
        }
    }
    
    @IBAction func cantSeeMySalaryClicked(_ sender: Any) {
        self.openPopupWith(strFirst: "It's not showing my salary", strSecond: "My salary is in another bank", type: PopUpType.salaryTransactionNotAvailable )
    }

}

extension SalaryPaymentViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tansactionDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckboxCell", for: indexPath)
        cell.selectionStyle = .none
        cellConfiguration(cell: cell, data:tansactionDetailsArray[indexPath.row] , indexpath: indexPath)
        return cell
    }
    
    private func cellConfiguration(cell:UITableViewCell,data:SalaryTransactionResponse,indexpath: IndexPath) {
        
        ViewUtil.shared.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.title, text: "\(String(describing: data._description!) )")
        ViewUtil.shared.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.value, text: "$\(String(describing: data.amount!) )")
        let addButton = cell.viewWithTag(TABLE_CELL_TAGS.checkbox) as! UIButton

        /*accessibilityIdentifier is used to identify a particular element which takes an input parameter of a string

        assigning the indexpath button */
        addButton.accessibilityIdentifier = String (indexpath.row)

        let name =  self.sateOfNewTansactionArray.count > 0 && self.sateOfNewTansactionArray[indexpath.row] ? "checked" : "unchecked-1"
        addButton.setImage(UIImage(named: name), for: .normal)
        addButton.addTarget(self, action: #selector(self.checkBoxTapped), for:.touchUpInside)
    }
    
    @objc func checkBoxTapped(sender: UIButton){
        
            if let rowIndexString =  sender.accessibilityIdentifier, let rowIndex = Int(rowIndexString) {
                       self.sateOfNewTansactionArray[rowIndex] = !self.sateOfNewTansactionArray[rowIndex]//toggle the state when tapped multiple times
            }
            sender.isSelected = !sender.isSelected //image toggle
            SalaryPaymentViewController.selectedTansactionList.removeAll()

            for (index, element) in self.sateOfNewTansactionArray.enumerated() {
                   if element{
                      SalaryPaymentViewController.selectedTansactionList.append(tansactionDetailsArray[index].transactionId ?? 0)
                      print("selectedSongList :",SalaryPaymentViewController.selectedTansactionList)
                   }
            }
            tableView.reloadData()
     }
}

// MARK: UIBUtton Actions
extension SalaryPaymentViewController {
   
    @IBAction func btnNextAction(_ sender: Any) {
        if self.tansactionDetailsArray.count > 0 {
            if SalaryPaymentViewController.selectedTansactionList.count >= 2 {
              guard let nav = self.navigationController else { return }
              let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
              let vc: PayCycleViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.payCycleViewController.rawValue) as! PayCycleViewController
              nav.pushViewController(vc, animated: true)
          }else{
                self.openPopupWith(strFirst: "Please select atleast 2 salary payments", strSecond: nil , type : .minTransactionSelection)
          }
        }
    }
}


extension SalaryPaymentViewController : PayCyclePopUpVCDelegate {

    func openPopupWith(strFirst:String?, strSecond:String?, type : PopUpType){
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: StoryboardName.Popup.rawValue, bundle: Bundle.main)
        if let popupVC = storyboard.instantiateViewController(withIdentifier: PopupStoryboardId.payCyclePopUpVC.rawValue) as? PayCyclePopUpVC{
            popupVC.delegate = self
            popupVC.strFirst = strFirst
            popupVC.strSecond = strSecond
            popupVC.popUpType = type
            self.present(popupVC, animated: false, completion: nil)
        }
    }
    
    func tappedOnBtnFirst(popUpType: PopUpType) {
        print("tappedOnBtnFirst")
        if (popUpType == .salaryTransactionNotAvailable){
            //"It's not showing my salary"
            SalaryPaymentViewController.selectedSalaryOption[0] = true
            SalaryPaymentViewController.selectedSalaryOption[1] = false
            
            //ToDo : redirect to lending screen
            let putBankAccountRequest = PostSalaryTransactionsRequest(salaryTransactionIDs:[], payFrequency: nil, noSalary: true, isInAnotherBank: false)
            self.updateOnServer(putBankAccountRequest: putBankAccountRequest)
    
        }else{
            
        }
    }
    
    func tappedOnBtnSecond(popUpType: PopUpType) {
        print("tappedOnBtnSecond")
        if (popUpType == .salaryTransactionNotAvailable){
            //"My salary is in another bank"
            SalaryPaymentViewController.selectedSalaryOption[0] = false
            SalaryPaymentViewController.selectedSalaryOption[1] = true
            
            //ToDo : redirect to lending screen
            let putBankAccountRequest = PostSalaryTransactionsRequest(salaryTransactionIDs: [], payFrequency: nil, noSalary: false, isInAnotherBank: true)
            self.updateOnServer(putBankAccountRequest: putBankAccountRequest)
            
        }else{
            
        }
    }
    
    func tappedOnCloseButton(popUpType: PopUpType) {
        print("tappedOnCloseButton")
        if (popUpType == .salaryTransactionNotAvailable){
            SalaryPaymentViewController.selectedSalaryOption[0] = false
            SalaryPaymentViewController.selectedSalaryOption[1] = false
        }else{
            
        }
    }
    
    func updateOnServer(putBankAccountRequest: PostSalaryTransactionsRequest) {
        
//       let putBankAccountRequest = PostSalaryTransactionsRequest(salaryTransactionIDs:  SalaryPaymentViewController.selectedTansactionList, payFrequency: selectedRow, noSalary: SalaryPaymentViewController.selectedSalaryOption[0], isInAnotherBank: SalaryPaymentViewController.selectedSalaryOption[1])
        
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
