//
//  DocumentVerificationViewController.swift
//  Cheq
//
//  Created by iTelaSoft-PC on 2/11/20.
//  Copyright © 2020 Cheq. All rights reserved.
//

import UIKit
import Onfido
import AVFoundation

class DocumentVerificationViewController: UIViewController {
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var frankieKYCDetailsResponse: UserResponseForFrankieKYC?
    var kycService = KycServiceProvider.onfido
    var items: [KycDocType] {
        switch kycService {
        case .onfido:
            return [.passport, .driversLicense]
        case .frankie:
            return [.driversLicense, .passport, .medicareCard]
        }
    }
    let cellSpacingHeight: CGFloat = 25
    var errOnfido : Error?
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNavBar()
        showBackButton()
        self.view.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        
        self.tableview.separatorStyle = .none
        self.mainContainer.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableview.backgroundView?.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableview.backgroundColor = AppConfig.shared.activeTheme.backgroundColor
        self.tableview.tableFooterView = UIView()
        
        self.titleLabel.text = kycService == .onfido ? "Select a document for verification" : "Choose your ID"
        
        let strMessage = "Cheq only accepts the documents above. All other ID’s will be rejected"
        let attributedString = NSMutableAttributedString(string: strMessage)
        attributedString.applyHighlight("All other ID’s will be rejected", color: .black, font: AppConfig.shared.activeTheme.mediumBoldFont)
        self.lblDetail.attributedText = attributedString
        self.lblDetail.setLineSpacing(lineSpacing: 8.0)
        self.lblDetail.textAlignment = .left
        
        self.tableViewHeightConstraint.constant = items.count == 2 ? 170 : 225
        
        AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_ID_start.rawValue, FirebaseEventKey.lend_KYC_ID_start.rawValue, FirebaseEventContentType.screen.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableview.reloadData()
        AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC.rawValue, FirebaseEventKey.lend_KYC.rawValue, FirebaseEventContentType.screen.rawValue)
        
        if kycService == .frankie{
            self.getUserFrankieKYCDetails()
        }
    }
    
    func getUserFrankieKYCDetails(){
        AppConfig.shared.showSpinner()
        
        CheqAPIManager.shared.getUserDetailsForFrankieKYC().done { (response) in
            AppConfig.shared.hideSpinner {
            }
            self.frankieKYCDetailsResponse = response
            self.saveFrankieKYCData()
            LoggingUtil.shared.cPrint("\n\n>>FrankieResponse = \(response)")
        }.catch { [weak self] err in
            guard let self = self else { return }
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
            }
        }
    }
    
    func saveFrankieKYCData(){
        if let dob = self.frankieKYCDetailsResponse?.detail?.dateOfBirth,dob != ""{
//            let date = dob.UTCToLocal()
            userDefault.setValue(dob, forKey: QuestionField.dateOfBirth.rawValue)
        }
        if let firstName = self.frankieKYCDetailsResponse?.detail?.firstName, firstName != ""{
            userDefault.setValue(firstName, forKey: QuestionField.firstname.rawValue)
        }
        if let middleName = self.frankieKYCDetailsResponse?.detail?.middleName, middleName != ""{
            userDefault.setValue(middleName, forKey: QuestionField.lastname.rawValue)
        }
        if let lastName = self.frankieKYCDetailsResponse?.detail?.lastName, lastName != ""{
            userDefault.setValue(lastName, forKey: QuestionField.surname.rawValue)
        }
        if let unitNumber = self.frankieKYCDetailsResponse?.address?.unitNumber, unitNumber != ""{
            userDefault.setValue(unitNumber, forKey: QuestionField.kycResidentialUnitNumber.rawValue)
        }
        if let streetNumber = self.frankieKYCDetailsResponse?.address?.streetNumber, streetNumber != ""{
            userDefault.setValue(streetNumber, forKey: QuestionField.kycResidentialStreetNumber.rawValue)
        }
        if let streetName = self.frankieKYCDetailsResponse?.address?.streetName, streetName != ""{
            userDefault.setValue(streetName, forKey: QuestionField.kycResidentialStreetName.rawValue)
        }
        if let suburb = self.frankieKYCDetailsResponse?.address?.suburb, suburb != ""{
            userDefault.setValue(suburb, forKey: QuestionField.kycResidentialSuburb.rawValue)
        }
        if let state = self.frankieKYCDetailsResponse?.address?.state, state != ""{
            userDefault.setValue(state, forKey: QuestionField.kycResidentialState.rawValue)
        }
        if let postcode = self.frankieKYCDetailsResponse?.address?.postCode, postcode != ""{
            userDefault.setValue(postcode, forKey: QuestionField.kycResidentialPostcode.rawValue)
        }
        
        if let driverLicenseData = self.frankieKYCDetailsResponse?.idDocument?.driverLicence{
            if let state = driverLicenseData.state,state != ""{
                userDefault.setValue(state, forKey: QuestionField.driverLicenceState.rawValue)
            }
            if let number = driverLicenseData.idNumber,number != ""{
                userDefault.setValue(number, forKey: QuestionField.driverLicenceNumber.rawValue)
            }
        }
        
        if let passportData = self.frankieKYCDetailsResponse?.idDocument?.passport{
            if let number = passportData.idNumber,number != ""{
                userDefault.setValue(number, forKey: QuestionField.passportNumber.rawValue)
            }
        }
        
        if let medicareData = self.frankieKYCDetailsResponse?.idDocument?.medicare{
            if let number = medicareData.idNumber,number != ""{
                userDefault.setValue(number, forKey: QuestionField.medicareNumber.rawValue)
            }
            if let position = medicareData.positionOnCard,position != ""{
                userDefault.setValue(position, forKey: QuestionField.medicarePosition.rawValue)
            }
            if let day = medicareData.validToDay,day != 0{
                userDefault.setValue(day, forKey: QuestionField.medicareValidToDay.rawValue)
            }
            if let month = medicareData.validToMonth,month != 0{
                userDefault.setValue(month, forKey: QuestionField.medicareValidToMonth.rawValue)
            }
            if let year = medicareData.validToYear,year != 0{
                userDefault.setValue(year, forKey: QuestionField.medicareValidToYear.rawValue)
            }
            if let color = medicareData.color,color != ""{
                userDefault.setValue(color, forKey: QuestionField.color.rawValue)
            }
            userDefault.synchronize()
        }
    }
}

