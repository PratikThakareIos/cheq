//
//  SalaryPaymentViewController.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 1/31/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit

class SalaryPaymentViewController: UIViewController {
   
    @IBOutlet weak var grayView: UIView!
    
    @IBOutlet weak var BottonConstrainOnPopup: NSLayoutConstraint!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var tableView: UITableView!

    private let TABLE_CELL_TAGS = (checkbox:10, title:20,value:30)
    private var sateOfNewTansactionArray = [Bool]()
    static var selectedTansactionList = [Int] ()
    static var selectedSalaryOption = [false,false]
    private var tansactionDetailsArray = [SalaryTransactionResponse]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showBackButton()
        popUpView.layer.cornerRadius = 24
    }
    override func viewWillAppear(_ animated: Bool) {
        SalaryPaymentViewController.selectedTansactionList.removeAll()
        getData()
    }
    private func getData() {
        
        if AppData.shared.employeePaycycle == nil || AppData.shared.employeePaycycle.count == 0 {
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
        grayView.isHidden = false
        popUpView.isHidden = false
       // showAnimate()
    }
    
    @IBAction func salaryInAnotherAcct(_ sender: Any) {
        grayView.isHidden = true
        popUpView.isHidden = true
       
        SalaryPaymentViewController.selectedSalaryOption[0] = false
        SalaryPaymentViewController.selectedSalaryOption[1] = true
    }
    
    @IBAction func notShowimgSalary(_ sender: Any) {
         grayView.isHidden = true
         popUpView.isHidden = true
        
        SalaryPaymentViewController.selectedSalaryOption[0] = true
        SalaryPaymentViewController.selectedSalaryOption[1] = false
    }
    
    @IBAction func closeBtnPupup(_ sender: Any) {
         grayView.isHidden = true
         popUpView.isHidden = true
             
        SalaryPaymentViewController.selectedSalaryOption[0] = false
        SalaryPaymentViewController.selectedSalaryOption[1] = false
       // removeAnimate()
    }
    
    
    func showAnimate()
    {
        self.popUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.popUpView.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.popUpView.alpha = 1.0
            self.popUpView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }

    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.popUpView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.popUpView.alpha = 0.0
        }, completion: {(finished : Bool) in
            if(finished)
            {
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
        })
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       
        var footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0.0, height:0.0))

        footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100.0))
    
        let nextButton = UIButton(frame: CGRect(x: 0, y: 40, width: tableView.frame.width - 24, height: 56.0))
        // here is what you should add:
        nextButton.center = footerView.center

        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = ColorUtil.hexStringToUIColor(hex: "#4A0067")
        nextButton.layer.cornerRadius = 28.0
        nextButton.addTarget(self, action: #selector(nextButtonClick(sender:)), for: .touchUpInside)
        footerView.addSubview(nextButton)
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
    
    @objc func nextButtonClick(sender: UIButton!) {
        
        if self.tansactionDetailsArray.count > 0 {
            
            if SalaryPaymentViewController.selectedTansactionList.count >= 2 {
              guard let nav = self.navigationController else { return }
              let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
              let vc: PayCycleViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.payCycleViewController.rawValue) as! PayCycleViewController
              nav.pushViewController(vc, animated: true)
          }else{
//            let transactionModal: CustomSubViewPopup = UIView.fromNib()
//            transactionModal.viewModel.data = CustomPopupModel(description: "To be able to get paid on-demand, we need to know your income and how often you get paid. Try again once your situation  changes", imageName: "", modalHeight: 300)
//                   transactionModal.setupUI()
//                   let popupView = CPopupView(transactionModal)
//
//                   popupView.show()
                
            showMessage("Please select atleast 2 salary payments", completion: nil)
          }
        }
    }
    
    private func cellConfiguration(cell:UITableViewCell,data:SalaryTransactionResponse,indexpath: IndexPath) {
        
        ViewUtil.shared.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.title, text: "\(String(describing: data._description!) )")
        ViewUtil.shared.setTableCellLabelText(cell: cell, labelTag: TABLE_CELL_TAGS.value, text: "\(String(describing: data.amount!) )")
        let addButton = cell.viewWithTag(TABLE_CELL_TAGS.checkbox) as! UIButton

        /*accessibilityIdentifier is used to identify a particular element which takes an input parameter of a string

        assigning the indexpath button */
        addButton.accessibilityIdentifier = String (indexpath.row)

        let name =  self.sateOfNewTansactionArray.count > 0 && self.sateOfNewTansactionArray[indexpath.row] ? "checked" : "unchecked-1"
        addButton.setImage(UIImage(named: name), for: .normal)
        
        addButton.addTarget(self, action: #selector(self.checkBoxTapped), for:.touchUpInside)
    }
    
    @objc func checkBoxTapped(sender: UIButton)
       {
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


