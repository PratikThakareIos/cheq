//
//  QuestionFormViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 16/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import DateToolsSwift
import PromiseKit
import UDatePicker
import UserNotifications
import CoreLocation
import SearchTextField

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var ImageViewContainer: UIView!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var lblContactInfo: UILabel! //We use this for verification and security texts
    @IBOutlet weak var questionTitle: CLabel!
    @IBOutlet weak var questionDescription: UILabel!
    
    @IBOutlet weak var nextButton: CNButton!
    @IBOutlet weak var textField1: CNTextField!
    @IBOutlet weak var textField2: CNTextField!
    @IBOutlet weak var textField3: CNTextField!
    @IBOutlet weak var textField4: CNTextField!
    @IBOutlet weak var nextButtonBottom: NSLayoutConstraint!
    @IBOutlet weak var checkboxContainerView: UIView!
    var switchWithLabel = CSwitchWithLabel()
    
    @IBOutlet weak var searchTextField: CSearchTextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    var datePicker: UDatePicker?
    var viewModel = QuestionViewModel()
    var pickerViewCoordinator = QuestionPickerViewCoordinator()
    var activeTextField = UITextField()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activeTimestamp()
        //setupKeyboardHandling()
        self.updateKeyboardViews()
        
        if viewModel.coordinator.type == .legalName {
            let firstname = viewModel.fieldValue(.firstname)
            let lastname = viewModel.fieldValue(.lastname)
            if (firstname.count == 0){
                hideBackButton() //is from registration then hide back button
            }else{
                //is from lending screen - verify details               
                showCloseButton()
                textField1.text = firstname
                textField2.text = lastname
            }
            
        }else if viewModel.coordinator.type == .companyName || viewModel.coordinator.type == .companyAddress || viewModel.coordinator.type == .verifyHomeAddress || viewModel.coordinator.type == .verifyName{
            showNavBar()
            showBackButton()
            
        }else if viewModel.coordinator.type == .bankAccount {
            showCloseButton()
        }
    
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //removeObservables()
        self.view.endEditing(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.showNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupUI()
        self.setupLookupIfNeeded()
        prePopulateEntry()
        if viewModel.coordinator.type == .maritalStatus {
            setupPicker()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        self.setupLookupIfNeeded()
        getTransactionData()
    }
    
    private func getTransactionData() {
        if AppData.shared.employeePaycycle?.count == 0 {
            AppConfig.shared.showSpinner()
            CheqAPIManager.shared.getSalaryPayCycleTimeSheets()
                .done{ paycyles in
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
        }else {
            print(AppData.shared.employeeOverview?.eligibleRequirement!.hasPayCycle)
        }
    }
    
    func setupLookupIfNeeded() {
        if viewModel.coordinator.type == .residentialAddress {
            setupResidentialAddressLookup()
        } else if viewModel.coordinator.type == .companyName {
            setupEmployerNameLookup()
        } else if viewModel.coordinator.type == .companyAddress {
            setupEmployerAddressLookup()
        }
    }
    
    func setupPicker() {
        let maritalStatusPicker = CPickerView(.maritalStatus)
        maritalStatusPicker.delegate = self.pickerViewCoordinator
        maritalStatusPicker.dataSource = self.pickerViewCoordinator
        self.textField1.inputView = maritalStatusPicker
        
        let dependentsPicker = CPickerView(.dependents)
        dependentsPicker.delegate = self.pickerViewCoordinator
        dependentsPicker.dataSource = self.pickerViewCoordinator
        self.textField2.inputView = dependentsPicker
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextField1(_:)), name: NSNotification.Name(QuestionField.maritalStatus.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextField2(_:)), name: NSNotification.Name(QuestionField.dependents.rawValue), object: nil)
    }
    
    func setupDelegate() {
        textField1.delegate = self
        textField2.delegate = self
        textField3.delegate = self
        textField4.delegate = self
        searchTextField.delegate = self
    }
    
    // change the button title
    func changeButtonTitle(){
        nextButton.setTitle("Confirm",for: .normal)
        let qvm = QuestionViewModel()
        qvm.loadSaved()
        let firstname = qvm.fieldValue(.firstname)
        let lastname = qvm.fieldValue(.lastname)
        textField1.text = firstname
        textField2.text = lastname
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        //self.sectionTitle.font = AppConfig.shared.activeTheme.defaultFont
        self.sectionTitle.text = self.viewModel.coordinator.sectionTitle
        self.questionDescription.isHidden = true
        self.nextButton.createShadowLayer()
        self.hideBackTitle()
        self.showNormalTextFields()
        self.showCheckbox()
        self.populatePlaceHolderNormalTextField()
        self.questionTitle.font = AppConfig.shared.activeTheme.headerBoldFont
        self.questionTitle.text = self.viewModel.question()
        
        // special case for address look up
        switch self.viewModel.coordinator.type {
        case  .residentialAddress:
            self.setupResidentialAddressLookup()
        case .companyName:
            self.setupEmployerNameLookup()
        case .companyAddress:
            self.setupEmployerAddressLookup()
        case .bankAccount:
            self.changeButtonTitle()
            //self.showImageContainer()
            self.questionDescription.text = "Please ensure that this account matches the account you entered in the Cheq app"
            self.questionDescription.isHidden = false
            self.ImageViewContainer.isHidden = true
        case .verifyName:
            self.hideImageContainer()
        case .verifyHomeAddress:
            self.hideImageContainer()
        case .legalName:
            self.legalNameAutoFill()
        default: break
        }
        
        self.lblContactInfo.isHidden = true
        if viewModel.coordinator.type == .contactDetails {
            self.lblContactInfo.isHidden = false
            self.textField1.keyboardType = .phonePad

        }
        
        //manish to hide nav bar
        if AppData.shared.isOnboarding {
            //AppConfig.shared.progressNavBar(progress: AppData.shared.progress, viewController: self)
        }
        
        if AppData.shared.completingDetailsForLending {
            AppConfig.shared.removeProgressNavBar(self)
        }
    }
    
    func updateKeyboardViews() {
        self.textField1.reloadInputViews()
        self.textField2.reloadInputViews()
        self.searchTextField.reloadInputViews()
    }
    
    func prePopulateEntry() {
        viewModel.loadSaved()
        switch viewModel.coordinator.type {
        case .companyAddress:
            self.searchTextField.text = ""
            if AppData.shared.employerList.count > 0, AppData.shared.selectedEmployer >= 0, AppData.shared.selectedEmployer < AppData.shared.employerList.count {
                let employer = AppData.shared.employerList[AppData.shared.selectedEmployer]
                let employerName = employer.name ?? ""
                let employerAddress = employer.address ?? ""
                if employerAddress == viewModel.fieldValue(QuestionField.employerAddress), employerName ==  viewModel.fieldValue(QuestionField.employerName) {
                    self.searchTextField.text = viewModel.fieldValue(QuestionField.employerAddress)
                    AppData.shared.employerAddressList = AppData.shared.employerList
                    AppData.shared.selectedEmployerAddress = AppData.shared.selectedEmployer
                }
            }
            self.searchTextField.keyboardType = .default
        default: break
        }
    }
    
    func populatePopup(){
//        let transactionModal: CustomSubViewPopup = UIView.fromNib()
//        transactionModal.viewModel.data = CustomPopupModel(description: "We've detected these bank details have been used by another user. Please ensure these details belong to you", imageName: "accountEmoji", modalHeight: 400, headerTitle: "Bank Details Already in use")
//        transactionModal.setupUI()
//        let popupView = CPopupView(transactionModal)
//        popupView.show()
        
        self.openPopupWith(heading: "Bank details already in use",
                           message: "We have detected these bank details have been used by another user. Please ensure these details belong to you",
                           buttonTitle: "",
                           showSendButton: false,
                           emoji: UIImage(named: "transferFailed"))
    }
    
    //    func prePopulateEntry() {
    //        viewModel.loadSaved()
    //        switch viewModel.coordinator.type {
    //        case .legalName:
    //            self.textField1.text = viewModel.fieldValue(QuestionField.firstname)
    //            self.textField1.keyboardType = .namePhonePad
    //            self.textField2.text = viewModel.fieldValue(QuestionField.lastname)
    //            self.textField2.keyboardType = .namePhonePad
    //        case .dateOfBirth:
    //            self.textField1.text = viewModel.fieldValue(QuestionField.dateOfBirth)
    //            self.textField1.keyboardType = .default
    //        case .contactDetails:
    //            self.textField1.text = viewModel.fieldValue(QuestionField.contactDetails)
    //            self.textField1.keyboardType = .namePhonePad
    //        case .residentialAddress:
    //            self.searchTextField.text = viewModel.fieldValue(QuestionField.residentialAddress)
    //            self.searchTextField.keyboardType = .default
    //        case .companyName:
    //            self.searchTextField.text = AppData.shared.completingOnDemandOther ? "" : viewModel.fieldValue(QuestionField.employerName)
    //            self.searchTextField.keyboardType = .default
    //        case .companyAddress:
    //            self.searchTextField.text = viewModel.fieldValue(QuestionField.employerAddress)
    //            self.searchTextField.keyboardType = .default
    //        case .maritalStatus:
    //            self.textField1.text = viewModel.fieldValue(QuestionField.maritalStatus)
    //            self.textField2.text = viewModel.fieldValue(QuestionField.dependents)
    //            self.textField1.keyboardType = .default
    //            self.textField2.keyboardType = .default
    //        case .bankAccount:
    //            self.textField1.text = viewModel.fieldValue(QuestionField.bankName)
    //            self.textField2.text = viewModel.fieldValue(QuestionField.bankBSB)
    //            self.textField3.text = viewModel.fieldValue(QuestionField.bankAccNo)
    //        }
    //    }
    
    @IBAction func next(_ sender: Any) {
        

        if let error = self.validateInput() {
            showError(error, completion: nil)
            return
        }
        
        switch self.viewModel.coordinator.type {
        case .legalName:
            
            self.viewModel.save(QuestionField.firstname.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.lastname.rawValue, value: textField2.text ?? "")
            
            //This will hit only in the lending flow
            guard AppData.shared.completingDetailsForLending == false else {
                // AppNav.shared.pushToQuestionForm(.residentialAddress, viewController: self)
                AppNav.shared.pushToQuestionForm(.verifyHomeAddress, viewController: self)
                return
            }
            
            AppData.shared.updateProgressAfterCompleting(.legalName)
            //AppNav.shared.pushToMultipleChoice(.ageRange, viewController: self)
            AppNav.shared.pushToQuestionForm(.contactDetails, viewController: self)
            
        //manish
        case .dateOfBirth:
            self.viewModel.save(QuestionField.dateOfBirth.rawValue, value: textField1.text ?? "")
            
            guard AppData.shared.completingDetailsForLending == false else {
                let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
                guard let nav = self.navigationController else { return }
                let vc: DocumentVerificationViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.verifyDocs.rawValue) as! DocumentVerificationViewController
                nav.pushViewController(vc, animated: true)
                // AppNav.shared.pushToMultipleChoice(.kycSelectDoc, viewController:self)
                return
            }
            
            AppData.shared.updateProgressAfterCompleting(.dateOfBirth)
            AppNav.shared.pushToQuestionForm(.contactDetails, viewController: self)
            
        case .contactDetails:
            self.viewModel.save(QuestionField.contactDetails.rawValue, value: textField1.text ?? "")
            AppData.shared.updateProgressAfterCompleting(.contactDetails)
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
                    AppData.shared.updateProgressAfterCompleting(.contactDetails)
                    AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    print(err)
                    print(err.localizedDescription)
                    self.showError(CheqAPIManagerError.errorHasOccurredOnServer) {
                    }
                }
            }
        case .residentialAddress:
            self.viewModel.save(QuestionField.residentialAddress.rawValue, value: searchTextField.text ?? "")
            
            guard AppData.shared.completingDetailsForLending == false else {
                AppNav.shared.pushToQuestionForm(.dateOfBirth, viewController: self)
                return
            }
            
            AppConfig.shared.showSpinner()
            if AppData.shared.residentialAddressList.count > 0 {
                let address = AppData.shared.residentialAddressList[AppData.shared.selectedResidentialAddress]
                self.saveResidentialAddress(address)
            }
            
            let putUserDetailsReq = self.viewModel.putUserDetailsRequest()
            CheqAPIManager.shared.putUserDetails(putUserDetailsReq).done { authUser in
                AppConfig.shared.hideSpinner {
                    AppData.shared.updateProgressAfterCompleting(.residentialAddress)
                    AppNav.shared.pushToIntroduction(.employee, viewController: self)
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(CheqAPIManagerError.errorHasOccurredOnServer) {
                        LoggingUtil.shared.cPrint(err.localizedDescription)
                    }
                }
                return
            }
            break
        case .companyName:
            if AppData.shared.employerList.count > 0, AppData.shared.selectedEmployer >= 0, AppData.shared.selectedEmployer < AppData.shared.employerList.count {
                let employer = AppData.shared.employerList[AppData.shared.selectedEmployer]
                self.viewModel.save(QuestionField.employerAddress.rawValue, value: employer.address ?? "")
            }
            self.viewModel.save(QuestionField.employerName.rawValue, value: searchTextField.text ?? "")
            AppData.shared.updateProgressAfterCompleting(.companyName)
            
            // check if we are onboarding or completing details for lending if other option selected
            if AppData.shared.completingDetailsForLending, AppData.shared.completingOnDemandOther  {
                AppData.shared.completingDetailsForLending = false
                AppData.shared.completingOnDemandOther = false
                let req = DataHelperUtil.shared.putUserEmployerRequest()
                AppConfig.shared.showSpinner()
                print(req.address)
                CheqAPIManager.shared.putUserEmployer(req).done { authUser in
                    AppConfig.shared.hideSpinner {
                        self.incomeVerification()
                    }
                }.catch { err in
                    AppConfig.shared.hideSpinner {
                        print(err.code())
                        print(err.localizedDescription)
                        self.showError(err) { }
                    }
                }
                
                //Other option selcted
                if (isIncomeDetected()){
                    print("Update time sheet")
                }
                
            } else {
                //Employement type other than on demand
                //                if (isIncomeDetected()){
                //                   self.delegate?.refreshLendingScreen()
                //                   AppNav.shared.dismissModal(self)
                //                    return
                //                }
                //Select the working locatrion
                
                // AppNav.shared.presentToMultipleChoice(.workingLocation, viewController: self)
                AppNav.shared.pushToQuestionForm(.companyAddress, viewController: self)
            }
        case .companyAddress:
            
            if let err = self.validateCompanyAddressLookup() {
                showError(err, completion: nil)
                return
            }
            self.viewModel.save(QuestionField.employerAddress.rawValue, value: searchTextField.text ?? "")
            LoggingUtil.shared.cPrint("Go to some other UI component here")
            AppData.shared.updateProgressAfterCompleting(.companyAddress)
            AppConfig.shared.showSpinner()
            let employerAddress = AppData.shared.employerAddressList[AppData.shared.selectedEmployerAddress]
            saveEmployerAddress(employerAddress)
            let req = DataHelperUtil.shared.putUserEmployerRequest()
            print(req.workingLocation)
            
            //Company addresss from a fix location
            CheqAPIManager.shared.putUserEmployer(req).done { authUser in
                AppConfig.shared.hideSpinner {
                    if AppData.shared.completingDetailsForLending {
                        AppData.shared.completingDetailsForLending = false
                        //                        self.delegate?.refreshLendingScreen()
                        self.incomeVerification()
                    } else {
                        AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                    }
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    print(err.code())
                    print(err.localizedDescription)
                    self.showError(err, completion: nil)
                }
            }
        
        case .maritalStatus:
            self.viewModel.save(QuestionField.maritalStatus.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.dependents.rawValue, value: textField2.text ?? "")
            
        // This is the starting point of 3rd step in lending flow
        case .bankAccount:
            
            if (switchWithLabel.switchValue()){
                self.showJointAccountNotSupportedPopUp()
                return
            }
            LoggingUtil.shared.cPrint("bank account next")
            self.viewModel.save(QuestionField.firstname.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.lastname.rawValue, value: textField2.text ?? "")
            self.viewModel.save(QuestionField.bankBSB.rawValue, value: textField3.text ?? "")
            self.viewModel.save(QuestionField.bankAccNo.rawValue, value: textField4.text ?? "")
            // enter other values
            self.viewModel.save(QuestionField.bankIsJoint.rawValue, value: String(switchWithLabel.switchValue()))
            
            AppConfig.shared.showSpinner()
            CheqAPIManager.shared.updateDirectDebitBankAccount().done { authUser in
                AppConfig.shared.hideSpinner {
                    NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
                    AppNav.shared.dismissModal(self)
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    print(err)
                    self.populatePopup()
                    
//                    let transactionModal: CustomSubViewPopup = UIView.fromNib()
//                    transactionModal.viewModel.data = CustomPopupModel(description: "We have detected these bank details have been used by another user. Please ensure these detailsbelong to you", imageName: "", modalHeight: 300, headerTitle: "Bank details already in use")
//                    transactionModal.setupUI()
//                    let popupView = CPopupView(transactionModal)
//                    popupView.show()
                    // self.showError(err, completion: nil)
                }
            }
        // AppNav.shared.pushToQuestionForm(.verifyHomeAddress, viewController: self)
            
        case .verifyName:
            self.viewModel.save(QuestionField.firstname.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.lastname.rawValue, value: textField2.text ?? "")
            AppNav.shared.pushToQuestionForm(.verifyHomeAddress, viewController: self)
        
        case .verifyHomeAddress:
            self.viewModel.save(QuestionField.unitNumber.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.homeAddress.rawValue, value: textField2.text ?? "")
            guard AppData.shared.completingDetailsForLending == false else {
                AppNav.shared.pushToQuestionForm(.dateOfBirth, viewController: self)
                return
            }
            AppNav.shared.pushToQuestionForm(.residentialAddress, viewController: self)
        }
    }
    
    func showTransactions() {
        guard let nav = self.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: SalaryPaymentViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.salaryPayments.rawValue) as! SalaryPaymentViewController
        nav.pushViewController(vc, animated: true)
    }
    
    func incomeVerification(){
        if (AppData.shared.employeeOverview?.eligibleRequirement!.hasPayCycle)! && ((AppData.shared.employeePaycycle?.count) != nil) {
            showTransactions()
        }else if (AppData.shared.employeeOverview?.eligibleRequirement!.hasPayCycle)! && AppData.shared.employeePaycycle?.count == 0 {
            // need to show popup but for now land on lending page
            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
            AppNav.shared.dismissModal(self){}
        }else {
            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
            AppNav.shared.dismissModal(self){}
        }
    }
}

