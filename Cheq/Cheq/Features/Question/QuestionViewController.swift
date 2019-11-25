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

    @IBOutlet weak var sectionTitle: CLabel!
    @IBOutlet weak var questionTitle: CLabel!
    @IBOutlet weak var nextButton: CButton!
    @IBOutlet weak var textField1: CTextField!
    @IBOutlet weak var textField2: CTextField!
    @IBOutlet weak var textField3: CTextField!
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
        self.updateKeyboardViews()
        if viewModel.coordinator.type == .legalName {
            hideBackButton()
        }
        
        if AppData.shared.completingDetailsForLending == true {
            showCloseButton()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupDelegate()
        setupUI()
        prePopulateEntry()
        setupLookupIfNeeded()
        if viewModel.coordinator.type == .maritalStatus {
            setupPicker()
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
        searchTextField.delegate = self
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.sectionTitle.font = AppConfig.shared.activeTheme.defaultFont
        self.sectionTitle.text = self.viewModel.coordinator.sectionTitle
       
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
        default: break
        }
        
        if AppData.shared.isOnboarding {
            AppConfig.shared.progressNavBar(progress: AppData.shared.progress, viewController: self)
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
            
            guard AppData.shared.completingDetailsForLending == false else {
                AppNav.shared.pushToQuestionForm(.residentialAddress, viewController: self)
                return
            }
            
            AppData.shared.updateProgressAfterCompleting(.legalName)
//            AppNav.shared.pushToMultipleChoice(.ageRange, viewController: self)
            AppNav.shared.pushToQuestionForm(.contactDetails, viewController: self)
            
        case .dateOfBirth:
            self.viewModel.save(QuestionField.dateOfBirth.rawValue, value: textField1.text ?? "")
            
            guard AppData.shared.completingDetailsForLending == false else {
                AppNav.shared.pushToMultipleChoice(.kycSelectDoc, viewController:self)
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
                        AppNav.shared.pushToIntroduction(.employee, viewController: self)
                    }
                }.catch { err in
                    AppConfig.shared.hideSpinner {
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

            // check if we are onboarding or completing details for lending
            if AppData.shared.completingDetailsForLending, AppData.shared.completingOnDemandOther  {
                AppData.shared.completingDetailsForLending = false
                AppData.shared.completingOnDemandOther = false
                let req = DataHelperUtil.shared.putUserEmployerRequest()
                AppConfig.shared.showSpinner()
                CheqAPIManager.shared.putUserEmployer(req).done { authUser in
                    AppConfig.shared.hideSpinner {
                        AppNav.shared.dismissModal(self)
                    }
                }.catch { err in
                    AppConfig.shared.hideSpinner {
                        self.showError(err) { }
                    }
                }
                
            } else {
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
            CheqAPIManager.shared.putUserEmployer(req).done { authUser in
                AppConfig.shared.hideSpinner {
                    if AppData.shared.completingDetailsForLending {
                        AppData.shared.completingDetailsForLending = false
                        AppNav.shared.dismissModal(self) { }
                    } else {
                        AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                    }
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err, completion: nil)
                }
            }
        case .maritalStatus:
            self.viewModel.save(QuestionField.maritalStatus.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.dependents.rawValue, value: textField2.text ?? "")
            // TO BE IMPLEMENTED
        case .bankAccount:
            LoggingUtil.shared.cPrint("bank account next")
            self.viewModel.save(QuestionField.bankName.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.bankBSB.rawValue, value: textField2.text ?? "")
            self.viewModel.save(QuestionField.bankAccNo.rawValue, value: textField3.text ?? "")
            self.viewModel.save(QuestionField.bankIsJoint.rawValue, value: String(switchWithLabel.switchValue()))
            AppConfig.shared.showSpinner()
            CheqAPIManager.shared.updateDirectDebitBankAccount().done { authUser in
                AppConfig.shared.hideSpinner {
                    if self.isModal {
                        AppNav.shared.dismissModal(self)
                    } else {
                        AppNav.shared.dismiss(self)
                    }
                }
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(err, completion: nil)
                }
            }
        }
    }
}

//MARK: Input validations
extension QuestionViewController {
    