extension DocumentVerificationViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath) as! DocumentVerifyTableViewCell
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear //AppConfig.shared.activeTheme.backgroundColor
        cell.content.backgroundColor = .white
        AppConfig.shared.activeTheme.cardStyling(cell.content, addBorder: true)
        let model = items[indexPath.row]
        cell.DocumnerVerifyLabel.text = model.rawValue
        if model == .passport && kycService == .frankie {
            cell.DocumnerVerifyLabel.text = "Australian Passport"
        }
        cell.documentVerifyImageView.image = model.icon
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_ID.rawValue, FirebaseEventKey.lend_KYC_ID.rawValue, FirebaseEventContentType.button.rawValue)
        
        let selectedDoc = items[indexPath.row]
        
        if kycService == .onfido {
            if selectedDoc == .passport {
                AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_ID_passport.rawValue, FirebaseEventKey.lend_KYC_ID_passport.rawValue, FirebaseEventContentType.button.rawValue)
            }
            if selectedDoc == .driversLicense {
                AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_ID_license.rawValue, FirebaseEventKey.lend_KYC_ID_license.rawValue, FirebaseEventContentType.button.rawValue)
            }
            
            AppConfig.shared.showSpinner()
            let req = DataHelperUtil.shared.retrieveUserDetailsKycReq()
            CheqAPIManager.shared.retrieveUserDetailsKyc(req).done { response in
                let sdkToken = response.sdkToken ?? ""
                AppData.shared.saveOnfidoSDKToken(sdkToken)
                self.initiateOnFido(kycSelectDoc: selectedDoc)
                
            }.catch { err in
                AppConfig.shared.hideSpinner {
                    self.showError(CheqAPIManagerError.unableToPerformKYCNow, completion: nil)
                }
            }
        }
        
        if kycService == .frankie {
            initiateFrankie(selectedDocType: selectedDoc)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func initiateOnFido(kycSelectDoc: KycDocType) {
        AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_ID_start_click.rawValue, FirebaseEventKey.lend_KYC_ID_start_click.rawValue, FirebaseEventContentType.button.rawValue)
        
        OnfidoManager.shared.fetchSdkToken().done { response in
            AppConfig.shared.hideSpinner {
                let onfidoSdkToken = response.sdkToken ?? ""
                AppData.shared.saveOnfidoSDKToken(onfidoSdkToken)
                //AppNav.shared.navigateToKYCFlow(kycSelectDoc ?? KycDocType.Passport , viewController: self)
                self.navigateToKYCFlow(kycSelectDoc, viewController: self)
            }
            
        }.catch { err in
            AppConfig.shared.hideSpinner {
                self.showError(err, completion: nil)
                return
            }
        }
    }
    
    private func initiateFrankie(selectedDocType: KycDocType) {
        AppData.shared.selectedKycDocType = selectedDocType
        switch selectedDocType {
        case .driversLicense:
            if let _ = self.frankieKYCDetailsResponse?.idDocument?.driverLicence{
                AppNav.shared.pushToQuestionForm(.driverLicense, viewController: self)
            }else{
                AppNav.shared.pushToMultipleChoice(.state, viewController: self)
            }
        case .passport:
            AppNav.shared.pushToQuestionForm(.passport, viewController: self)
        case .medicareCard:
            AppNav.shared.pushToQuestionForm(.medicare, viewController: self)
        }
    }
}


