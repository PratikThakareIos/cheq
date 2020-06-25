//
//  LendingViewModel.swift
//  Cheq
//
//  Created by Xuwei Liang on 4/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK


class LendingViewModel: BaseTableVCViewModel {
    
    override init() {
        super.init()
        self.screenName = .lending
    }
    
    func render(_ lendingOverview: GetLendingOverviewResponse) {
        clearSectionIfNeeded()
        var section = TableSectionViewModel()
        
        
        let isDeclineExist  = self.declineExist(lendingOverview)
        if isDeclineExist {
             self.addLoanSetting(lendingOverview, section: &section)
             section.rows.append(SpacerTableViewCellViewModel())
             self.addDeclienCell(lendingOverview, section: &section)
        }else{
            //section.rows.append(IntercomChatTableViewCellViewModel())
            self.addLoanSetting(lendingOverview, section: &section)
            self.addCashoutButton(lendingOverview, section: &section)
            self.addMessageBubble(lendingOverview, section: &section)
            section.rows.append(SpacerTableViewCellViewModel())
            self.completeDetails(lendingOverview, section: &section)
            section.rows.append(SpacerTableViewCellViewModel())
            // actvity
            self.activityList(lendingOverview, section: &section)
            section.rows.append(SpacerTableViewCellViewModel())
        }

        self.sections = [section]
        
        NotificationUtil.shared.notify(UINotificationEvent.reloadTable.rawValue, key: "", value: "")
    }
    
    func isKycStatusSuccess(_ kycStatus: EligibleRequirement.KycStatus)-> Bool {
        return kycStatus == EligibleRequirement.KycStatus.success
    }
    
    func isKycStatusFailed(_ kycStatus: EligibleRequirement.KycStatus)-> Bool {
        return kycStatus == EligibleRequirement.KycStatus.failed
    }
    
    func isKycStatusInProcessing(_ kycStatus: EligibleRequirement.KycStatus) -> Bool {
          return kycStatus == EligibleRequirement.KycStatus.inProcessing
    }
    
    func isKycStatusPending(_ kycStatus: EligibleRequirement.KycStatus)-> Bool {
        if kycStatus == EligibleRequirement.KycStatus.notStarted || kycStatus == EligibleRequirement.KycStatus.createdApplicant{
            return true
        } else {
            return false
        }
    }
    
    func declineExist(_ lendingOverview: GetLendingOverviewResponse)-> Bool {
        guard let eligibleRequirements = lendingOverview.eligibleRequirement else { return false }
       
        
        let kycSuceeded = self.isKycStatusFailed(eligibleRequirements.kycStatus ?? .notStarted)
        let kycFailed = self.isKycStatusSuccess(eligibleRequirements.kycStatus ?? .notStarted)
        
        // if kyc is not completed, if means it's pending for action or waiting as it's in processing
        let kycCompleted = kycSuceeded || kycFailed
        
        if (eligibleRequirements.hasBankAccountDetail ?? false && eligibleRequirements.hasEmploymentDetail ?? false && kycCompleted) {
            return false
        }
        //guard eligibleRequirements.hasBankAccountDetail == true, eligibleRequirements.hasEmploymentDetail == true, kycCompleted == true else { return false }
        
        guard let declineDetails = lendingOverview.decline, let reason = declineDetails.declineReason else { return false }
        
        guard reason != ._none else { return false }
        
        return true
    }
}

// amount select
extension LendingViewModel {
    
    func addDeclienCell(_ lendingOverview: GetLendingOverviewResponse,  section: inout TableSectionViewModel) {
        guard let declineDetails = lendingOverview.decline, let reason = declineDetails.declineReason else {
            return }
        AppData.shared.declineDescription = declineDetails.declineDescription ?? ""
        let viewModel = DeclineDetailViewModel()
        viewModel.declineDetails = declineDetails
        section.rows.append(viewModel)
    }
    
