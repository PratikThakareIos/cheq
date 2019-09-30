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

class QuestionViewController: UIViewController {

    @IBOutlet weak var sectionTitle: CLabel!
    @IBOutlet weak var questionTitle: CLabel!
    @IBOutlet weak var nextButton: CButton!
    @IBOutlet weak var textField1: CTextField!
    @IBOutlet weak var textField2: CTextField!
    @IBOutlet weak var searchTextField: CSearchTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var datePicker: UDatePicker?
    var viewModel = QuestionViewModel()
    var pickerViewCoordinator = QuestionPickerViewCoordinator()
    var activeTextField = UITextField()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardHandling()
        setupDelegate()
        setupUI()
        prePopulateEntry()
        if viewModel.type == .maritalStatus {
            setupPicker()
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
        searchTextField.delegate = self
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.sectionTitle.font = AppConfig.shared.activeTheme.defaultFont
        self.sectionTitle.text = self.viewModel.sectionTitle
        self.hideBackTitle()
        self.showNormalTextFields()
        self.populatePlaceHolderNormalTextField()
        self.questionTitle.font = AppConfig.shared.activeTheme.headerFont
        self.questionTitle.text = self.viewModel.question()
        // special case for address look up
        switch self.viewModel.type {
        case  .residentialAddress:
        self.setupResidentialAddressLookup()
        case .companyName:
        self.setupEmployerNameLookup()
        case .companyAddress:
        self.setupEmployerAddressLookup()
        default: break
        }
        
        AppConfig.shared.progressNavBar(progress: AppData.shared.progress, viewController: self)
    }
    
    func prePopulateEntry() {
        viewModel.loadSaved()
        switch viewModel.type {
        case .legalName:
            self.textField1.text = viewModel.fieldValue(QuestionField.firstname)
            self.textField2.text = viewModel.fieldValue(QuestionField.lastname)   
        case .dateOfBirth:
            self.textField1.text = viewModel.fieldValue(QuestionField.dateOfBirth)
        case .contactDetails:
            self.textField1.text = viewModel.fieldValue(QuestionField.contactDetails)
        case .residentialAddress:
            self.searchTextField.text = viewModel.fieldValue(QuestionField.residentialAddress)
        case .companyName:
            self.searchTextField.text = viewModel.fieldValue(QuestionField.employerName)
        case .companyAddress:
            self.searchTextField.text = viewModel.fieldValue(QuestionField.employerAddress)
        case .maritalStatus:
            self.textField1.text = viewModel.fieldValue(QuestionField.maritalStatus)
            self.textField2.text = viewModel.fieldValue(QuestionField.dependents)
        }
    }

    @IBAction func next(_ sender: Any) {
        validateInput()
        switch self.viewModel.type {
        case .legalName:
            self.viewModel.save(QuestionField.firstname.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.lastname.rawValue, value: textField2.text ?? "")
            AppData.shared.updateProgressAfterCompleting(.legalName)
            AppNav.shared.pushToMultipleChoice(.ageRange, viewController: self)
        case .dateOfBirth:
            self.viewModel.save(QuestionField.dateOfBirth.rawValue, value: textField1.text ?? "")
            AppData.shared.updateProgressAfterCompleting(.dateOfBirth)
            AppNav.shared.pushToQuestionForm(.contactDetails, viewController: self)
        case .contactDetails:
            self.viewModel.save(QuestionField.contactDetails.rawValue, value: textField1.text ?? "")
            AppData.shared.updateProgressAfterCompleting(.contactDetails)
            AppNav.shared.pushToMultipleChoice(.state, viewController: self)
        case .residentialAddress:
            self.viewModel.save(QuestionField.residentialAddress.rawValue, value: textField1.text ?? "")
            AppConfig.shared.showSpinner()
            if AppData.shared.residentialAddressList.count > 0 {
                let address = AppData.shared.residentialAddressList[AppData.shared.selectedResidentialAddress]
                self.saveResidentialAddress(address)
            }
            
            let putUserDetailsReq = self.viewModel.putUserDetailsRequest()
            CheqAPIManager.shared.putUserDetails(putUserDetailsReq).ensure {
                 AppConfig.shared.hideSpinner()
            }.done { authUser in
                AppData.shared.updateProgressAfterCompleting(.residentialAddress)
                AppNav.shared.pushToIntroduction(.employee, viewController: self)
            }.catch { err in
                self.showError(CheqAPIManagerError.errorHasOccurredOnServer) {
                    LoggingUtil.shared.cPrint(err.localizedDescription)
                }
                return
            }
            break
        case .companyName:
            if AppData.shared.employerList.count > 0 {
                let employer = AppData.shared.employerList[AppData.shared.selectedEmployer]
                self.viewModel.save(QuestionField.employerAddress.rawValue, value: employer.address ?? "")
            }
            self.viewModel.save(QuestionField.employerName.rawValue, value: searchTextField.text ?? "")
            AppData.shared.updateProgressAfterCompleting(.companyName)
            AppNav.shared.pushToQuestionForm(.companyAddress, viewController: self)
        case .companyAddress:
            self.viewModel.save(QuestionField.employerAddress.rawValue, value: searchTextField.text ?? "")
            LoggingUtil.shared.cPrint("Go to some other UI component here")
            AppData.shared.updateProgressAfterCompleting(.companyAddress)
            AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
        case .maritalStatus:
            self.viewModel.save(QuestionField.maritalStatus.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.dependents.rawValue, value: textField2.text ?? "")
             let putUserDetailsReq = self.viewModel.putUserDetailsRequest()
            AppConfig.shared.showSpinner()
            CheqAPIManager.shared.putUserDetails(putUserDetailsReq).done { authUser in
                AppConfig.shared.hideSpinner()
                AppData.shared.updateProgressAfterCompleting(.maritalStatus)
                AppNav.shared.pushToIntroduction(.employee, viewController: self)
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(CheqAPIManagerError.errorHasOccurredOnServer) { }
                }
            }
            return
        }
    }
}