extension DocumentVerificationViewController {
    /**
     Helper method to initiate KYC flow using the onfido SDK
     - parameter type: **KycDocType** can be driver's licence or passport. **navigateToKYCFlow** takes in the user's decision on which document type is used for KYC flow.
     - parameter viewController: source viewController of the navigation action
     */
    func navigateToKYCFlow(_ type: KycDocType, viewController: UIViewController) {
        AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_addy_click.rawValue, FirebaseEventKey.lend_KYC_addy_click.rawValue, FirebaseEventContentType.button.rawValue)
        
        /// fetching the sdkToken from AppData helper method using **loadOnfidoSDKToken**
        let sdkToken = AppData.shared.loadOnfidoSDKToken()
        guard sdkToken.isEmpty == false else {
            /// if the sdk token is empty, then the logic cannot continue
            viewController.showMessage("Sdk token must be available", completion: nil)
            return
        }
        
        LoggingUtil.shared.cPrint("KYC flow")
        
        let appearance = Appearance(
            primaryColor:  AppConfig.shared.activeTheme.primaryColor,
            primaryTitleColor: AppConfig.shared.activeTheme.altTextColor,
            primaryBackgroundPressedColor: AppConfig.shared.activeTheme.textBackgroundColor,
            supportDarkMode : true)
        
        //let docType: DocumentType = (type == .Passport) ? DocumentType.passport : DocumentType.drivingLicence
        let drivingLicenceConfiguration = DrivingLicenceConfiguration.init(country: CountryCode.AU.rawValue)
        let docType: DocumentType = (type == .passport) ? DocumentType.passport(config: nil) : DocumentType.drivingLicence(config: drivingLicenceConfiguration)
        
        let config = try! OnfidoConfig.builder()
            .withAppearance(appearance)
            .withSDKToken(AppData.shared.onfidoSdkToken)
            .withWelcomeStep()
            .withDocumentStep(ofType: docType)
            .withFaceStep(ofVariant: .photo(withConfiguration: nil))
            .build()
        
        //        let config = try! OnfidoConfig.builder()
        //            .withAppearance(appearance)
        //            .withSDKToken(AppData.shared.onfidoSdkToken)
        //            .withWelcomeStep()
        //            .withDocumentStep(ofType: docType, andCountryCode: CountryCode.AU.rawValue)
        //            .withFaceStep(ofVariant: .photo(withConfiguration: nil))
        //            .build()
        
