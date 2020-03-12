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
       
        section.rows.append(IntercomChatTableViewCellViewModel())
        self.addLoanSetting(lendingOverview, section: &section)
        self.addCashoutButton(lendingOverview, section: &section)
        self.addMessageBubble(lendingOverview, section: &section)
        section.rows.append(SpacerTableViewCellViewModel())
        self.completeDetails(lendingOverview, section: &section)
        section.rows.append(SpacerTableViewCellViewModel())
        // actvity
        self.activityList(lendingOverview, section: &section)
        section.rows.append(SpacerTableViewCellViewModel())
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
}

// amount select
extension LendingViewModel {
    
    func addLoanSetting (_ lendingOverview: GetLendingOverviewResponse,  section: inout TableSectionViewModel) {
        // loan control
        if let loanSetting = lendingOverview.loanSetting {
            let amountSelect = AmountSelectTableViewCellViewModel()
            amountSelect.selectedAmountIndex = 0
            amountSelect.buildAvaialbleToWithDraw(low: loanSetting.minimalAmount ?? 100, limit: loanSetting.maximumAmount ?? 200, increment: loanSetting.incrementalAmount ?? 100)
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
        let kycCompleted = isKycStatusSuccess(kycStatus) || isKycStatusFailed(kycStatus)
        
        print(lendingOverview)
        //Check all status
        if hasEmploymentDetail == true,hasBankDetails == true, kycCompleted {
            return
        }
        
        // inprogress status should come too for all the cases
        
         /// **Step-> 1** Employment details*
        if hasEmploymentDetail {
            completed = completed + 1
            let completeDetailsForWork = CompleteDetailsTableViewCellViewModel()
            completeDetailsForWork.type = .workDetails
            if (eligibleRequirement.hasPayCycle ?? false){
                completeDetailsForWork.completionState = .done
                completeDetailsForWork.expanded = false
                completeDetailsViewModels.append(completeDetailsForWork)
            }else if (!(eligibleRequirement.hasPayCycle ?? false) && eligibleRequirement.isReviewingPayCycle ?? false){
               completeDetailsForWork.completionState = .inprogress
               completeDetailsForWork.expanded = true
               completeDetailsViewModels.append(completeDetailsForWork)
            }else if ((eligibleRequirement.hasPayCycle ?? false) && eligibleRequirement.isReviewingPayCycle ?? false){
            completeDetailsForWork.completionState = .inprogress
            completeDetailsForWork.expanded = true
            completeDetailsViewModels.append(completeDetailsForWork)
            }
            else {
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
        
//
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
        
        
          /// **Step-> 3** Enter your bank details*
        if hasEmploymentDetail {
            
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
        
        
          /// **Step-> 4** Verify your identity*
        if self.isKycStatusPending(kycStatus) {
            
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
        
        guard let activities = lendingOverview.borrowOverview?.activities, activities.count > 0 else { return }
        
        let header = HeaderTableViewCellViewModel()
        section.rows.append(header)
        let top = TopTableViewCellViewModel()
        section.rows.append(top)
        
        for loanActivity: LoanActivity in activities {
            let activityItem = HistoryItemTableViewCellViewModel()
            let amount = loanActivity.amount ?? 0.0
            let amountString = FormatterUtil.shared.currencyFormat(amount, symbol: CurrencySymbol.dollar.rawValue, roundDownToNearestDollar: false)
            activityItem.amount = String("\(amountString)")
            activityItem.itemCaption = loanActivity.date ?? ""
            let type: LoanActivity.ModelType = loanActivity.type ?? .cashout
            activityItem.itemTitle = type.rawValue
            activityItem.fee = ""
            activityItem.cashDirection = (type == .repayment) ? .debit : .credit
            section.rows.append(activityItem)
        }
        
        let bottom = BottomTableViewCellViewModel()
        section.rows.append(bottom)
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