//MARK: Input validations
extension QuestionViewController {
    
    func saveResidentialAddress(_ address: GetAddressResponse) {
        self.viewModel.save(QuestionField.residentialAddress.rawValue, value: address.address ?? "")
        self.viewModel.save(QuestionField.residentialPostcode.rawValue, value: address.postCode ?? "")
        self.viewModel.save(QuestionField.residentialState.rawValue, value: address.state ?? "")
        // self.viewModel.save(QuestionField.residentialState.rawValue, value: address.state?.rawValue ?? "")
        self.viewModel.save(QuestionField.residentialCountry.rawValue, value: address.country ?? "")
    }
    
    func saveEmployerAddress(_ address: GetEmployerPlaceResponse) {
        self.viewModel.save(QuestionField.employerAddress.rawValue, value: address.address ?? "")
        self.viewModel.save(QuestionField.employerPostcode.rawValue, value: address.postCode ?? "")
        let latitude = address.latitude ?? 0.0
        let longitude = address.longitude ?? 0.0
        self.viewModel.save(QuestionField.employerLatitude.rawValue, value: String(latitude))
        self.viewModel.save(QuestionField.employerLongitude.rawValue, value: String(longitude))
        VDotManager.shared.markedLocation = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func inputsFromTextFields(textFields: [UITextField])-> [String: Any] {
        var results = [String: Any]()
        for textField in textFields {
            if let key = textField.placeholder, let value = textField.text {
                results[key] = value
            }
        }
        return results
    }
    
    func validateCompanyAddressLookup()->ValidationError? {
        guard AppData.shared.employerAddressList.count > 0 || AppData.shared.employerList.count > 0 else {
            self.searchTextField.text = ""
            return ValidationError.autoCompleteIsMandatory
        }
        
        let autoCompleteMatch = AppData.shared.employerAddressList.filter { $0.address == searchTextField.text }
        let autoCompleteMatch2 = AppData.shared.employerList.filter { $0.address == searchTextField.text }
        if autoCompleteMatch.count == 1 || autoCompleteMatch2.count == 1 {
            return nil
        } else {
            self.searchTextField.text = ""
            return ValidationError.autoCompleteIsMandatory
        }
    }
    
    func validateInput()->Error? {
        let inputs = self.inputsFromTextFields(textFields: [self.searchTextField, self.textField1, self.textField2, self.textField3, self.textField4])
        return self.viewModel.coordinator.validateInput(inputs)
    }
    
    func hasEmptyFields(_ fields:[UITextField])->Bool {
        for field in fields {
            if field.text?.isEmpty ?? true { return true }
        }
        return false
    }
}

//MARK: TextFields show/hide
extension QuestionViewController {
    