//MARK: Input validations
extension QuestionViewController {
    
    func saveResidentialAddress(_ address: GetAddressResponse) {
        self.viewModel.save(QuestionField.residentialAddress.rawValue, value: address.address ?? "")
        self.viewModel.save(QuestionField.residentialPostcode.rawValue, value: address.postCode ?? "")
        self.viewModel.save(QuestionField.residentialState.rawValue, value: address.state ?? "")
        self.viewModel.save(QuestionField.residentialCountry.rawValue, value: address.country ?? "")
    }
    
    func saveEmployerAddress(_ address: GetEmployerPlaceResponse) {
        self.viewModel.save(QuestionField.employerAddress.rawValue, value: address.address ?? "")
        self.viewModel.save(QuestionField.employerPostcode.rawValue, value: address.postCode ?? "")
        self.viewModel.save(QuestionField.employerLatitude.rawValue, value: String(address.latitude ?? 0))
        self.viewModel.save(QuestionField.employerLongitude.rawValue, value: String(address.longitude ?? 0))
    }
    
    func validateInput() {
        
        if self.viewModel.numOfTextFields() == 2, hasEmptyFields([self.textField1, self.textField2])  {
            showError(ValidationError.allFieldsMustBeFilled) { return }
        }
        
        if self.searchTextField.isHidden, self.viewModel.numOfTextFields() == 1, hasEmptyFields([self.textField1]) {
            showError(ValidationError.allFieldsMustBeFilled) { return }
        }
        
        if self.searchTextField.isHidden == false, self.viewModel.numOfTextFields() == 1, hasEmptyFields([self.searchTextField]) {
            showError(ValidationError.allFieldsMustBeFilled) { return }
        }
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
        if self.viewModel.numOfTextFields() == 2 {
            textField1.placeholder = self.viewModel.placeHolder(0)
            textField2.placeholder = self.viewModel.placeHolder(1)
        } else {
            textField1.placeholder = self.viewModel.placeHolder(0)
        }
    }
    
    func showNormalTextFields() {
        if self.viewModel.numOfTextFields() == 2 {
            textField1.isHidden = false
            textField2.isHidden = false
            searchTextField.isHidden = true
        } else {
            textField1.isHidden = false
            textField2.isHidden = true
            searchTextField.isHidden = true
        }
    }
    
    func hideNormalTextFields() {
        textField1.isHidden = true
        textField2.isHidden = true
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
    
        switch self.viewModel.type {
        
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
        searchTextField.placeholder = self.viewModel.placeHolder(0)
        searchTextField.itemSelectionHandler  = { item, itemPosition  in
            AppData.shared.selectedEmployer = itemPosition
            self.searchTextField.text = item[itemPosition].title
        }
        searchTextField.userStoppedTypingHandler = {
            if let query = self.searchTextField.text, query.count > self.searchTextField.minCharactersNumberToStartFiltering {
                CheqAPIManager.shared.employerAddressLookup(query).done { addressList in
                    AppData.shared.employerList = addressList
                    self.searchTextField.filterStrings(addressList.map{ $0.name ?? "" })
                    }.catch {err in
                        LoggingUtil.shared.cPrint(err)
                }
            }
        }
    }
    
    func setupEmployerAddressLookup() {
        self.hideNormalTextFields()
        searchTextField.placeholder = self.viewModel.placeHolder(0)
        searchTextField.userStoppedTypingHandler = {
            if let query = self.searchTextField.text, query.count > self.searchTextField.minCharactersNumberToStartFiltering {
                CheqAPIManager.shared.employerAddressLookup(query).done { addressList in
                    self.searchTextField.filterStrings(addressList.map{ $0.address ?? "" })
                    }.catch {err in
                        LoggingUtil.shared.cPrint(err)
                }
            }
        }
    }
    
    func setupResidentialAddressLookup() {
        self.hideNormalTextFields()
        searchTextField.placeholder = self.viewModel.placeHolder(0)
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
