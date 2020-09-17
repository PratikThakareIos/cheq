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
//import CoreLocation
import SearchTextField

//self.nextButton.showLoadingOnButton(self)
//self.nextButton.hideLoadingOnButton(self)

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var ImageViewContainer: UIView!
    @IBOutlet weak var sectionTitle: UILabel!
    @IBOutlet weak var lblContactInfo: UILabel! //We use this for verification and security texts
    @IBOutlet weak var questionTitle: CLabel!
    @IBOutlet weak var questionDescription: UILabel!
    
    @IBOutlet weak var nextButton: CNButton!
    
    private var textFields: [CNTextField] {
        [textField1, textField2, textField3, textField4, textField5, textField6, textField7, textField8]
    }
    @IBOutlet weak var segmentedControl: CSegmentedControl!

    @IBOutlet weak var textField1: CNTextField!
    @IBOutlet weak var textField2: CNTextField!
    @IBOutlet weak var textField3: CNTextField!
    @IBOutlet weak var textField4: CNTextField!
    @IBOutlet weak var textField5: CNTextField!
    @IBOutlet weak var textField6: CNTextField!
    @IBOutlet weak var textField7: CNTextField!
    @IBOutlet weak var textField8: CNTextField!

    @IBOutlet weak var hintImageView: UIImageView!
   
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
    var choices:[ChoiceModel] = []
    var selectedStateName : String = ""
    var validityForMedicareCard : String = ""
    
    var statePickerView = UIPickerView()
    let userDefault = UserDefaults.standard
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activeTimestamp()
        //setupKeyboardHandling()
        self.updateKeyboardViews()
        
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
        if viewModel.coordinator.type == .maritalStatus {
            setupMaritalStatusPicker()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
        self.setupLookupIfNeeded()
        
        if (self.viewModel.coordinator.type == .companyName || self.viewModel.coordinator.type == .companyAddress){
            self.getTransactionData()
        }
    }
    
    private func getTransactionData() {
        if AppData.shared.employeePaycycle.count == 0 {
            AppConfig.shared.showSpinner()
            CheqAPIManager.shared.getSalaryPayCycleTimeSheets()
                .done{ paycyles in
                    AppConfig.shared.hideSpinner {
                        LoggingUtil.shared.cPrint("Transaction success")
                    }
            }.catch { err in
                LoggingUtil.shared.cPrint(err)
                AppConfig.shared.hideSpinner {
                    //                    self.showError(err) {
                    //                         LoggingUtil.shared.cPrint("error")
                    //                    }
                }
            }
        }else {
            LoggingUtil.shared.cPrint(AppData.shared.employeeOverview?.eligibleRequirement!.hasPayCycle)
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
    
    func setupMaritalStatusPicker() {
        
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
    
    func setupMedicalCardValidPicker(cardColor: MedicareCardColorItem.CardColor, textField: UITextField) {
        switch cardColor.dateFormat {
        case .dayMonthYear:
            textField.inputView = nil
        case .monthYear:
            let pickerView = MonthYearPickerView()
            pickerView.onDateSelected = { month, year in
                textField.text = String(format: "%02d/%d", month, year)
            }
            textField.inputView = pickerView
        }
        textField.text = ""
        self.view.endEditing(true)
    }
    
    func setupDelegate() {
        textFields.forEach {
            $0.delegate = self
        }
        searchTextField.delegate = self
    }
    
    // change the button title
    func changeButtonTitle(){
        nextButton.setTitle("Confirm",for: .normal)
        let qvm = QuestionViewModel()
        qvm.loadSaved()
        let firstname = qvm.fieldValue(.firstname)
        let lastname = qvm.fieldValue(.lastname)
        //textField1.text = firstname
        //textField2.text = lastname
    }
    
    func setupUI() {
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        //self.sectionTitle.font = AppConfig.shared.activeTheme.defaultFont
        
        let coordinatorType = self.viewModel.coordinator.type
        if AppData.shared.completingDetailsForLending && (coordinatorType == .legalName ||  coordinatorType == .residentialAddress ||  coordinatorType == .dateOfBirth ) {
            self.sectionTitle.text = Section.verifyMyIdentity.rawValue
        }else{
            self.sectionTitle.text = self.viewModel.coordinator.sectionTitle
        }
                
        self.questionDescription.isHidden = true
        self.nextButton.createShadowLayer()
        self.hideBackTitle()
        self.showNormalTextFields()
        self.showCheckbox()
        self.populatePlaceHolderNormalTextField()
        self.prePopulateEntry()
        self.questionTitle.font = AppConfig.shared.activeTheme.headerBoldFont
        self.questionTitle.text = self.viewModel.question()
        self.hintImageView.image = self.viewModel.hintImage
        self.hintImageView.isHidden = self.hintImageView.image == nil
        
        if let controlConfig = self.viewModel.coordinator.segmentedControlConfig() {
            self.viewModel.save(QuestionField.color.rawValue, value:"Green")
            self.segmentedControl.configure(with: controlConfig)
            self.segmentedControl.addTarget(self, action: #selector(onSegmentedControlChanged(_:)), for: .valueChanged)
        } else {
            self.segmentedControl.isHidden = true
        }
        
        // special case for address look up
        switch self.viewModel.coordinator.type {
        case .residentialAddress:
            self.setupResidentialAddressLookup()
                        
        case .companyName:
            self.setupEmployerNameLookup()
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_addy.rawValue, FirebaseEventKey.lend_KYC_addy.rawValue, FirebaseEventContentType.screen.rawValue)
            
        case .companyAddress:
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Onboarding.rawValue, FirebaseEventKey.on_signup_bank_connect.rawValue, FirebaseEventKey.on_signup_bank_connect.rawValue, FirebaseEventContentType.screen.rawValue)
            //  AppConfig.shared.addEventToFirebase("", "", "", FirebaseEventContentType.screen.rawValue)
            self.setupEmployerAddressLookup()
            
        case .bankAccount:
            self.changeButtonTitle()
            //self.showImageContainer()
            self.questionDescription.text = "Please ensure that this account matches the account you entered in the Cheq app"
            self.questionDescription.isHidden = false
            self.ImageViewContainer.isHidden = true
            
        case .verifyName:
            self.hideImageContainer()
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_name.rawValue, FirebaseEventKey.lend_KYC_name.rawValue, FirebaseEventContentType.screen.rawValue)
            
        case .legalName:
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Onboarding.rawValue, FirebaseEventKey.on_signup_name.rawValue,  FirebaseEventKey.on_signup_name.rawValue, FirebaseEventContentType.screen.rawValue)
            
            self.legalNameAutoFill()
            
        case .medicare:
            if (self.textField3.text ?? "").isEmpty {
                self.setupMedicalCardValidPicker(cardColor: .green, textField: self.textField3)
            }

        default: break
        }
        
        self.lblContactInfo.isHidden = true
        if viewModel.coordinator.type == .contactDetails {
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Onboarding.rawValue, FirebaseEventKey.on_signup_mobile.rawValue, FirebaseEventKey.on_signup_mobile.rawValue, FirebaseEventContentType.screen.rawValue)
            self.lblContactInfo.isHidden = false
            self.textField1.keyboardType = .phonePad
        }
        
        switch viewModel.coordinator.type {
        case .legalName:
            let firstname = viewModel.fieldValue(.firstname)
            if firstname.isEmpty {
                hideBackButton() //is from registration then hide back button
            } else {
                showCloseButton()
            }
        
        case .bankAccount:
            showCloseButton()
            self.textField3.keyboardType = .numberPad
            self.textField4.keyboardType = .numberPad
        
        case .companyName, .companyAddress, .residentialAddress, .verifyName, .passport, .medicare:
            showNavBar()
            showBackButton()

        default:
            break
        }

        if AppData.shared.completingDetailsForLending {
            AppConfig.shared.removeProgressNavBar(self)
        }
        
        statePickerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 250, width: UIScreen.main.bounds.width, height: 250)
        statePickerView.dataSource = self
        statePickerView.delegate = self
        statePickerView.isHidden = true
        self.view.addSubview(statePickerView)
    }
    
    func updateKeyboardViews() {
        
        //include ' symbol to Regular Expressions
        //https://stackoverflow.com/questions/46162500/i-cant-include-symbol-to-regular-expressions
        self.textFields.forEach {
            $0.smartQuotesType = .no
        }
        
        self.textField1.reloadInputViews()
        self.textField2.reloadInputViews()
        self.searchTextField.reloadInputViews()
    }
    
    func prePopulateEntry() {
        let stateVm = QuestionViewModel()
        stateVm.coordinator = FrankieKycAddressCoordinator()
        stateVm.loadSaved()
        StateCoordinator().choices().done { (models) in
            self.choices = models
        }
        self.textField1.resignFirstResponder()
        viewModel.loadSaved()
        self.view.endEditing(true)
        switch viewModel.coordinator.type {
        case .driverLicense:
            
            if let state = userDefault.value(forKey: QuestionField.driverLicenceState.rawValue) as? String,let number = userDefault.value(forKey: QuestionField.driverLicenceNumber.rawValue) as? String{
                let savedState = CountryState(raw: state)
                self.textField1.text = savedState.name
                self.textField2.text = number
                self.textField1.inputView = statePickerView
                self.textField1.isUserInteractionEnabled = true
                self.textField1.backgroundColor = .white
            }else{
                let stateVm = MultipleChoiceViewModel()
                stateVm.coordinator = StateCoordinator()
                stateVm.load()
                let savedState = CountryState(raw: stateVm.savedAnswer[QuestionField.driverLicenceState.rawValue])
                self.textField1.text = savedState.name
            }
            
        case .passport:
            if let number = userDefault.value(forKey: QuestionField.passportNumber.rawValue) as? String{
                self.textField1.text = number
            }
            
        case .medicare:
            if let number = userDefault.value(forKey: QuestionField.medicareNumber.rawValue) as? String,let position = userDefault.value(forKey: QuestionField.medicarePosition.rawValue) as? String,let year = userDefault.value(forKey: QuestionField.medicareValidToYear.rawValue) as? Int,let color = userDefault.value(forKey: QuestionField.color.rawValue) as? String{
                self.textField1.text = number
                self.textField2.text = position
                self.viewModel.save(QuestionField.color.rawValue, value:color)
                switch color {
                case "Green":
                    validityForMedicareCard = "\(year)-\(userDefault.value(forKey: QuestionField.medicareValidToMonth.rawValue) as? Int ?? 0)"
                    self.textField3.text = validityForMedicareCard
                    self.segmentedControl.selectedItemIndex = 0
                    self.segmentedControl.sendActions(for: UIControl.Event.valueChanged)
                case "Yellow":
                    validityForMedicareCard = "\(year)-\(userDefault.value(forKey: QuestionField.medicareValidToMonth.rawValue) as? Int ?? 0)-\(userDefault.value(forKey: QuestionField.medicareValidToDay.rawValue) as? Int ?? 0)"
                    self.textField3.text = validityForMedicareCard
                    self.segmentedControl.selectedItemIndex = 1
                    self.segmentedControl.sendActions(for: UIControl.Event.valueChanged)
                case "Blue":
                    validityForMedicareCard = "\(year)-\(userDefault.value(forKey: QuestionField.medicareValidToMonth.rawValue) as? Int ?? 0)-\(userDefault.value(forKey: QuestionField.medicareValidToDay.rawValue) as? Int ?? 0)"
                    self.textField3.text = validityForMedicareCard
                    self.segmentedControl.selectedItemIndex = 2
                    self.segmentedControl.sendActions(for: UIControl.Event.valueChanged)
                default: break
                }
                
            }
        case .driverLicenseName,.passportName,.medicareName:
            if  let name = userDefault.value(forKey: QuestionField.firstname.rawValue) as? String,let lastName = userDefault.value(forKey: QuestionField.lastname.rawValue) as? String,let surname = userDefault.value(forKey: QuestionField.surname.rawValue) as? String{
                self.textField1.text = name
                self.textField2.text = lastName
                self.textField3.text = surname
            }
            
        case .dateOfBirth:
            if let dob = userDefault.value(forKey: QuestionField.dateOfBirth.rawValue) as? String{
                self.textField1.text = dob
            }
        case .frankieKycAddress:
        
            if let unitNumber = userDefault.value(forKey: QuestionField.kycResidentialUnitNumber.rawValue) as? String{
                self.textField1.text = unitNumber
            }
            if let streetNumber = userDefault.value(forKey: QuestionField.kycResidentialStreetNumber.rawValue) as? String{
                self.textField2.text = streetNumber
            }
            if let streetName = userDefault.value(forKey: QuestionField.kycResidentialStreetName.rawValue) as? String{
                self.textField3.text = streetName
            }
            if let suburb = userDefault.value(forKey: QuestionField.kycResidentialSuburb.rawValue) as? String{
                self.textField4.text = suburb
            }
            if let state = userDefault.value(forKey: QuestionField.kycResidentialState.rawValue) as? String{
                self.textField5.text = state
            }
            if let postcode = userDefault.value(forKey: QuestionField.kycResidentialPostcode.rawValue) as? String{
                self.textField6.text = postcode
            }
            
            self.textField7.text = "Australia"//stateVm.savedAnswer[QuestionField.kycResidentialCountry.rawValue]

        default: break
        }
    }
    
    func populatePopup_BankDetailsAlreadyInUse(){
        
        self.openPopupWith(heading: "Bank details already in use",
                           message: "We have detected these bank details have been used by another user. Please ensure these details belong to you",
                           buttonTitle: "",
                           showSendButton: false,
                           emoji: UIImage(named: "transferFailed"))
    }
    
    func populatePopup_InvalidBSB(){
        self.openPopupWith(heading: "Something went wrong",
                           message: "Invalid bsb and account number",
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
        
        textFields.forEach {
            $0.text = $0.text?.trim()
        }

        searchTextField.text = searchTextField.text?.trim()
        
        if let error = self.validateInput() {
            
            //            if (self.viewModel.coordinator.type == .dateOfBirth || error.localizedDescription == ValidationError.dobIsMandatory.localizedDescription) {
            //                self.openPopupWith(heading: error.localizedDescription,
            //                              message:"",
            //                              buttonTitle: "",
            //                              showSendButton: false,
            //                              emoji: UIImage.init(named:"image-moreInfo"))
            //            }else{
            //              showError(error, completion: nil)
            //            }
            
            self.openPopupWith(
                heading: error.localizedDescription,
                message:"",
                buttonTitle: "",
                showSendButton: false,
                emoji: UIImage.init(named:"image-moreInfo"))
            
            return
        }
        
        switch self.viewModel.coordinator.type {
        case .legalName:
            
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Onboarding.rawValue, FirebaseEventKey.on_signup_name_click.rawValue, FirebaseEventKey.on_signup_name_click.rawValue,FirebaseEventContentType.button.rawValue)
            self.viewModel.save(QuestionField.firstname.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.lastname.rawValue, value: textField2.text ?? "")
            
            //This will hit only in the lending flow
            if AppData.shared.completingDetailsForLending {
                AppNav.shared.pushToQuestionForm(.residentialAddress, viewController: self)
                return
            }else{
                AppData.shared.updateProgressAfterCompleting(.legalName)
                AppNav.shared.pushToQuestionForm(.contactDetails, viewController: self)
            }
            
        //manish
        case .dateOfBirth:
            
            self.viewModel.save(QuestionField.dateOfBirth.rawValue, value: textField1.text ?? "")
            
            if AppData.shared.selectedKycDocType != nil {
                let request = DataHelperUtil.shared.retrieveUserNameDetailsKYCReq()
                self.nextButton.showLoadingOnButton(self)
                
                CheqAPIManager.shared.postUserNameDetailsFrankieKYC(request: request).done { (success) in
                    self.nextButton.hideLoadingOnButton(self)
                    if success{
                        AppNav.shared.pushToQuestionForm(.frankieKycAddress, viewController: self)
                    }
                }.catch { err in
                    self.nextButton.hideLoadingOnButton(self)
                    AppConfig.shared.hideSpinner {
                        LoggingUtil.shared.cPrint(err.code())
                        LoggingUtil.shared.cPrint(err.localizedDescription)
                        self.showError(err) { }
                    }
                }
                return
            }
            
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
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Onboarding.rawValue, FirebaseEventKey.on_signup_mobile_click.rawValue, FirebaseEventKey.on_signup_mobile_click.rawValue, FirebaseEventContentType.button.rawValue)
            self.view.endEditing(true)
            self.viewModel.save(QuestionField.contactDetails.rawValue, value: textField1.text ?? "")
            AppData.shared.updateProgressAfterCompleting(.contactDetails)
            let qVm = QuestionViewModel()
            qVm.loadSaved()
            let putUserDetailsReq = qVm.putUserDetailsRequest()
            
            //AppConfig.shared.showSpinner()
            self.nextButton.showLoadingOnButton(self)
            
            AuthConfig.shared.activeManager.getCurrentUser().then { authUser in
                return CheqAPIManager.shared.putUser(authUser)
            }.then { authUser in
                AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
            }.then { authUser in
                return CheqAPIManager.shared.putUserDetails(putUserDetailsReq)
            }.then { authUser in
                AuthConfig.shared.activeManager.setUser(authUser)
            }.then { authUser ->Promise<Bool> in
                let req = DataHelperUtil.shared.postPushNotificationRequest()
                return CheqAPIManager.shared.postNotificationToken(req)
            }.done { success in
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    AppData.shared.updateProgressAfterCompleting(.contactDetails)
                    //AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                    AppNav.shared.pushToSetupBank(.setupBank, viewController: self)
                }
            }.catch { err in
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    LoggingUtil.shared.cPrint(err)
                    LoggingUtil.shared.cPrint(err.localizedDescription)
                    self.showError(CheqAPIManagerError.errorHasOccurredOnServer) {
                    }
                }
            }
            
        case .companyName:
            
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_name_click.rawValue, FirebaseEventKey.lend_KYC_name_click.rawValue, FirebaseEventContentType.button.rawValue)
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
                
                
                //AppConfig.shared.showSpinner()
                self.nextButton.showLoadingOnButton(self)
                
                LoggingUtil.shared.cPrint(req.address)
                CheqAPIManager.shared.putUserEmployer(req).done { authUser in
                    
                    self.nextButton.hideLoadingOnButton(self)
                    AppConfig.shared.hideSpinner {
                        self.incomeVerification()
                    }
                }.catch { err in
                    
                    self.nextButton.hideLoadingOnButton(self)
                    AppConfig.shared.hideSpinner {
                        LoggingUtil.shared.cPrint(err.code())
                        LoggingUtil.shared.cPrint(err.localizedDescription)
                        self.showError(err) { }
                    }
                }
                
                //Other option selcted
                if (isIncomeDetected()){
                    LoggingUtil.shared.cPrint("Update time sheet")
                }
                
            } else {
                
                AppNav.shared.pushToQuestionForm(.companyAddress, viewController: self)
            }
        case .companyAddress:
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_addy_click.rawValue, FirebaseEventKey.lend_KYC_addy_click.rawValue, FirebaseEventContentType.button.rawValue)
            if let err = self.validateCompanyAddressLookup() {
                showError(err, completion: nil)
                return
            }
            self.viewModel.save(QuestionField.employerAddress.rawValue, value: searchTextField.text ?? "")
            LoggingUtil.shared.cPrint("Go to some other UI component here")
            AppData.shared.updateProgressAfterCompleting(.companyAddress)
            
            //AppConfig.shared.showSpinner()
            self.nextButton.showLoadingOnButton(self)
            
            let employerAddress = AppData.shared.employerAddressList[AppData.shared.selectedEmployerAddress]
            saveEmployerAddress(employerAddress)
            let req = DataHelperUtil.shared.putUserEmployerRequest()
            
            //Company addresss from a fix location
            CheqAPIManager.shared.putUserEmployer(req).done { authUser in
                
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    if AppData.shared.completingDetailsForLending {
                        //AppData.shared.completingDetailsForLending = false
                        //self.delegate?.refreshLendingScreen()
                        self.incomeVerification()
                    } else {
                        // AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
                        // AppNav.shared.pushToSetupBank(.setupBank, viewController: self)
                    }
                }
            }.catch { err in
                
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    LoggingUtil.shared.cPrint(err.code())
                    LoggingUtil.shared.cPrint(err.localizedDescription)
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
                AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_bank_toggle.rawValue, FirebaseEventKey.lend_bank_toggle.rawValue, FirebaseEventContentType.button.rawValue)
                
                return
            }
            LoggingUtil.shared.cPrint("bank account next")
            self.viewModel.save(QuestionField.firstname.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.lastname.rawValue, value: textField2.text ?? "")
            self.viewModel.save(QuestionField.bankBSB.rawValue, value: textField3.text ?? "")
            self.viewModel.save(QuestionField.bankAccNo.rawValue, value: textField4.text ?? "")
            // enter other values
            self.viewModel.save(QuestionField.bankIsJoint.rawValue, value: String(switchWithLabel.switchValue()))
            
            //AppConfig.shared.showSpinner()
            self.nextButton.showLoadingOnButton(self)
            
            CheqAPIManager.shared.updateDirectDebitBankAccount().done { res in
                
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
                    AppNav.shared.dismissModal(self)
                    
                }
            }.catch { err in
                
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    LoggingUtil.shared.cPrint(err)
                    
                    //self.populatePopup_BankDetailsAlreadyInUse()
                    self.populatePopup_InvalidBSB()
                    
                    //                    let transactionModal: CustomSubViewPopup = UIView.fromNib()
                    //                    transactionModal.viewModel.data = CustomPopupModel(description: "We have detected these bank details have been used by another user. Please ensure these detailsbelong to you", imageName: "", modalHeight: 300, headerTitle: "Bank details already in use")
                    //                    transactionModal.setupUI()
                    //                    let popupView = CPopupView(transactionModal)
                    //                    popupView.show()
                    //                    self.showError(err, completion: nil)
                    
                }
            }
            
            
        case .verifyName:
            AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_name_click.rawValue, FirebaseEventKey.lend_KYC_name_click.rawValue, FirebaseEventContentType.button.rawValue)
            self.viewModel.save(QuestionField.firstname.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.lastname.rawValue, value: textField2.text ?? "")
            AppNav.shared.pushToQuestionForm(.residentialAddress, viewController: self)
            
        case .residentialAddress:
            
            if let err = self.validateResidentialAddressLookup() {
                showError(err, completion: nil)
                return
            }
            
            self.viewModel.save(QuestionField.unitNumber.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.residentialAddress.rawValue, value: searchTextField.text ?? "")
            
            if AppData.shared.residentialAddressList.count > 0 {
                let address = AppData.shared.residentialAddressList[AppData.shared.selectedResidentialAddress]
                self.saveResidentialAddress(address)
            }
            
            guard AppData.shared.completingDetailsForLending == false else {
                AppNav.shared.pushToQuestionForm(.dateOfBirth, viewController: self)
                return
            }
            
            //AppConfig.shared.showSpinner()
            self.nextButton.showLoadingOnButton(self)
            
            let putUserDetailsReq = self.viewModel.putUserDetailsRequest()
            CheqAPIManager.shared.putUserDetails(putUserDetailsReq).done { authUser in
                
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    AppData.shared.updateProgressAfterCompleting(.residentialAddress)
                    AppNav.shared.pushToIntroduction(.employee, viewController: self)
                }
            }.catch { err in
                
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    self.showError(CheqAPIManagerError.errorHasOccurredOnServer) {
                        LoggingUtil.shared.cPrint(err.localizedDescription)
                    }
                }
                return
            }
            break
                        
        case .driverLicense:
            self.viewModel.save(QuestionField.driverLicenceNumber.rawValue, value: textField2.text ?? "")
            let request = DataHelperUtil.shared.retrieveUserDocumentDetailsKycReq()
            self.nextButton.showLoadingOnButton(self)
            
            CheqAPIManager.shared.postUserDocumentDetailsFrankieKYC(request: request).done { (success) in
                self.nextButton.hideLoadingOnButton(self)
                if success{
                    AppNav.shared.pushToQuestionForm(.driverLicenseName, viewController: self)
                }
            }.catch { err in
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    LoggingUtil.shared.cPrint(err.code())
                    LoggingUtil.shared.cPrint(err.localizedDescription)
                    self.showError(err) { }
                }
            }

        case .driverLicenseName:
            self.viewModel.save(QuestionField.firstname.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.lastname.rawValue, value: textField2.text ?? "")
            self.viewModel.save(QuestionField.surname.rawValue, value: textField3.text ?? "")
            AppNav.shared.pushToQuestionForm(.dateOfBirth, viewController: self)

        case .passport:
            self.viewModel.save(QuestionField.passportNumber.rawValue, value: textField1.text ?? "")
            
            let request = DataHelperUtil.shared.retrieveUserDocumentDetailsKycReq()
            self.nextButton.showLoadingOnButton(self)
            CheqAPIManager.shared.postUserDocumentDetailsFrankieKYC(request: request).done { (success) in
                self.nextButton.hideLoadingOnButton(self)
                if success{
                    AppNav.shared.pushToQuestionForm(.passportName, viewController: self)
                }
            }.catch { err in
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    LoggingUtil.shared.cPrint(err.code())
                    LoggingUtil.shared.cPrint(err.localizedDescription)
                    self.showError(err) { }
                }
            }

        case .passportName:
            self.viewModel.save(QuestionField.firstname.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.lastname.rawValue, value: textField2.text ?? "")
            self.viewModel.save(QuestionField.surname.rawValue, value: textField3.text ?? "")
            AppNav.shared.pushToQuestionForm(.dateOfBirth, viewController: self)

        case .medicare:
            self.viewModel.save(QuestionField.medicareNumber.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.medicarePosition.rawValue, value: textField2.text ?? "")
            self.viewModel.save(QuestionField.medicareValidTo.rawValue, value: textField3.text ?? "")
            self.getDayMonthYearFromDate(date: textField3.text ?? "")
            
            let request = DataHelperUtil.shared.retrieveUserDocumentDetailsKycReq()
            self.nextButton.showLoadingOnButton(self)
            CheqAPIManager.shared.postUserDocumentDetailsFrankieKYC(request: request).done { (success) in
                self.nextButton.hideLoadingOnButton(self)
                if success{
                    AppNav.shared.pushToQuestionForm(.medicareName, viewController: self)
                }
            }.catch { err in
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    LoggingUtil.shared.cPrint(err.code())
                    LoggingUtil.shared.cPrint(err.localizedDescription)
                    self.showError(err) { }
                }
            }

        case .medicareName:
            self.viewModel.save(QuestionField.firstname.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.lastname.rawValue, value: textField2.text ?? "")
            self.viewModel.save(QuestionField.surname.rawValue, value: textField3.text ?? "")
            AppNav.shared.pushToQuestionForm(.dateOfBirth, viewController: self)

        case .frankieKycAddress:
            self.viewModel.save(QuestionField.kycResidentialUnitNumber.rawValue, value: textField1.text ?? "")
            self.viewModel.save(QuestionField.kycResidentialStreetNumber.rawValue, value: textField2.text ?? "")
            self.viewModel.save(QuestionField.kycResidentialStreetName.rawValue, value: textField3.text ?? "")