    //TODO: -
    @objc func keyboardDidShow(notification: NSNotification) {
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            var buttonPosition : CGFloat = 0.0
            if self.viewModel.coordinator.numOfTextFields == 3 {
                buttonPosition = 0.0
            } else if self.viewModel.coordinator.numOfTextFields == 2 {
                buttonPosition = keyboardSize.height
            } else {
                buttonPosition = keyboardSize.height
            }
            self.nextButtonBottom.constant = 450.0 //buttonPosition
            
            UIView.animate(withDuration: duration + 0.15 , delay: 0, options: UIView.AnimationOptions.init(rawValue: curve), animations: {
                self.view.layoutIfNeeded()
            }) { ani in
                
            }
        }
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        self.nextButtonBottom.constant = 12
        UIView.animate(withDuration: 0.25) {
            //self.scrollView.contentOffset.y  = 0
            self.view.layoutIfNeeded()
        }
    }
        
    func populatePlaceHolderNormalTextField() {
        if self.viewModel.coordinator.numOfTextFields == 4 {
            textField1.placeholder = self.viewModel.placeHolder(0)
            textField2.placeholder = self.viewModel.placeHolder(1)
            textField3.placeholder = self.viewModel.placeHolder(2)
            textField4.placeholder = self.viewModel.placeHolder(3)
        }
        else if self.viewModel.coordinator.numOfTextFields == 3 {
            textField1.placeholder = self.viewModel.placeHolder(0)
            textField2.placeholder = self.viewModel.placeHolder(1)
            textField3.placeholder = self.viewModel.placeHolder(2)
        } else if self.viewModel.coordinator.numOfTextFields == 2 {
            textField1.placeholder = self.viewModel.placeHolder(0)
            textField2.placeholder = self.viewModel.placeHolder(1)
            
            //manish
            let firstname = viewModel.fieldValue(.firstname)
            if (firstname.count == 0){
                self.hideNavBar() //is from registration then hide back button
            }
        
        } else {
           textField1.placeholder = self.viewModel.placeHolder(0)
        }
        
        if (viewModel.coordinator.type == .companyName || viewModel.coordinator.type == .companyAddress || viewModel.coordinator.type == .residentialAddress || viewModel.coordinator.type == .verifyName){
            textField1.placeholder = ""
            searchTextField.placeholder = self.viewModel.placeHolder(0)
         }
       
    }
    