        /// define the handling of the end of Onfido flow
        let onfidoFlow = OnfidoFlow(withConfiguration: config)
            .with(responseHandler: { results in
                switch results {
                /// successful case
                case .success(_):
                    
                    //SDK flow has been completed successfully
                    AppConfig.shared.showSpinner()
                    CheqAPIManager.shared.putKycCheck().done {
                        AppConfig.shared.hideSpinner {
                            LoggingUtil.shared.cPrint("kyc checked")
                            guard AppData.shared.completingDetailsForLending else { return }
                            
                            NotificationUtil.shared.notify(UINotificationEvent.lendingOverview.rawValue, key: "", value: "")
                            AppNav.shared.dismissModal(viewController){}
                            AppConfig.shared.addEventToFirebase(PassModuleScreen.Lend.rawValue, FirebaseEventKey.lend_KYC_addy_verify.rawValue, FirebaseEventKey.lend_KYC_addy_verify.rawValue, FirebaseEventContentType.button.rawValue)
                            //viewController.dismiss(animated: true, completion:nil)
                        }
                    }.catch{ err in
                        
                        AppConfig.shared.hideSpinner {
                            let error = err
                            guard AppData.shared.completingDetailsForLending else {
                                return
                            }
                            viewController.dismiss(animated: true, completion: {
                                NotificationUtil.shared.notify(UINotificationEvent.showError.rawValue, key: "", object: error)
                            })
                            
                        }
                    }
                    
                    
                /// error case handling
                case let OnfidoResponse.error(err):
                    self.errOnfido = err
                    switch err {
                    case OnfidoFlowError.cameraPermission:
                        // It happens if the user denies permission to the sdk during the flow
                        LoggingUtil.shared.cPrint("OnfidoFlowError.cameraPermission")
                        self.showPopup_OnfidoFlowError_cameraPermission()
                        
                    case OnfidoFlowError.failedToWriteToDisk:
                        // It happens when the SDK tries to save capture to disk, maybe due to a lack of space
                        LoggingUtil.shared.cPrint("nfidoFlowError.failedToWriteToDisk")
                        self.showPopup_failedToWriteToDisk()
                        
                    case OnfidoFlowError.microphonePermission:
                        // It happens when the user denies permission for microphone usage by the app during the flow
                        LoggingUtil.shared.cPrint("OnfidoFlowError.microphonePermission")
                        self.showPopup_OnfidoFlowError_exception()
                        
                        
                    case OnfidoFlowError.upload(_):
                        // It happens when the SDK receives an error from a API call see [https://documentation.onfido.com/#errors](https://documentation.onfido.com/#errors) for more information
                        LoggingUtil.shared.cPrint("OnfidoFlowError.upload")
                        self.showPopup_OnfidoFlowError_upload()
                        
                        
                    case OnfidoFlowError.exception(withError: let error, withMessage: let message):
                        //// It happens when an unexpected error occurs, please contact [ios-sdk@onfido.com](mailto:ios-sdk@onfido.com?Subject=ISSUE%3A) when this happens
                        LoggingUtil.shared.cPrint(error ?? "")
                        LoggingUtil.shared.cPrint(message ?? "")
                        self.showPopup_OnfidoFlowError_exception()
                        
                    default:
                        // necessary
                        LoggingUtil.shared.cPrint(err)
                        self.showPopup_OnfidoFlowError_exception()
                    }
                    
                case OnfidoResponse.cancel:
                    LoggingUtil.shared.cPrint("flow canceled by user")
                    
                default: break
                }
            })
        
        
        /// presenting onfido viewController to start the flow
        do {
            let onfidoRun = try onfidoFlow.run()
            /*
             Supported presentation styles are:
             For iPhones: .fullScreen
             For iPads: .fullScreen and .formSheet
             */
            var modalPresentationStyle: UIModalPresentationStyle = .fullScreen
            // due to iOS 13 you must specify .fullScreen as the default is now .pageSheet
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                modalPresentationStyle = .formSheet // to present modally on iPads
            }
            
