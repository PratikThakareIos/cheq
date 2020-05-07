//
//  MultipleChoiceViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 17/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK
import Onfido
import SDWebImage
import PromiseKit

class MultipleChoiceViewController: UIViewController {
    
    var viewModel = MultipleChoiceViewModel()
    var choices:[ChoiceModel] = []
    var selectedChoice: ChoiceModel?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sectionTitle: CLabel!
    @IBOutlet weak var questionTitle: CLabel!
    var showNextButton = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
        if showNextButton{
            showBackButton()
        }
    }
    
    func setupDelegate() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    func setupUI() {
        
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.hideBackTitle()
        // non-zero estimated row height to trigger automatically calculation of cell height based on auto layout on tableview
        self.tableView.estimatedRowHeight = AppConfig.shared.activeTheme.defaultButtonHeight
        self.tableView.backgroundColor = .clear
        self.questionTitle.font = AppConfig.shared.activeTheme.headerBoldFont
        self.questionTitle.text = self.viewModel.question()
        self.sectionTitle.font = AppConfig.shared.activeTheme.defaultFont
        self.sectionTitle.text = self.viewModel.coordinator.sectionTitle
        
        if AppData.shared.isOnboarding {
            AppConfig.shared.progressNavBar(progress: AppData.shared.progress, viewController: self)
        }
        
        if AppData.shared.completingDetailsForLending {
            AppConfig.shared.removeProgressNavBar(self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activeTimestamp()
        getTransactionData()
        
        if AppData.shared.completingDetailsForLending && viewModel.coordinator.coordinatorType != .workingLocation {
            showCloseButton()
        }
        
        if selectedChoice == nil {
            self.updateChoices()
        }
    }
    
    private func getTransactionData() {
        if AppData.shared.employeePaycycle?.count == 0 {
            AppConfig.shared.showSpinner()
            CheqAPIManager.shared.getSalaryPayCycleTimeSheets()
                .done { paycyles in
                    AppConfig.shared.hideSpinner {
                        print("Transaction success")
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
    
    func updateChoices() {
        
        if self.viewModel.coordinator.coordinatorType == .financialInstitutions {
            self.getUsersBankConnectionStatus()
        }else{
            AppConfig.shared.showSpinner()
            self.viewModel.coordinator.choices().done { choices in
                AppConfig.shared.hideSpinner {
                    self.choices = choices
                    self.tableView.reloadData()
                }
                
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err, completion: nil)
                }
            }
        }
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension MultipleChoiceViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.choices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let choice = self.choices[indexPath.row]
        switch choice.type {
        case .choiceWithCaption:
            return setupCellForChoiceWithCaption(choice, tableView: tableView, indexPath: indexPath)
        case .choiceWithIcon:
            return setupCellForChoiceWithIcon(choice, tableView: tableView, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let choice = self.choices[indexPath.row]
        self.selectedChoice = choice
        switch self.viewModel.coordinator.coordinatorType {
            
        case .kycSelectDoc:
            
            let kycSelectDoc = KycDocType(fromRawValue: choice.title)
            viewModel.savedAnswer[QuestionField.kycDocSelect.rawValue] = kycSelectDoc.rawValue
            OnfidoManager.shared.fetchSdkToken().done { response in
                let onfidoSdkToken = response.sdkToken ?? ""
                AppData.shared.saveOnfidoSDKToken(onfidoSdkToken)
                AppNav.shared.navigateToKYCFlow(kycSelectDoc, viewController: self)
            }.catch { err in
                self.showError(err, completion: nil)
                return
            }
            
        case .employmentType:
            
            let employmentType = EmploymentType(fromRawValue: choice.title)
            viewModel.savedAnswer[QuestionField.employerType.rawValue] = employmentType.rawValue
            AppData.shared.updateProgressAfterCompleting(.employmentType)
            if employmentType == .onDemand {
                AppNav.shared.pushToMultipleChoice(.onDemand, viewController: self)
            } else {
                // AppNav.shared.pushToIntroduction(.enableLocation, viewController: self)
                AppNav.shared.pushToQuestionForm(.companyName, viewController: self)
            }
            
        case .workingLocation:
            
            print("Location clicked")
            if (selectedChoice?.title == WorkLocationType.fixLocation.rawValue){
                AppNav.shared.pushToQuestionForm(.companyAddress, viewController: self)
            }else{
                if isIncomeDetected() == false {
                    print("Upload time sheet anything other than fix location")
                    incomeVerification()
                }
            }
            
        case .onDemand:
            
            let vm = self.viewModel
            vm.save(QuestionField.employerName.rawValue, value: choice.title)
            vm.save(QuestionField.employerType.rawValue, value: EmploymentType.onDemand.rawValue)
            let qVm = QuestionViewModel()
            qVm.loadSaved()
            let req = DataHelperUtil.shared.putUserEmployerRequest()
            AppData.shared.completingOnDemandOther = (choice.title == OnDemandType.other.rawValue) ? true : false
            
            if AppData.shared.completingDetailsForLending, AppData.shared.completingOnDemandOther {
                AppNav.shared.pushToQuestionForm(.companyName, viewController: self)
                return
            }
            
            /* Mark: If uber selected (demanding company other than other) */
            CheqAPIManager.shared.putUserEmployer(req).done { authUser in
                AppData.shared.updateProgressAfterCompleting(.onDemand)
                if AppData.shared.completingDetailsForLending, self.isModal {
                    self.incomeVerification()
                } else {
                    AppData.shared.updateProgressAfterCompleting(.onDemand)
                    AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                }
            }.catch { err in
                self.showError(err) {
                    AppNav.shared.dismissModal(self)
                }
            }
            
        case .financialInstitutions:
            // storing the selected bank and bank list before pushing to the dynamicFormViewController
            // to render the form
            let selectedChoice = self.choices[indexPath.row]
            self.gotoNewScreenWith(choiceModel: selectedChoice)
            
        case .ageRange:
            
            let vm = self.viewModel
            vm.save(QuestionField.ageRange.rawValue, value: choice.title)
            AppData.shared.updateProgressAfterCompleting(.ageRange)
            AppNav.shared.pushToQuestionForm(.contactDetails, viewController: self)
            
        case .state:
            
            let vm = self.viewModel
            vm.save(QuestionField.residentialState.rawValue, value: choice.title)
            AppData.shared.updateProgressAfterCompleting(.state)
            let qVm = QuestionViewModel()
            qVm.loadSaved()
            let putUserDetailsReq = qVm.putUserDetailsRequest()
            AppConfig.shared.showSpinner()
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
                return CheqAPIManager.shared.putUser(authUser)
            }.then { authUser in
                return CheqAPIManager.shared.putUserDetails(putUserDetailsReq)
            }.done { authUser in
                AppConfig.shared.hideSpinner {
                    AppData.shared.updateProgressAfterCompleting(.maritalStatus)
                    AppNav.shared.pushToIntroduction(.employee, viewController: self)
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(CheqAPIManagerError.errorHasOccurredOnServer) {
                    }
                }
            }
            
        case .kycSelectDoc:
            LoggingUtil.shared.cPrint("trigger onfido kyc")
            return
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        var footerView = UIView(frame: CGRect(x: 0, y: 0, width: 0.0, height:0.0))
        if showNextButton {
            footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100.0))
            let nextButton = UIButton(frame: CGRect(x: 0, y: 40, width: tableView.frame.width - 24, height: 56.0))
            // here is what you should add:
            nextButton.center = footerView.center
            
            nextButton.setTitle("Next", for: .normal)
            nextButton.backgroundColor = ColorUtil.hexStringToUIColor(hex: "#4A0067")
            nextButton.layer.cornerRadius = 28.0
            nextButton.addTarget(self, action: #selector(hello(sender:)), for: .touchUpInside)
            footerView.addSubview(nextButton)
        }
        return footerView
    }
    
    @objc func hello(sender: UIButton!) {
        print("Next");
    }
}

extension MultipleChoiceViewController {
    
    func setupCellForChoiceWithCaption(_ choice: ChoiceModel, tableView: UITableView, indexPath: IndexPath)-> UITableViewCell {
        let reuseId = String(describing: CMultipleChoiceWithCaptionCell.self)
        let cell = tableView .dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! CMultipleChoiceWithCaptionCell
        cell.titleLabel.text = choice.title
        cell.captionLabel.text = choice.caption ?? ""
        cell.captionLabel.textColor = ColorUtil.hexStringToUIColor(hex: "#999999")
        cell.backgroundColor = .clear
        AppConfig.shared.activeTheme.cardStyling(cell.containerView, addBorder: true)
        return cell
    }
    
    func setupCellForChoiceWithIcon(_ choice: ChoiceModel, tableView: UITableView, indexPath: IndexPath)-> UITableViewCell {
        let reuseId = String(describing: CMultipleChoiceWithImageCell.self)
        let cell = tableView .dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! CMultipleChoiceWithImageCell
        cell.choiceTitleLabel.text = choice.title
        cell.choiceTitleLabel.textColor = AppConfig.shared.activeTheme.textColor
        
        // set placeholder first
        cell.iconImageView.image = UIImage.init(named: BankLogo.placeholder.rawValue)
 
        if let imageName = choice.image, imageName.isEmpty == false {
            cell.iconImageView.isHidden = false
            
            if self.viewModel.coordinator.coordinatorType != .financialInstitutions {
                if var view: UIView = cell.iconImageView {
                    ViewUtil.shared.circularMask(&view, radiusBy: .height)
                }
            }
        
            //            cell.iconImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage.init(named: BankLogo.placeholder.rawValue), options: [], progress: nil, completed: { (image, error, cacheType, imageURL) in
            //            })ll'/
                                
            if let url = URL(string: imageName), UIApplication.shared.canOpenURL(url as URL) {
                cell.iconImageView.setImageForURL(imageName)
            }else{
                if let img = UIImage.init(named: imageName){
                    cell.iconImageView.image = img
                }
            }
        }
        cell.backgroundColor = .clear
        AppConfig.shared.activeTheme.cardStyling(cell.containerView, addBorder: true)
        return cell
    }
    
    func showTransactions() {
        guard let nav = self.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: SalaryPaymentViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.salaryPayments.rawValue) as! SalaryPaymentViewController
        nav.pushViewController(vc, animated: true)
    }
    
    func incomeVerification(){
        print(AppData.shared.employeeOverview?.eligibleRequirement!.hasPayCycle)
        print(AppData.shared.employeePaycycle?.count)
        if !(AppData.shared.employeeOverview?.eligibleRequirement!.hasPayCycle)! && ((AppData.shared.employeePaycycle?.count) != nil) {
            showTransactions()
        }else if (AppData.shared.employeeOverview?.eligibleRequirement!.hasPayCycle)! && AppData.shared.employeePaycycle == nil {
            // show popup but for now navigate to lending page
            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
            AppNav.shared.dismissModal(self){}
        }else {
            //             self.delegate?.refreshLendingScreen()
            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
            AppNav.shared.dismissModal(self){}
        }
        
    }
}


extension MultipleChoiceViewController {
    func isIncomeDetected() -> Bool {
        print(AppData.shared.employeeOverview?.eligibleRequirement?.hasPayCycle)
        return AppData.shared.employeeOverview?.eligibleRequirement?.hasPayCycle ?? false
    }
        
    func getUsersBankConnectionStatus(){
        
        AppConfig.shared.showSpinner()
        
        AuthConfig.shared.activeManager.getCurrentUser().then{ authUser-> Promise<GetUserActionResponse> in
            //When the user opens the app the apps checks if the user has a basiq account or not
            return CheqAPIManager.shared.getUserActions()
        }.done { userActionResponse in
            
            /*
             The backend will return one of these condition
             
             RequireMigration - User has not linked their bank account with Basiq yet
             InvalidBankCredentials - Since the user has last opened their app Basiq has informed us that they are not able to access the user’s account as  they have changed their password
             ActionRequiredByBank - this is when the user needs to perform an action on their bank account before they can access their bank
             AccountReactivation- this occurs when the user has not logged in to the Cheq app and they need to “relink” their bank
             BankNotSupported - this occurs when the user’s bank is no longer supported.
             MissingAccount - this needs to call PUT v1/users to create basiq accounts
             
             if there is no issue with the user (none of these states are active) then the user proceeds to the spending dashboard as normal.
             */
            
            
            AppConfig.shared.hideSpinner {
                LoggingUtil.shared.cPrint("\n>> userActionResponse = \(userActionResponse)")
                switch (userActionResponse.userAction){
                case ._none:
                    LoggingUtil.shared.cPrint("go to home screen")
                    break
                case .actionRequiredByBank:
                    //LoggingUtil.shared.cPrint("err")
                    break
                case .bankNotSupported:
                    //LoggingUtil.shared.cPrint("err")
                    break
                case .invalidCredentials:
                    //LoggingUtil.shared.cPrint("err")
                    break
                case .missingAccount:

                    AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
                        return CheqAPIManager.shared.putUser(authUser)
                    }.then { authUser in
                        AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
                    }.then { authUser in
                        AuthConfig.shared.activeManager.setUser(authUser)
                    }.done { authUser in
                        self.getUsersBankConnectionStatus()
                    }.catch { err in
                        AppConfig.shared.hideSpinner {
                            print(err)
                            print(err.localizedDescription)
                            self.showError(CheqAPIManagerError.errorHasOccurredOnServer) {
                            }
                        }
                    }
                    break
                case .requireMigration,.requireBankLinking, .accountReactivation:
                    
//                UserAction: RequireMigration, RequireBankLinking, AccountReactivation
//                LinkedInstitutionId is not null, auto-select the bank by LinkedInstitutionId
//                LinkedInstitutionId is null, ask users to select institution from bank list
                    
                  self.getBankListFromServer(linkedInstitutionId : userActionResponse.linkedInstitutionId)
                  break
             
                case .none:
                    LoggingUtil.shared.cPrint("err")
                }
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                // handle err
                print(err.localizedDescription)
                self.showError(CheqAPIManagerError.errorHasOccurredOnServer) {
                }
            }
        }
    }
    
    
    func getBankListFromServer(linkedInstitutionId : String?){
        AppConfig.shared.showSpinner()
        self.viewModel.coordinator.choices().done { choices in
            
            var foundBankModel : ChoiceModel?
            if let linkedInstitutionId = linkedInstitutionId, choices.count > 0{
                 for obj in choices {
                      if let ref = obj.ref as? GetFinancialInstitution, ref._id == linkedInstitutionId {
                           LoggingUtil.shared.cPrint("match found = \(ref)")
                           foundBankModel = obj
                           break
                      }
                }
            }
            
            AppConfig.shared.hideSpinner {
                if let obj = foundBankModel{
                   self.gotoNewScreenWith(choiceModel: obj)
                }else{
                    self.choices = choices
                    self.tableView.reloadData()
                }
            }
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
    
    
    func gotoNewScreenWith(choiceModel : ChoiceModel){
       
        AppData.shared.updateProgressAfterCompleting(.financialInstitutions)
        AppData.shared.selectedFinancialInstitution = choiceModel.ref as? GetFinancialInstitution
        guard let bank = AppData.shared.selectedFinancialInstitution else { showError(AuthManagerError.invalidFinancialInstitutionSelected, completion: nil)
            return
        }
        AppData.shared.updateProgressAfterCompleting(.financialInstitutions)
        AppNav.shared.pushToDynamicForm(bank, viewController: self)
    }
    
//    func getBankListFromServer(){
//        AppConfig.shared.showSpinner()
//        self.viewModel.coordinator.choices().done { choices in
//            AppConfig.shared.hideSpinner {
//                    self.choices = choices
//                    self.tableView.reloadData()
//            }
//        }.catch { err in
//            AppConfig.shared.hideSpinner {
//                self.showError(err, completion: nil)
//            }
//        }
//    }
}