    func showNormalTextFields() {
        
        if self.viewModel.coordinator.numOfTextFields == 4 {
            textField1.isHidden = false
            textField2.isHidden = false
            textField3.isHidden = false
            textField4.isHidden = false
            searchTextField.isHidden = true
        }else if self.viewModel.coordinator.numOfTextFields == 3 {
            textField1.isHidden = false
            textField2.isHidden = false
            textField3.isHidden = false
            textField4.isHidden = true
            searchTextField.isHidden = true
        }else if self.viewModel.coordinator.numOfTextFields == 2 {
            textField1.isHidden = false
            textField2.isHidden = false
            textField3.isHidden = true
            textField4.isHidden = true
            searchTextField.isHidden = true
        }else {
            textField1.isHidden = false //manish
            textField2.isHidden = true
            textField3.isHidden = true
            textField4.isHidden = true
            searchTextField.isHidden = true
        }
     
        textField1.setupLeftPadding()
        textField2.setupLeftPadding()
        textField3.setupLeftPadding()
        textField4.setupLeftPadding()
        
        textField1.setShadow()
        textField2.setShadow()
        textField3.setShadow()
        textField4.setShadow()
        searchTextField.setShadow()

        if !(viewModel.coordinator.type == .companyName || viewModel.coordinator.type == .companyAddress || viewModel.coordinator.type == .residentialAddress || viewModel.coordinator.type == .verifyName){
            if !textField1.isHidden {
                textField1.becomeFirstResponder()
            }
        }
    }
    