    func saveResidentialAddress(_ address: GetAddressResponse) {
        self.viewModel.save(QuestionField.residentialAddress.rawValue, value: address.address ?? "")
        self.viewModel.save(QuestionField.residentialPostcode.rawValue, value: address.postCode ?? "")
        self.viewModel.save(QuestionField.residentialState.rawValue, value: address.state?.rawValue ?? "")
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
        let inputs = self.inputsFromTextFields(textFields: [self.searchTextField, self.textField1, self.textField2, self.textField3])
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


    func populatePlaceHolderNormalTextField() {
        if self.viewModel.coordinator.numOfTextFields == 3 {
            textField1.placeholder = self.viewModel.placeHolder(0)
            textField2.placeholder = self.viewModel.placeHolder(1)
            textField3.placeholder = self.viewModel.placeHolder(2)
        } else if self.viewModel.coordinator.numOfTextFields == 2 {
            textField1.placeholder = self.viewModel.placeHolder(0)
            textField2.placeholder = self.viewModel.placeHolder(1)
        } else {
            textField1.placeholder = self.viewModel.placeHolder(0)
        }
    }
    
    func showNormalTextFields() {
        if self.viewModel.coordinator.numOfTextFields == 3 {
            textField1.isHidden = false
            textField2.isHidden = false
            textField3.isHidden = false
            searchTextField.isHidden = true
        } else if self.viewModel.coordinator.numOfTextFields == 2 {
            textField1.isHidden = false
            textField2.isHidden = false
            textField3.isHidden = true
            searchTextField.isHidden = true
        } else {
            textField1.isHidden = false
            textField2.isHidden = true
            textField3.isHidden = true
            searchTextField.isHidden = true
        }
    }

    func showCheckbox() {
        if self.viewModel.coordinator.numOfCheckBox > 0 {
            self.switchWithLabel = CSwitchWithLabel(frame: CGRect.zero, title: self.viewModel.placeHolder(3))
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
    
    func hideNormalTextFields() {
        textField1.isHidden = true
        textField2.isHidden = true
        textField3.isHidden = true
        searchTextField.isHidden = false
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let qVm = QuestionViewModel()
        qVm.loadSaved()
        let employmentType = EmploymentType(fromRawValue: qVm.fieldValue(QuestionField.employerType))
        if self.viewModel.coordinator.type == .companyAddress, employmentType == .fulltime {
            return false
        }
        return true
    }
}

// MARK: UIViewControllerProtocol
extension QuestionViewController {
    @objc override func baseScrollView() -> UIScrollView? {
        return self.scrollView
    }
}

// MARK: Setup Look Up Logics
extension QuestionViewController{
    
    func setupEmployerNameLookup() {
        self.hideNormalTextFields()
        self.hideCheckbox()
        searchTextField.placeholder = self.viewModel.placeHolder(0)
        searchTextField.isUserInteractionEnabled = true
        searchTextField.itemSelectionHandler  = { item, itemPosition  in
            AppData.shared.selectedEmployer = itemPosition
            self.searchTextField.text = item[itemPosition].title
        }
        
        searchTextField.userStoppedTypingHandler = {
            if let query = self.searchTextField.text, query.count > self.searchTextField.minCharactersNumberToStartFiltering {
                CheqAPIManager.shared.employerAddressLookup(query).done { addressList in
                    
                    if addressList.isEmpty {
                        AppData.shared.selectedEmployer = -1
                        return
                    }
                    AppData.shared.employerList = addressList
                    var items = [CSearchTextFieldItem]()
                    for address in addressList {
                        let textFieldItem = CSearchTextFieldItem(title: address.name ?? "", subtitle: address.address ?? "")
                        items.append(textFieldItem)
                    }
                    self.searchTextField.filterItems(items)
                    }.catch {err in
                        LoggingUtil.shared.cPrint(err)
                }
            }
        }
    }
    
    func setupEmployerAddressLookup() {
        self.hideNormalTextFields()
        self.hideCheckbox()
        searchTextField.placeholder = self.viewModel.placeHolder(0)
        searchTextField.isUserInteractionEnabled = true
        searchTextField.itemSelectionHandler = { item, itemPosition in
            AppData.shared.selectedEmployerAddress = itemPosition
            let employerAddress: GetEmployerPlaceResponse = AppData.shared.employerAddressList[AppData.shared.selectedEmployerAddress]
            VDotManager.shared.markedLocation = CLLocation(latitude: employerAddress.latitude ?? 0.0
                , longitude: employerAddress.longitude ?? 0.0)
            self.searchTextField.text = item[itemPosition].title
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
        self.hideNormalTextFields()
        self.hideCheckbox()
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