    func addLoanSetting (_ lendingOverview: GetLendingOverviewResponse,  section: inout TableSectionViewModel) {
        // loan control
        if let loanSetting = lendingOverview.loanSetting, let borrowOverview = lendingOverview.borrowOverview {
            let amountSelect = AmountSelectTableViewCellViewModel()
            let maxLimit = borrowOverview.availableCashoutAmount ?? 0 //loanSetting.maximumAmount ?? 200
            amountSelect.selectedAmountIndex = 0
            amountSelect.buildAvaialbleToWithDraw(low: loanSetting.minimalAmount ?? 100, limit: Int(maxLimit), increment: loanSetting.incrementalAmount ?? 100)
            section.rows.append(amountSelect)
        }
    }
    
    func addMessageBubble(_ lendingOverview: GetLendingOverviewResponse, section: inout TableSectionViewModel) {
        
        if lendingOverview.loanSetting?.maximumAmount == 0 {
            LoggingUtil.shared.cPrint("limit reach message")
            let messageBubble = MessageBubbleTableViewCellViewModel()
            section.rows.append(messageBubble)
        }
    }
    
    func addCashoutButton (_ lendingOverview: GetLendingOverviewResponse, section: inout TableSectionViewModel) {
        // cash out button
        let hasBankAccountDetail = lendingOverview.eligibleRequirement?.hasBankAccountDetail ?? false
        let hasEmploymentDetail = lendingOverview.eligibleRequirement?.hasEmploymentDetail ?? false
        let isKycDone = lendingOverview.eligibleRequirement?.kycStatus == EligibleRequirement.KycStatus.success
        if hasEmploymentDetail, hasBankAccountDetail, isKycDone {
            let cashoutButton = CButtonTableViewCellViewModel()
            cashoutButton.title = keyButtonTitle.Cashout.rawValue
            cashoutButton.icon = IntroEmoji.speedy.rawValue
            section.rows.append(cashoutButton)
        }
    }
}

// complete details
extension LendingViewModel {
    