    func showCheckbox() {
        if self.viewModel.coordinator.numOfCheckBox > 0 {
            self.switchWithLabel = CSwitchWithLabel(frame: CGRect.zero, title: self.viewModel.placeHolder(4))
            self.checkboxContainerView.isHidden = false
            self.checkboxContainerView.addSubview(self.switchWithLabel)
            AutoLayoutUtil.pinToSuperview(self.switchWithLabel, padding: 0)
        } else {
            self.checkboxContainerView.isHidden = true
        }
    }
    
    func hideCheckbox() {
        self.checkboxContainerView.isHidden = true
    }
    
    // show Image containerview desined for bank details
    func showImageContainer(){
        if self.viewModel.coordinator.numOfImageContainer > 0 {
            self.ImageViewContainer.isHidden = false
        }
        else {
            self.ImageViewContainer.isHidden = true
        }
    }
    
    func hideImageContainer(){
        self.ImageViewContainer.isHidden = true
        let qvm = QuestionViewModel()
        qvm.loadSaved()
        let unit = qvm.fieldValue(.unitNumber)
        let address = qvm.fieldValue(.homeAddress)
        textField1.text = unit
        textField2.text = address
    }
    
    func legalNameAutoFill()  {
        //        let qvm = QuestionViewModel()
        //        qvm.loadSaved()
        //        let firstname = qvm.fieldValue(.firstname)
        //        let lastname = qvm.fieldValue(.lastname)
        //        textField1.text = firstname
        //        textField2.text = lastname
    }
    