//            self.viewModel.save(QuestionField.kycResidentialStreetType.rawValue, value: textField4.text ?? "")
            self.viewModel.save(QuestionField.kycResidentialSuburb.rawValue, value: textField4.text ?? "")
            self.viewModel.save(QuestionField.kycResidentialState.rawValue, value: self.selectedStateName)
            self.viewModel.save(QuestionField.kycResidentialPostcode.rawValue, value: textField6.text ?? "")
            self.viewModel.save(QuestionField.kycResidentialCountry.rawValue, value: textField7.text ?? "")
            
            let request = DataHelperUtil.shared.retrieveUserAddressDetailsKYCReq()
            self.nextButton.showLoadingOnButton(self)
            
            CheqAPIManager.shared.postUserAddressDetailsFrankieKYC(request: request).done { (success) in
                self.nextButton.hideLoadingOnButton(self)
                if success{
                    AppNav.shared.pushUserVerificationDetailsView(viewController: self)
                }
            }.catch { err in
                self.nextButton.hideLoadingOnButton(self)
                AppConfig.shared.hideSpinner {
                    LoggingUtil.shared.cPrint(err.code())
                    LoggingUtil.shared.cPrint(err.localizedDescription)
                    self.showError(err) { }
                }
            }
        }
    }
    
    func getDayMonthYearFromDate(date: String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: date) else { return }
        let calanderDate = Calendar.current.dateComponents([.day, .year, .month], from: date)
        self.viewModel.save(QuestionField.medicareValidToDay.rawValue, value: "\(calanderDate.day ?? 0)")
        self.viewModel.save(QuestionField.medicareValidToMonth.rawValue, value: "\(calanderDate.month ?? 0)")
        self.viewModel.save(QuestionField.medicareValidToYear.rawValue, value: "\(calanderDate.year ?? 0)")
    }
    
    func showTransactions() {
        guard let nav = self.navigationController else { return }
        let storyboard = UIStoryboard(name: StoryboardName.onboarding.rawValue, bundle: Bundle.main)
        let vc: SalaryPaymentViewController = storyboard.instantiateViewController(withIdentifier: OnboardingStoryboardId.salaryPayments.rawValue) as! SalaryPaymentViewController
        nav.pushViewController(vc, animated: true)
    }
    
    func incomeVerification(){
        
        let hasPayCycle : Bool = AppData.shared.employeeOverview?.eligibleRequirement!.hasPayCycle ?? false
        
        LoggingUtil.shared.cPrint("hasPayCycle = \(hasPayCycle), Paycycle.count = \(AppData.shared.employeePaycycle.count)" )
        
        if !hasPayCycle && AppData.shared.employeePaycycle.count > 0 {
            showTransactions()
        }else if !(hasPayCycle) && AppData.shared.employeePaycycle.count == 0 {
            // show popup but for now navigate to lending page
            AppData.shared.completingDetailsForLending = false
            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
            AppNav.shared.dismissModal(self){}
        }else {
            //self.delegate?.refreshLendingScreen()
            AppData.shared.completingDetailsForLending = false
            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
            AppNav.shared.dismissModal(self){}
        }
    }
    
    @objc func onSegmentedControlChanged(_ sender: CSegmentedControl) {
        switch self.viewModel.coordinator.type {
        case .medicare:
            
            self.viewModel.save(QuestionField.color.rawValue, value: sender.selectedItem?.title ?? "")
            self.viewModel.coordinator.onSegmentedControlChange(to: sender.selectedItem)
            self.hintImageView.image = self.viewModel.hintImage
            self.hintImageView.isHidden = self.hintImageView.image == nil
//            self.textField3.text = ""
            if let c = sender.selectedItem as? MedicareCardColorItem {
                setupMedicalCardValidPicker(cardColor: c.color, textField: self.textField3)
            }
            
            if let color = userDefault.value(forKey: QuestionField.color.rawValue) as? String{
                if color == sender.selectedItem?.title ?? ""{
                    self.textField1.text = userDefault.value(forKey: QuestionField.medicareNumber.rawValue) as? String
                    self.textField2.text = userDefault.value(forKey: QuestionField.medicarePosition.rawValue) as? String
                    self.textField3.text = validityForMedicareCard
                }else{
                    self.textField1.text = ""
                    self.textField2.text = ""
                    self.textField3.text  = ""
                }
            }
            
        default:
            break
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

    func saveKYCAddress(_ address: GetAddressResponse) {
        self.viewModel.save(QuestionField.kycResidentialStreetName.rawValue, value: address.address ?? "")
        self.viewModel.save(QuestionField.kycResidentialPostcode.rawValue, value: address.postCode ?? "")
        self.viewModel.save(QuestionField.kycResidentialState.rawValue, value: address.state ?? "")
        self.viewModel.save(QuestionField.kycResidentialCountry.rawValue, value: "Australia")
    }

    func saveEmployerAddress(_ address: GetAddressResponse) {
        self.viewModel.save(QuestionField.employerAddress.rawValue, value: address.address ?? "")
        self.viewModel.save(QuestionField.employerPostcode.rawValue, value: address.postCode ?? "")
    }
    
    func inputsFromTextFields(textFields: [UITextField])-> [String: Any] {
        var results = [String: Any]()
        for textField in textFields {
            if let key = textField.placeholder, let value = textField.text, !textField.isHidden {
                results[key] = value
            }
        }
        return results
    }
    
    
    func validateResidentialAddressLookup()->ValidationError? {
        guard AppData.shared.residentialAddressList.count > 0 else {
            self.searchTextField.text = ""
            return ValidationError.autoCompleteHomeAddressIsMandatory
        }
        
        let autoCompleteMatch = AppData.shared.residentialAddressList.filter { $0.address == searchTextField.text }
        
        if autoCompleteMatch.count == 1 {
            return nil
        } else {
            self.searchTextField.text = ""
            return ValidationError.autoCompleteHomeAddressIsMandatory
        }
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
        let inputs = self.inputsFromTextFields(textFields: [self.searchTextField] + self.textFields)
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
        textFields
            .enumerated()
            .forEach { idx, textField in
                textField.placeholder = self.viewModel.placeHolder(idx)
                textField.isUserInteractionEnabled = self.viewModel.isEditable(at: idx)
                textField.backgroundColor = self.viewModel.isEditable(at: idx) ? .white : UIColor(hex: "ededed")
        }
        
        if self.viewModel.coordinator.numOfTextFields == 2 {
            //manish
            let firstname = viewModel.fieldValue(.firstname)
            if (firstname.count == 0){
                self.hideNavBar() //is from registration then hide back button
            }
        }
        
        if (viewModel.coordinator.type == .companyName || viewModel.coordinator.type == .companyAddress || viewModel.coordinator.type == .residentialAddress || viewModel.coordinator.type == .verifyName){
            textField1.placeholder = ""
            searchTextField.placeholder = self.viewModel.placeHolder(0)
        }
    }
    
    func showNormalTextFields() {
        textFields
            .enumerated()
            .forEach { idx, textField in
                textField.isHidden = self.viewModel.coordinator.numOfTextFields <= idx
                textField.setupLeftPadding()
                textField.setShadow()
        }

        searchTextField.isHidden = true
        
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
        //        let qvm = QuestionViewModel()
        //        qvm.loadSaved()
        //        let unit = qvm.fieldValue(.unitNumber)
        //        let address = qvm.fieldValue(.residentialAddress)
        //textField1.text = unit
        //textField2.text = address
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
        self.textFields.forEach {
            $0.isHidden = true
        }
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
            showDatePicker(textField1, initialDate: 18.years.earlier, maxDate: 18.years.earlier, minDate: nil, picker: datePicker)
            self.view.endEditing(true)

        case .medicare where textField == textField3 && textField.inputView == nil:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                textField.resignFirstResponder()
                self.view.endEditing(true)
                self.showDatePicker(self.textField3, initialDate: 1.days.later, maxDate: nil, minDate: Date(), picker: self.datePicker)
            }
        case .frankieKycAddress where textField == textField5, .driverLicense where textField == textField1:
            textField.inputView = statePickerView
            statePickerView.isHidden = false
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
        if textField == textField5 || textField == textField1{
            statePickerView.isHidden = true
        }
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
            
            if (AppData.shared.employerAddressList.count > AppData.shared.selectedEmployerAddress) {
                let employerAddress = AppData.shared.employerAddressList[AppData.shared.selectedEmployerAddress]
            }
            self.searchTextField.text = item[itemPosition].title
        }
        
        searchTextField.userStoppedTypingHandler = {
            if let query = self.searchTextField.text, query.count > self.searchTextField.minCharactersNumberToStartFiltering {
                CheqAPIManager.shared.residentialAddressLookup(query).done { addressList in
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
        self.hideImageContainer()
        
        self.textField1.isHidden = false
        self.searchTextField.isHidden = false
        
        //        let qvm = QuestionViewModel()
        //        qvm.loadSaved()
        //        let unit = qvm.fieldValue(.unitNumber)
        //        let address = qvm.fieldValue(.residentialAddress)
        //        textField1.text = unit
        //        searchTextField.text = address
        
        self.textField1.placeholder = self.viewModel.placeHolder(0)
        searchTextField.placeholder = self.viewModel.placeHolder(1)
        searchTextField.isUserInteractionEnabled = true
        searchTextField.minCharactersNumberToStartFiltering = 2
        
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
        LoggingUtil.shared.cPrint(AppData.shared.employeeOverview?.eligibleRequirement?.hasPayCycle)
        return false
    }
}

//MARK: Pickerview delegates and datasource

extension QuestionViewController: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.choices.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.choices[row].title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let ref = self.choices[row].ref as? CountryState {
            self.selectedStateName = ref.rawValue
        }
        if viewModel.coordinator.type == .driverLicense{
            self.textField1.text = self.choices[row].title
            viewModel.save(QuestionField.driverLicenceState.rawValue, value: self.selectedStateName)
            if let state = userDefault.value(forKey: QuestionField.driverLicenceState.rawValue) as? String{
                let savedState = CountryState(raw: state)
                if self.textField1.text == savedState.name{
                    self.textField2.text = (userDefault.value(forKey: QuestionField.driverLicenceNumber.rawValue) as? String) ?? ""
                }else{
                    self.textField2.text = ""
                }
            }
        }else{
            textField5.text = self.choices[row].title
        }
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
    func tappedOnLearnMoreButton() {
        
    }
    
}