    func completeDetails (_ lendingOverview: GetLendingOverviewResponse, section: inout TableSectionViewModel) {
        guard let eligibleRequirement = lendingOverview.eligibleRequirement else { return }
        // complete details
        let top = TopTableViewCellViewModel()
        var completed = 0
        var completeDetailsViewModels = [TableViewCellViewModelProtocol]()
        let hasEmploymentDetail = eligibleRequirement.hasEmploymentDetail ?? false
        let hasBankDetails = eligibleRequirement.hasBankAccountDetail ?? false
        let kycStatus = eligibleRequirement.kycStatus ?? .notStarted
        let kycCompleted = isKycStatusSuccess(kycStatus)  //|| isKycStatusFailed(kycStatus)
        
        let hasPayCycle = eligibleRequirement.hasPayCycle ?? false
        let isReviewingPayCycle = eligibleRequirement.isReviewingPayCycle ?? false
        
        print(lendingOverview)
       
        //Check all status
        if hasEmploymentDetail == true, hasBankDetails == true, kycCompleted {
            return
        }
        
        // inprogress status should come too for all the cases
        
         /// **Step-> 1** Employment details*
        if hasEmploymentDetail {
            
            let completeDetailsForWork = CompleteDetailsTableViewCellViewModel()
            completeDetailsForWork.type = .workDetails
            if (hasPayCycle){
                completed = completed + 1
                completeDetailsForWork.completionState = .done
                completeDetailsForWork.expanded = false
                completeDetailsViewModels.append(completeDetailsForWork)
            }else if (!hasPayCycle && isReviewingPayCycle){
                completeDetailsForWork.completionState = .inprogress
                completeDetailsForWork.expanded = true
                completeDetailsViewModels.append(completeDetailsForWork)
            }else if (hasPayCycle && eligibleRequirement.isReviewingPayCycle ?? false){
                completeDetailsForWork.completionState = .inprogress
                completeDetailsForWork.expanded = true
                completeDetailsViewModels.append(completeDetailsForWork)
            }else {
                completed = completed + 1
                completeDetailsForWork.completionState = .done
                completeDetailsForWork.expanded = false
                completeDetailsViewModels.append(completeDetailsForWork)
            }
            
        } else {
            
            let completeDetailsForWork = CompleteDetailsTableViewCellViewModel()
            completeDetailsForWork.type = .workDetails
            completeDetailsForWork.completionState = .pending
            completeDetailsForWork.expanded = true
            completeDetailsViewModels.append(completeDetailsForWork)
        }
        

//          /// **Step-> 2** Verify that you have worked*
//        if hasEmploymentDetail {
//            print(eligibleRequirement.userAction)
//            let verifyYouHaveWorkedDetails = CompleteDetailsTableViewCellViewModel()
//            verifyYouHaveWorkedDetails.type = .workVerify
//            verifyYouHaveWorkedDetails.userAction = (eligibleRequirement.userAction?.action) ?? UserAction.Action.turnOnLocation
//            verifyYouHaveWorkedDetails.captionForVarifyWork = eligibleRequirement.userAction?._description
//            verifyYouHaveWorkedDetails.completionState = verifyYouHaveWorked ? .done : .inprogress
//            completed = verifyYouHaveWorked ? completed + 1 : completed
//            verifyYouHaveWorkedDetails.expanded = verifyYouHaveWorked ? false : true
//            completeDetailsViewModels.append(verifyYouHaveWorkedDetails)
//        } else {
//
//            let verifyYouHaveWorkedDetails = CompleteDetailsTableViewCellViewModel()
//            verifyYouHaveWorkedDetails.userAction = (eligibleRequirement.userAction?.action) ?? UserAction.Action.turnOnLocation
//            verifyYouHaveWorkedDetails.type = .workVerify
//            verifyYouHaveWorkedDetails.completionState = .inactive
//            verifyYouHaveWorkedDetails.expanded = false
//            completeDetailsViewModels.append(verifyYouHaveWorkedDetails)
//        }
        

        
          /// **Step-> 2** Enter your bank details*
        if hasEmploymentDetail && hasPayCycle {
            
            let completeDetailsForBankDetails = CompleteDetailsTableViewCellViewModel()
            completeDetailsForBankDetails.type = .bankDetils
            completeDetailsForBankDetails.completionState = hasBankDetails ? .done : .pending
            completed = hasBankDetails ? completed + 1 : completed
            completeDetailsForBankDetails.expanded = hasBankDetails ? false : true
            completeDetailsViewModels.append(completeDetailsForBankDetails)
        } else {
            
            let completeDetailsForBankDetails = CompleteDetailsTableViewCellViewModel()
            completeDetailsForBankDetails.type = .bankDetils
            completeDetailsForBankDetails.completionState = .inactive
            completeDetailsForBankDetails.expanded = false
            completeDetailsViewModels.append(completeDetailsForBankDetails)
        }
        
        
          /// **Step-> 3** Verify your identity*
        
        if self.isKycStatusFailed(kycStatus) {
            
            let completeDetailsForKyc = CompleteDetailsTableViewCellViewModel()
            completeDetailsForKyc.type = .verifyYourDetails
            completeDetailsForKyc.completionState = .failed
            completeDetailsForKyc.expanded = true
            completeDetailsViewModels.append(completeDetailsForKyc)
        }else if self.isKycStatusPending(kycStatus) {
            let completeDetailsForKyc = CompleteDetailsTableViewCellViewModel()
            completeDetailsForKyc.type = .verifyYourDetails
            completeDetailsForKyc.completionState = hasBankDetails && isKycStatusPending(kycStatus) ? .pending : .inprogress
            completeDetailsForKyc.expanded = hasBankDetails ? true : false
            completeDetailsViewModels.append(completeDetailsForKyc)
        }else if self.isKycStatusInProcessing(kycStatus){
            let completeDetailsForKyc = CompleteDetailsTableViewCellViewModel()
                completeDetailsForKyc.type = .verifyYourDetails
                completeDetailsForKyc.completionState = isKycStatusInProcessing(kycStatus) ? .inprogress : .inactive
                completeDetailsForKyc.expanded = hasBankDetails ? true : false
                completeDetailsViewModels.append(completeDetailsForKyc)
        }else {
            let completeDetailsForKyc = CompleteDetailsTableViewCellViewModel()
            completeDetailsForKyc.type = .verifyYourDetails
            completeDetailsForKyc.completionState = isKycStatusSuccess(kycStatus) ? .done : .inactive
            completeDetailsForKyc.expanded = hasBankDetails ? true : false
            completeDetailsViewModels.append(completeDetailsForKyc)
        }
        
        section.rows.append(top)
        
        let completedProgressViewModel = CompletionProgressTableViewCellViewModel()
        completedProgressViewModel.mode = .monetary
        completedProgressViewModel.completedItem = completed
        completedProgressViewModel.totalItem = 3
        completedProgressViewModel.progress = Float(completed) / Float(3)
        section.rows.append(completedProgressViewModel)
        section.rows.append(contentsOf: completeDetailsViewModels)
        let bottom = BottomTableViewCellViewModel()
        section.rows.append(bottom)
    }
    
}