    func hideNormalTextFields() {
        self.searchTextField.isHidden = false
        self.textField1.isHidden = true
        self.textField2.isHidden = true
        self.textField3.isHidden = true
        self.textField4.isHidden = true
        self.view.layoutIfNeeded()
    }
}

// MARK: Update to picker notifications
extension QuestionViewController {
    @objc func updateTextField1(_ notification: Notification) {
        LoggingUtil.shared.cPrint("updateTextField1")
        let value = notification.userInfo?["selected"] as? String ?? ""
        self.textField1.text = value
        self.activeTextField.resignFirstResponder()
    }
    
    @objc func updateTextField2(_ notification: Notification) {
        LoggingUtil.shared.cPrint("updateTextField2")
        let value = notification.userInfo?["selected"] as? String ?? ""
        self.textField2.text = value
        self.activeTextField.resignFirstResponder()
    }
    
    
}

// MARK: UITextFieldDelelgate
extension QuestionViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch self.viewModel.coordinator.type {
            
        case .maritalStatus:
            LoggingUtil.shared.cPrint(textField.placeholder ?? "")
            self.activeTextField = textField
            
        case .residentialAddress:
            LoggingUtil.shared.cPrint("search residential addresss")
            
        case .dateOfBirth:
            LoggingUtil.shared.cPrint("show date picker")
            showDatePicker(textField1, initialDate: 18.years.earlier, picker: datePicker)
            textField.resignFirstResponder()
            
