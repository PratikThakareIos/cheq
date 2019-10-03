//
//  MultipleChoiceViewController.swift
//  Cheq
//
//  Created by Xuwei Liang on 17/9/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK

class MultipleChoiceViewController: UIViewController {

    var viewModel = MultipleChoiceViewModel()
    var choices:[ChoiceModel] = []
    var selectedChoice: ChoiceModel?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sectionTitle: CLabel!
    @IBOutlet weak var questionTitle: CLabel!
    
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
        self.hideBackTitle()
        // non-zero estimated row height to trigger automatically calculation of cell height based on auto layout on tableview
        self.tableView.estimatedRowHeight = AppConfig.shared.activeTheme.defaultButtonHeight
        self.tableView.backgroundColor = .clear
        self.questionTitle.font = AppConfig.shared.activeTheme.headerFont
        self.questionTitle.text = self.viewModel.question()
        self.sectionTitle.font = AppConfig.shared.activeTheme.defaultFont
        self.sectionTitle.text = self.viewModel.coordinator.sectionTitle
        
        AppConfig.shared.progressNavBar(progress: AppData.shared.progress, viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        if selectedChoice == nil {
            self.updateChoices()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func updateChoices() {
        if self.viewModel.coordinator.coordinatorType == .financialInstitutions {
            AppConfig.shared.showSpinner()
        }
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
        case .employmentType:
            let employmentType = EmploymentType(fromRawValue: choice.title)
            viewModel.savedAnswer[QuestionField.employerType.rawValue] = employmentType.rawValue
            AppData.shared.updateProgressAfterCompleting(.employmentType)
            if employmentType == .onDemand {
                AppNav.shared.pushToMultipleChoice(.onDemand, viewController: self)
            } else {
                AppNav.shared.pushToIntroduction(.enableLocation, viewController: self)
            }
        case .onDemand:
            let vm = self.viewModel
            vm.save(QuestionField.employerName.rawValue, value: choice.title)
            vm.save(QuestionField.employerType.rawValue, value: EmploymentType.onDemand.rawValue)
            let qVm = QuestionViewModel()
            // load saved data, questionViewModel and multipleChoiceViewModel save to same map
            qVm.loadSaved()
            let empType = EmploymentType(fromRawValue: qVm.fieldValue(.employerType))
            let noFixedAddress = (empType == .onDemand) ? true : false
            let req = PutUserEmployerRequest(employerName: qVm.fieldValue(.employerName), employmentType: vm.cheqAPIEmploymentType(empType), address: qVm.fieldValue(.employerAddress), noFixedAddress: noFixedAddress, latitude: Double(qVm.fieldValue(.employerLatitude)) ?? 0.0, longitude: Double(qVm.fieldValue(.employerLongitude)) ?? 0.0, postCode: qVm.fieldValue(.employerPostcode), state: qVm.fieldValue(.employerState), country: qVm.fieldValue(.employerCountry))
            CheqAPIManager.shared.putUserEmployer(req).done { authUser in
                AppData.shared.updateProgressAfterCompleting(.onDemand)
                AppNav.shared.pushToIntroduction(.setupBank, viewController: self)
            }.catch { err in
                self.showError(err) {
                }
            }
        case .financialInstitutions:
            // storing the selected bank and bank list before pushing to the dynamicFormViewController
            // to render the form 
            AppData.shared.updateProgressAfterCompleting(.financialInstitutions)
            let selectedChoice = self.choices[indexPath.row]
            AppData.shared.selectedFinancialInstitution = selectedChoice.ref as? FinancialInstitutionModel
            guard let bank = AppData.shared.selectedFinancialInstitution else { showError(AuthManagerError.invalidFinancialInstitutionSelected, completion: nil)
                return
            }
            AppData.shared.updateProgressAfterCompleting(.financialInstitutions)
            AppNav.shared.pushToDynamicForm(bank, viewController: self)
            
        case .ageRange:
            let vm = self.viewModel
            vm.save(QuestionField.ageRange.rawValue, value: choice.title)
            AppData.shared.updateProgressAfterCompleting(.ageRange)
            AppNav.shared.pushToQuestionForm(.contactDetails, viewController: self)
        case .state:
            let vm = self.viewModel
            vm.save(QuestionField.residentialState.rawValue, value: choice.title)
            AppData.shared.updateProgressAfterCompleting(.state)
            AppNav.shared.pushToQuestionForm(.maritalStatus, viewController: self)
        }
    }
}

extension MultipleChoiceViewController {
    
    func setupCellForChoiceWithCaption(_ choice: ChoiceModel, tableView: UITableView, indexPath: IndexPath)-> UITableViewCell {
        let reuseId = String(describing: CMultipleChoiceWithCaptionCell.self)
        let cell = tableView .dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! CMultipleChoiceWithCaptionCell
        cell.titleLabel.text = choice.title
        cell.captionLabel.text = choice.caption ?? ""
        cell.backgroundColor = .clear
        AppConfig.shared.activeTheme.cardStyling(cell.containerView, addBorder: true)
        return cell
    }
    
    func setupCellForChoiceWithIcon(_ choice: ChoiceModel, tableView: UITableView, indexPath: IndexPath)-> UITableViewCell {
        let reuseId = String(describing: CMultipleChoiceWithImageCell.self)
        let cell = tableView .dequeueReusableCell(withIdentifier: reuseId, for: indexPath) as! CMultipleChoiceWithImageCell
        cell.choiceTitleLabel.text = choice.title
        cell.choiceTitleLabel.textColor = AppConfig.shared.activeTheme.textColor
        if let imageName = choice.image {
            cell.iconImageView.isHidden = false
            cell.iconImageView.image = UIImage(named: imageName)
        } else {
            cell.iconImageView.isHidden = true
        }
        cell.backgroundColor = .clear
        AppConfig.shared.activeTheme.cardStyling(cell.containerView, addBorder: true)
        return cell
    }
}