// activity list
extension LendingViewModel {
    
    func activityList(_ lendingOverview: GetLendingOverviewResponse, section: inout TableSectionViewModel) {
        
        let kycStatus = lendingOverview.eligibleRequirement?.kycStatus ?? .notStarted
        if self.isKycStatusFailed(kycStatus){
            return
        }
        
        guard let activities = lendingOverview.borrowOverview?.activities, activities.count > 0 else { return }
        
        let header = HeaderTableViewCellViewModel()
        section.rows.append(header)
        
        //let top = TopTableViewCellViewModel()
        //section.rows.append(top)
        
        section.rows.append(SpacerTableViewCellViewModel())
        
        for loanActivity: LoanActivity in activities {
            
            let activityItem = HistoryItemTableViewCellViewModel()
            activityItem.loanActivity = loanActivity
            let amount = loanActivity.amount ?? 0.0

            
            let type: LoanActivity.ModelType = loanActivity.type ?? .cashout
            
            let amt = floor(amount)
            let strAmount = String(format: "$%.1f", amt)
            
            let amountString = strAmount
            //FormatterUtil.shared.currencyFormat(amount, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: false)
            
            
            if(type == .cashout){
                 activityItem.itemTitle = "Cash out"
                 activityItem.amount = String("\(amountString)")
                 activityItem.itemCaption = loanActivity.date ?? ""
            }else{
                 activityItem.itemTitle = type.rawValue
                 activityItem.amount = String("-\(amountString)")
                 activityItem.itemCaption = loanActivity.repaymentDate ?? ""
            }
            
            activityItem.itemTitleStatus = self.getItemTitleStatus(loanActivity: loanActivity)
           
            activityItem.fee = ""
            activityItem.cashDirection = (type == .repayment) ? .debit : .credit
            section.rows.append(activityItem)
        }
        
        section.rows.append(SpacerTableViewCellViewModel())
        
       // let bottom = BottomTableViewCellViewModel()
       // section.rows.append(bottom)
    }
    
    func getItemTitleStatus(loanActivity : LoanActivity?) -> String {
        guard let loanActivity = loanActivity, let type = loanActivity.type, let status = loanActivity.status else { return "" }
              
        var strStatus = ""

        switch status {
            case .credited:
                strStatus = ""
            case .debited:
                strStatus = ""
            case .failed:
                strStatus = "Failed"
            case .unprocessed:
                strStatus = "Unprocessed"
            case .pending, .unsuccessfulAttempt:
                strStatus = "Pending..."
        }
    
        return strStatus
    }
}

// swipe to confirm
extension LendingViewModel {
    func swipeToConfirm(_ lendingOverview: GetLendingOverviewResponse, section: inout TableSectionViewModel) {
        //add condition to check if we should show swipe to confirm
        let swipe = SwipeToConfirmTableViewCellViewModel()
        section.rows.append(swipe)
    }
}