        default: break
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if viewModel.coordinator.type == .contactDetails{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }else{
            return true
        }
    
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let qVm = QuestionViewModel()
        qVm.loadSaved()
        let employmentType = EmploymentType(fromRawValue: qVm.fieldValue(QuestionField.employerType))
        //manish
//        if self.viewModel.coordinator.type == .companyAddress, employmentType == .fulltime {
//            return false
//        }
        return true
    }
}

// MARK: UIViewControllerProtocol
extension QuestionViewController {
    /*
     @objc override func baseScrollView() -> UIScrollView? {
     return self.scrollView
     }
     */
}

// MARK: Setup Look Up Logics
extension QuestionViewController{
    
    func setupEmployerNameLookup() {
        self.hideNormalTextFields()
        self.hideCheckbox()
        self.hideImageContainer()
       
        searchTextField.placeholder = self.viewModel.placeHolder(0)
        searchTextField.isUserInteractionEnabled = true
        searchTextField.itemSelectionHandler  = { item, itemPosition  in
            AppData.shared.selectedEmployer = itemPosition
            self.searchTextField.text = item[itemPosition].title
        }
        
        //        searchTextField.userStoppedTypingHandler = {
        //            if let query = self.searchTextField.text, query.count > self.searchTextField.minCharactersNumberToStartFiltering {
        //                CheqAPIManager.shared.employerAddressLookup(query).done { addressList in
        //
        //                    if addressList.isEmpty {
        //                        AppData.shared.selectedEmployer = -1
        //                        return
        //                    }
        //                    AppData.shared.employerList = addressList
        //                    var items = [CSearchTextFieldItem]()
        //                    for address in addressList {
        //                        let textFieldItem = CSearchTextFieldItem(title: address.name ?? "", subtitle: address.address ?? "")
        //                        items.append(textFieldItem)
        //                    }
        //                    self.searchTextField.filterItems(items)
        //                    }.catch {err in
        //                        LoggingUtil.shared.cPrint(err)
        //                }
        //            }
        //        }
    }
    