            onfidoRun.modalPresentationStyle = modalPresentationStyle
            viewController.present(onfidoRun, animated: true) { }
        } catch let err {
            // cannot execute the flow
            LoggingUtil.shared.cPrint(err)
            self.tableview.reloadData()
            
            self.errOnfido = err
            switch err {
            case OnfidoFlowError.cameraPermission:
                LoggingUtil.shared.cPrint("OnfidoFlowError.cameraPermission")
                self.showPopup_OnfidoFlowError_cameraPermission()
                
            case OnfidoFlowError.failedToWriteToDisk:
                LoggingUtil.shared.cPrint("nfidoFlowError.failedToWriteToDisk")
                self.showPopup_failedToWriteToDisk()
                
            case OnfidoFlowError.microphonePermission:
                LoggingUtil.shared.cPrint("OnfidoFlowError.microphonePermission")
                showPopup_OnfidoFlowError_exception()
                
            case OnfidoFlowError.upload(_):
                LoggingUtil.shared.cPrint("OnfidoFlowError.upload")
                self.showPopup_OnfidoFlowError_upload()
                
            case OnfidoFlowError.exception(withError: let error, withMessage: let message):
                LoggingUtil.shared.cPrint(error ?? "")
                LoggingUtil.shared.cPrint(message ?? "")
                self.showPopup_OnfidoFlowError_exception()
                
            default:
                LoggingUtil.shared.cPrint(err)
                showPopup_OnfidoFlowError_exception()
            }
        }
    }
}

extension DocumentVerificationViewController: VerificationPopupVCDelegate {
    
    func showPopup_OnfidoFlowError_cameraPermission() {
        //button: “Enable Camera Permissions“ → request camera permissions
        //button: Learn more - “https://help.cheq.com.au/en/articles/3629190-how-do-i-verify-my-id“
        self.openPopupForCamera(heading: "Camera Permission", message: "We need camera permissions to be able to complete the identity verification process.", buttonTitle: "Enable Camera Permission", showSendButton: true, emoji: UIImage(named: "image-moreInfo"))
    }
    
    func showPopup_failedToWriteToDisk() {
        //OnfidoFlowError.failedToWriteToDisk:
        //button: ”Try Again” → go to start of onfido process
        openPopupWith(heading: "Not enough storage", message: "We are unable to complete the identity verification process, please make sure you have enough storage on your phone.", buttonTitle: "Try again", showSendButton: false, emoji: UIImage.init(named:"image-moreInfo"))
    }
    
    func showPopup_verification_unsuccessful() {
        openPopupWith(heading: "Verification unsuccessful", message: "We are unable to complete the identity verification process, please try again.", buttonTitle: "Try again", showSendButton: false, emoji: UIImage.init(named:"image-moreInfo"))
    }
    
    func showPopup_OnfidoFlowError_exception() {
        //”We are unable to complete the identity verification process, please try again.”
        // button: ”Try Again” → go to start of onfido process
        openPopupWith(heading: "We are unable to complete the identity verification process, please try again.", message: "", buttonTitle: "Try again", showSendButton: false, emoji: UIImage.init(named:"image-moreInfo"))
    }
    
    func showPopup_OnfidoFlowError_upload() {
        //”We are unable to complete the identity verification process, please make sure you have enough storage on your phone.”
        //button: ”Try Again” → go to start of onfido process
        openPopupWith(heading: "We are unable to complete the identity verification process, please make sure you have enough storage on your phone.", message: "", buttonTitle: "Try again", showSendButton: false, emoji: UIImage.init(named:"image-moreInfo"))
    }
    
    func openPopupForCamera(heading: String?, message: String?, buttonTitle: String?, showSendButton: Bool?, emoji:UIImage?) {
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: StoryboardName.Popup.rawValue, bundle: Bundle.main)
        if let popupVC = storyboard.instantiateInitialViewController() as? VerificationPopupVC {
            popupVC.delegate = self
            popupVC.heading = heading ?? ""
            popupVC.message = message ?? ""
            popupVC.buttonTitle = buttonTitle ?? ""
            popupVC.showSendButton = showSendButton ?? false
            popupVC.emojiImage = emoji ?? UIImage()
            popupVC.isShowLearnMoreButton = true
            popupVC.isShowCloseButton = false
            self.present(popupVC, animated: false, completion: nil)
        }
    }
    
    func openPopupWith(heading: String?, message: String?, buttonTitle: String?, showSendButton: Bool?, emoji: UIImage?) {
        self.view.endEditing(true)
        let storyboard = UIStoryboard(name: StoryboardName.Popup.rawValue, bundle: Bundle.main)
        if let popupVC = storyboard.instantiateInitialViewController() as? VerificationPopupVC {
            popupVC.delegate = self
            popupVC.heading = heading ?? ""
            popupVC.message = message ?? ""
            
            popupVC.emojiImage = emoji ?? UIImage()
            popupVC.isShowLearnMoreButton = false
            
            popupVC.buttonTitle = ""
            popupVC.showSendButton = false
            
            popupVC.buttonCloseTitle = "Try again"
            popupVC.isShowCloseButton = true
            
            self.present(popupVC, animated: false, completion: nil)
        }
    }
    
    func tappedOnSendButton() {
        
        let err = self.errOnfido as! OnfidoFlowError
        
        switch err {
        case OnfidoFlowError.cameraPermission:
            LoggingUtil.shared.cPrint("OnfidoFlowError.cameraPermission")
            self.cameraSelected()
            
        case OnfidoFlowError.failedToWriteToDisk:
            LoggingUtil.shared.cPrint("nfidoFlowError.failedToWriteToDisk")
            //go to start of onfido process
            if self.presentingViewController?.isKind(of: OnfidoFlow.self) == true {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            
            
        case OnfidoFlowError.microphonePermission:
            LoggingUtil.shared.cPrint("OnfidoFlowError.microphonePermission")
            //go to start of onfido process
            if self.presentingViewController?.isKind(of: OnfidoFlow.self) == true {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            
        case OnfidoFlowError.upload(_):
            LoggingUtil.shared.cPrint("OnfidoFlowError.upload")
            
            //go to start of onfido process
            if self.presentingViewController?.isKind(of: OnfidoFlow.self) == true {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            
        case OnfidoFlowError.exception(withError: let error, withMessage: let message):
            LoggingUtil.shared.cPrint("OnfidoFlowError.exception")
            LoggingUtil.shared.cPrint(error ?? "")
            LoggingUtil.shared.cPrint(message ?? "")
            //go to start of onfido process
            if self.presentingViewController?.isKind(of: OnfidoFlow.self) == true {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            
        default:
            LoggingUtil.shared.cPrint("OnfidoFlowError.default")
            LoggingUtil.shared.cPrint(err)
            //go to start of onfido process
            if self.presentingViewController?.isKind(of: OnfidoFlow.self) == true {
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
    func tappedOnCloseButton() {
        
    }
    
    func tappedOnLearnMoreButton() {
        let link = "https://help.cheq.com.au/en/articles/3629190-how-do-i-verify-my-id"
        guard let url = URL(string: link) else { return }
        AppNav.shared.pushToInAppWeb(url, viewController: self)
    }
}


extension DocumentVerificationViewController {
    
    func cameraSelected() {
        // First we check if the device has a camera (otherwise will crash in Simulator - also, some iPod touch models do not have a camera).
        let deviceHasCamera = UIImagePickerController.isSourceTypeAvailable(.camera)
        if deviceHasCamera, AVCaptureDevice.authorizationStatus(for: .video) != .authorized {
            alertPromptToAllowCameraAccessViaSettings()
        }
    }
    
    func alertPromptToAllowCameraAccessViaSettings() {
        
        let alert = UIAlertController(title: "Cheq Would Like To Access the Camera", message: "Please grant permission to use the camera to complete the identity verification process.", preferredStyle: .alert )
        
        alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { alert in
            if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            }
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension String{
    func UTCToLocal() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let dt = dateFormatter.date(from: self)
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: dt ?? Date())
    }
}