    func setupEmployerAddressLookup() {
        
        self.hideNormalTextFields()
        self.hideCheckbox()
        self.hideImageContainer()
     
        searchTextField.placeholder = self.viewModel.placeHolder(0)
        searchTextField.isUserInteractionEnabled = true
        
        searchTextField.itemSelectionHandler = { item, itemPosition in
            AppData.shared.selectedEmployerAddress = itemPosition
            let employerAddress: GetEmployerPlaceResponse = AppData.shared.employerAddressList[AppData.shared.selectedEmployerAddress]
            VDotManager.shared.markedLocation = CLLocation(latitude: employerAddress.latitude ?? 0.0
                , longitude: employerAddress.longitude ?? 0.0)
            self.searchTextField.text = item[itemPosition].title
            //self.searchTextField.resignFirstResponder()
        }
        
        searchTextField.userStoppedTypingHandler = {
            if let query = self.searchTextField.text, query.count > self.searchTextField.minCharactersNumberToStartFiltering {
                CheqAPIManager.shared.employerAddressLookup(query).done { addressList in
                    // keep the address list
                    AppData.shared.employerAddressList = addressList
                    self.searchTextField.filterStrings(addressList.map{ $0.address ?? "" })
                }.catch {err in
                    LoggingUtil.shared.cPrint(err)
                }
            }
        }
        
    }
    
    func setupResidentialAddressLookup() {
        let qvm = QuestionViewModel()
        qvm.loadSaved()
        let address = qvm.fieldValue(.residentialAddress)
        searchTextField.text = address
        
        
        self.hideNormalTextFields()
        self.hideCheckbox()
        self.hideImageContainer()
        
        searchTextField.placeholder = self.viewModel.placeHolder(0)
        searchTextField.isUserInteractionEnabled = true
        searchTextField.itemSelectionHandler  = { item, itemPosition  in
            AppData.shared.selectedResidentialAddress = itemPosition
            self.searchTextField.text = item[itemPosition].title
        }
        searchTextField.userStoppedTypingHandler = {
            if let query = self.searchTextField.text, query.count > self.searchTextField.minCharactersNumberToStartFiltering {
                CheqAPIManager.shared.residentialAddressLookup(query).done { addressList in
                    AppData.shared.residentialAddressList = addressList
                    self.searchTextField.filterStrings(addressList.map{ $0.address ?? "" })
                }.catch {err in
                    LoggingUtil.shared.cPrint(err)
                }
            }
        }
    }
}
extension QuestionViewController {
    func isIncomeDetected() -> Bool {
        print(AppData.shared.employeeOverview?.eligibleRequirement?.hasPayCycle)
        return false
    }
}


//MARK: - Verification popup
extension QuestionViewController: VerificationPopupVCDelegate{
    
    

    
    func showJointAccountNotSupportedPopUp(){
        self.openPopupWith(heading: "Something went wrong",
                           message: "Unfortunately, we do not currently cater to users who have joint bank account",
                           buttonTitle: "",
                           showSendButton: false,
                           emoji: UIImage(named: "transferFailed"))
     }
    
    //
    func openPopupWith(heading:String?,message:String?,buttonTitle:String?,showSendButton:Bool?,emoji:UIImage?){
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: StoryboardName.Popup.rawValue, bundle: Bundle.main)
        if let popupVC = storyboard.instantiateInitialViewController() as? VerificationPopupVC{
            popupVC.delegate = self
            popupVC.heading = heading ?? ""
            popupVC.message = message ?? ""
            popupVC.buttonTitle = buttonTitle ?? ""
            popupVC.showSendButton = showSendButton ?? false
            popupVC.emojiImage = emoji ?? UIImage()
            self.present(popupVC, animated: false, completion: nil)
        }
    }
    
    func tappedOnSendButton(){
 
    }
    
    func tappedOnCloseButton(){
      
    }
}
