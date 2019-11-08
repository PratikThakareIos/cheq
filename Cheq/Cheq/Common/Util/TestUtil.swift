//
//  TestUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 1/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit
import MobileSDK
import PromiseKit

class TestUtil {
    static let shared = TestUtil()
    private init() {}
    
    let addressSuffix = ["Magaret Street, Sydney NSW 2000", "York Street, Sydney NSW 2000"]
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"
    let numbers = "0123456789"
    let suffix = ["gmail.com", "hotmail.com", "facebook.com", "cheq.com.au"]
    
    func randomString(_ length: Int)-> String {
        var result = ""
        for _ in 0..<length {
            result.append(letters.randomElement() ?? "a")
        }
        return result
    }
    
    func randomPhone(_ length: Int)-> String {
        var result = ""
        for _ in 0..<length {
            result.append(numbers.randomElement() ?? "a")
        }
        return result
    }
    
    func randomAddress()-> String {
        let addrSuffix = addressSuffix.randomElement() ?? addressSuffix[0]
        let streetNum = randomPhone(3)
        return String("\(streetNum) \(addrSuffix)")
    }
    
    func randomEmail()-> String {
        let randomPrefix = randomString(10)
        let randomSuffix = "testcheq.com.au"
        return "\(randomPrefix)@\(randomSuffix)"
    }
    
    func emailVerificationCode()-> String {
        return "111111"
    }
    
    func randomPassword()-> String {
        return randomString(12)
    }
    
    func putEmployerDetailsReq()-> PutUserEmployerRequest {
        
        let employerReq = PutUserEmployerRequest(employerName: TestUtil.shared.testEmployerName(), employmentType: .fulltime, address: TestUtil.shared.testEmployeAddress(), noFixedAddress: false, latitude: -33.8653556, longitude: 151.205377, postCode: TestUtil.shared.testPostcode(), state: TestUtil.shared.testState().rawValue, country: TestUtil.shared.testCountry())
        return employerReq
    }
    
    func putUserDetailsReq()-> PutUserDetailRequest {
        
        let testUtil = TestUtil.shared
        let req = PutUserDetailRequest(firstName: testUtil.testFirstname(), lastName: testUtil.testLastname(), ageRange: testUtil.testAgeRange(), mobile: testUtil.testMobile(), state: testUtil.testPutUserState())
        return req
    }
    
    func testDynamicInputs()->[DynamicFormInput] {
        let usernameInput = DynamicFormInput(type: .text, title: "Username")
        let password = DynamicFormInput(type: .password, title: "Password")
        let checkBox = DynamicFormInput(type: .checkBox, title: "isOwner")
        let confirm = DynamicFormInput(type: .confirmButton, title: "Confirm")
        let spacer = DynamicFormInput(type: .spacer, title: "spacer")
        return [usernameInput, password, checkBox, confirm, spacer]
    }
    
    func weakPassword()-> String {
        return "12345678"
    }
    
    // TODO
    func validEmail()-> Bool {
        return true
    }
    
    func testEmail()-> String {
        return "xuwei@cheq.com.au"
    }
    
    func testPass()-> String {
        return "cheqPass808"
    }
    
    func testAddress()-> String {
        return String(describing: "60 \(addressSuffix[0])")
    }
    
    func testMobile()-> String {
        return "0405090733"
    }
    
    func testFirstname()-> String {
        return "Bob"
    }
    
    func testLastname()-> String {
        return "Builder"
    }
    
    func testBirthday()-> Date {
        return 25.years.earlier
    }
    
    func testAgeRange()-> PutUserDetailRequest.AgeRange {
        return .from25To34
    }
    
    func dobFormatStyle()->String {
        return "dd/MM/yyyy"
    }
    
    func testEmployerName()-> String {
        return "Cheq Pty Ltd"
    }
    
    func testEmploymentType()-> PutUserEmployerRequest.EmploymentType {
        return .fulltime
    }
    
    func testEmployeAddress()-> String {
        return "60 Margaret Street, Sydney 2000 NSW"
    }
    
    func testPostcode()-> String {
        return "2000"
    }
    
    func testState()->  PutUserOnfidoKycRequest.State {
        return .nsw
    }
    
    func testPutUserState()-> PutUserDetailRequest.State {
        return .nsw
    }
    
    func testCountry()-> String {
        return "Australia"
    }
    
    func randomAmount()->Double {
        return Double.random(in: -100...100)
    }
    
    func randomBillAmount()->Double {
        return Double.random(in: -1000...1000)
    }
    
    func randomDate()-> Date {
        let random = Int.random(in: 0...30)
        return random.days.earlier
    }
    
    func randomBool()-> Bool {
        return Bool.random()
    }
    
    func randomLoanActivityType()->LoanActivity.ModelType {
        return randomBool() ? LoanActivity.ModelType.cashout : LoanActivity.ModelType.repayment
    }
    
    func testLoanActivities()->[LoanActivity] {
        var dates = [Date(), 1.days.earlier, 2.days.earlier, 2.days.earlier, 3.days.earlier]
        var loanActivities = [LoanActivity]()
        for _ in 0..<10 {
            let loanActivity = LoanActivity(amount: randomAmount(), date: FormatterUtil.shared.defaultDateFormatter().string(from: randomDate()), type: randomLoanActivityType())
            loanActivities.append(loanActivity)
        }
        return loanActivities
    }
    
    func testLoanAgreement()->String {
        return """
        A loan agreement is an agreement between two parties whereby one party (usually referred to as the ‘lender’) agrees to provide a loan to the other party (usually referred to as the ‘borrower’).
        
        Downloading your free legal document is easy. Fill in the required information and your document will be emailed to you instantly.
        
        You will need the following information to generate your document:
        
        name of the lender and borrower; and
        address of the lender and borrower.
        """
    }
    
    func testLoanPreview()->GetLoanPreviewResponse {
        let amount = Double(AppData.shared.amountSelected)
        let fee = Double(AppData.shared.loanFee)
        let formatter = FormatterUtil.shared.defaultDateFormatter()
        let loanPreview = GetLoanPreviewResponse(amount: amount, fee: fee, cashoutDate: formatter.string(from: Date()), repaymentDate: formatter.string(from: 7.days.later), loanAgreement: testLoanAgreement(), directDebitAgreement: testLoanAgreement())
        return loanPreview
    }
    
    fileprivate func slimTransactionCategoryCode(_ code: GetUpcomingBillResponse.CategoryCode)->SlimTransactionResponse.CategoryCode {
        let slimTransactionCategoryCode = SlimTransactionResponse.CategoryCode(rawValue: code.rawValue) ?? .benefits
        return slimTransactionCategoryCode
    }
    
    fileprivate func randomCategoryCode()->GetUpcomingBillResponse.CategoryCode {
        let categoryCodes: [GetUpcomingBillResponse.CategoryCode] = [.benefits, .bills, .employmentIncome, .entertainment, .financialServices, .fitness, .groceries, .health, .household, .ondemandIncome, .otherDeposit, .others, .restaurantsAndCafes, .secondaryIncome, .shopping, .tobaccoAndAlcohol, .transport, .travel, .workAndEducation]
        return categoryCodes.randomElement() ?? .bills
    }
    
    fileprivate func randomRecurringFrequency()->GetUpcomingBillResponse.RecurringFrequency {
        let recurringFreqencyTypes: [GetUpcomingBillResponse.RecurringFrequency] = [.bimonthly, .fortnightly, .halfYearly, .monthly, .quarterly, .weekly, .yearly]
        return recurringFreqencyTypes.randomElement() ?? .weekly
    }
    
    fileprivate func upcomingBillResponses()-> [GetUpcomingBillResponse] {
        var result = [GetUpcomingBillResponse]()
        for _ in 1...20 {
            let code = randomCategoryCode()
            let getUpcomingBillResponse = GetUpcomingBillResponse(_description: TestUtil.shared.randomString(100), merchant: TestUtil.shared.randomString(30), merchantLogoUrl: "", amount: TestUtil.shared.randomBillAmount(), dueDate: FormatterUtil.shared.simpleDateFormatter().string(from: 5.days.later), daysToDueDate: 5, recurringFrequency: randomRecurringFrequency(), categoryCode: code, categoryTitle: code.rawValue)
            result.append(getUpcomingBillResponse)
        }
        return result
    }
    
    func topCategoriesAmount()->[CategoryAmountStatResponse] {
        let range = 0..<5
        var result = [CategoryAmountStatResponse]()
        var randomAmount: [Double] = []
        var totalAmount: Double = 0.0
        for _ in range {
            randomAmount.append(TestUtil.shared.randomBillAmount())
        }
        
        totalAmount = randomAmount.reduce(0, +)
        
        
        for k in range {
            let code = DataHelperUtil.shared.categoryAmountStateCode(randomCategoryCode())
            let categoryAmountStateResponse = CategoryAmountStatResponse(categoryId: Int.random(in: 1...10000), categoryTitle: code.rawValue, categoryCode: code, categoryAmount: randomAmount[k], totalAmount: totalAmount)
            result.append(categoryAmountStateResponse)
        }
        return result
    }
    
    func randomRemoteBank()-> RemoteBank {
        var remoteBanks = [RemoteBank]()
        let commnWealthBank = RemoteBank(financialInstitutionId: 236, name: "Commonwealth Bank", alias: "CBA", logoUrl: "https://cheq-financialinstitution-logos.s3-ap-southeast-2.amazonaws.com/236-www-commbank-com-au.png", order: 1)
        remoteBanks.append(commnWealthBank)
        let westpac = RemoteBank(financialInstitutionId: 237, name: "Westpac", alias: "WBC", logoUrl: "https://cheq-financialinstitution-logos.s3-ap-southeast-2.amazonaws.com/237-www-westpac-com-au.png", order: 2)
        remoteBanks.append(westpac)
        let anz = RemoteBank(financialInstitutionId: 240, name: "ANZ", alias: "ANZ", logoUrl: "https://cheq-financialinstitution-logos.s3-ap-southeast-2.amazonaws.com/240-www-anz-com-au.png", order: 3)
        remoteBanks.append(anz)
        let nab = RemoteBank(financialInstitutionId: 238, name: "NAB", alias: "NAB", logoUrl: "https://cheq-financialinstitution-logos.s3-ap-southeast-2.amazonaws.com/238-www-nab-com-au.png", order: 4)
        remoteBanks.append(nab)
        let stGeorge = RemoteBank(financialInstitutionId: 239, name: "St.George Bank", alias: "SGB STG", logoUrl: "https://cheq-financialinstitution-logos.s3-ap-southeast-2.amazonaws.com/239-www-stgeorge-com-au.png", order: 5)
        remoteBanks.append(stGeorge)
        let bankWest = RemoteBank(financialInstitutionId: 247, name: "BankWest", alias: "BWA", logoUrl: "https://cheq-financialinstitution-logos.s3-ap-southeast-2.amazonaws.com/247-www-bankwest-com-au.png", order: 6)
        remoteBanks.append(bankWest)
        return remoteBanks.randomElement() ?? commnWealthBank
    }
    
    func randomTransactions()->[SlimTransactionResponse] {
        var transactions = [SlimTransactionResponse]()
        for _ in 0...4 {
            let code = self.slimTransactionCategoryCode(self.randomCategoryCode())
            let dateString = FormatterUtil.shared.simpleDateFormatter().string(from: TestUtil.shared.randomDate())
            let randomBank = TestUtil.shared.randomRemoteBank()
            let slimTransactionResponse = SlimTransactionResponse(_description: TestUtil.shared.randomString(100), amount: TestUtil.shared.randomAmount(), date: dateString, categoryTitle: code.rawValue, categoryCode: code, merchant: TestUtil.shared.randomString(30), merchantLogoUrl: "", financialAccountName: randomBank.name, financialInstitutionLogoUrl: randomBank.logoUrl)
            transactions.append(slimTransactionResponse)
        }
        return transactions
    }
    
    func testSpendingOverview()->GetSpendingOverviewResponse {
        let startDate = FormatterUtil.shared.simpleDateFormatter().string(from: 5.days.later)
        let endDate = FormatterUtil.shared.simpleDateFormatter().string(from: 10.days.later)
        let overviewCard = SpendingOverviewCard(allAccountCashBalance: 1000.0, numberOfDaysTillPayday: 10, payCycleStartDate: startDate, payCycleEndDate: endDate, infoIcon: "")
        let upcomingBillResponses = self.upcomingBillResponses()
        
        let spendingOverview = GetSpendingOverviewResponse(overviewCard: overviewCard, upcomingBills: upcomingBillResponses, topCategoriesAmount: self.topCategoriesAmount(), recentTransactions: self.randomTransactions())
        return spendingOverview
    }
    
    func testLendingOverview()->GetLendingOverviewResponse {
        let loanSetting = LoanSetting(maximumAmount: 200, minimalAmount: 100, incrementalAmount: 100)
        
        let borrowOverview = BorrowOverview(availableCashoutAmount: 200, canUploadTimesheet: false, activities: TestUtil.shared.testLoanActivities())
        
        let eligibleRequirement = EligibleRequirement(hasEmploymentDetail: true, hasBankAccountDetail: true, kycStatus: EligibleRequirement.KycStatus.success)
        
        // ignore decline for now 
        let decline = DeclineViewTestUtil.shared.generateDeclineDetails(DeclineDetail.DeclineReason.creditAssessment)
        
        let repaymentDate = FormatterUtil.shared.userFriendlyDateFormatter().string(from: 7.days.later)
    
        let recentBorrowingSummary = RecentBorrowingSummary(totalCashRequested: 200.0, totalRepaymentAmount: 200.0, totalFees: 10.0, feesPercent: 5, repaymentDate: repaymentDate)
    
        let lendingOverview = GetLendingOverviewResponse(loanSetting: loanSetting, borrowOverview: borrowOverview, recentBorrowings: recentBorrowingSummary, eligibleRequirement: eligibleRequirement, decline: nil)
        return lendingOverview
    }
    
    func loginWithTestAccount()->Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            let email = "dean1@testcheq.com.au"
            let password = "1@aAbc23"
            var loginCredentials = [LoginCredentialType: String]()
            loginCredentials[.email] = email
            loginCredentials[.password] = password
            AuthConfig.shared.activeManager.login(loginCredentials).done { authUser in
                resolver.fulfill(authUser)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    func autoSetupAccount()->Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
            let testBank = "St.George Bank"
            var storedAccounts = [FinancialAccountModel]()
            var loginCredentials = [LoginCredentialType: String]()
            loginCredentials[.email] = TestUtil.shared.randomEmail()
            loginCredentials[.password] = TestUtil.shared.randomPassword()
            AuthConfig.shared.activeManager.register(.socialLoginEmail, credentials: loginCredentials).then { authUser->Promise<Void> in
                return CheqAPIManager.shared.requestEmailVerificationCode()
            }.then { ()->Promise<AuthUser> in
                let verificationCode = TestUtil.shared.emailVerificationCode()
                let req = PutUserSingupVerificationCodeRequest(code: verificationCode)
                return CheqAPIManager.shared.validateEmailVerificationCode(req)
            }.then { authUser->Promise<AuthUser> in
                return AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
            }.then { authUser->Promise<AuthUser> in
                    return CheqAPIManager.shared.putUser(authUser)
            }.then { authUser->Promise<AuthUser> in
                let userDetails = TestUtil.shared.putUserDetailsReq()
                return CheqAPIManager.shared.putUserDetails(userDetails)
            }.then { authUser->Promise<AuthUser> in
                return AuthConfig.shared.activeManager.postNotificationToken(authUser)
            }.then { authUser->Promise<AuthenticationModel> in
                LoggingUtil.shared.cPrint(authUser.authToken() ?? "")
                let msCredential = authUser.msCredential
                return MoneySoftManager.shared.login(msCredential)
            }.then { msAuthModel-> Promise<UserProfileModel> in
                return MoneySoftManager.shared.getProfile()
            }.then { profile->Promise<[FinancialInstitutionModel]> in
                return MoneySoftManager.shared.getInstitutions()
            }.then { institutions-> Promise<Bool> in
                AppData.shared.financialInstitutions = institutions
                let postReq = DataHelperUtil.shared.postFinancialInstitutionsRequest(institutions)
                return CheqAPIManager.shared.postBanks(postReq)
            }.then { success->Promise<InstitutionCredentialsFormModel> in
                let institutions = AppData.shared.financialInstitutions
                let banks: [FinancialInstitutionModel] = institutions
                banks.forEach {
                    let name = $0.name ?? ""
                    LoggingUtil.shared.cPrint(name)
                }
                let selected = banks.first(where: { $0.name == testBank})
                LoggingUtil.shared.cPrint(selected?.name ?? "")
                return MoneySoftManager.shared.getBankSignInForm(selected!)
            }.then { signInForm->Promise<[FinancialAccountLinkModel]> in
                var form = signInForm
                MoneySoftUtil.shared.fillFormWithStGeorgeAccount(&form)
                LoggingUtil.shared.cPrint(form)
                return MoneySoftManager.shared.linkableAccounts(form)
            }.then { linkableAccounts in
                return MoneySoftManager.shared.linkAccounts(linkableAccounts)
            }.then { linkedAccounts in
                return MoneySoftManager.shared.getAccounts()
            }.then { fetchedAccounts  -> Promise<Bool> in
                storedAccounts = fetchedAccounts
                let postFinancialAccountReq = DataHelperUtil.shared.postFinancialAccountsReq(fetchedAccounts)
                return CheqAPIManager.shared.postAccounts(postFinancialAccountReq)
            }.then { succcess -> Promise<[FinancialAccountModel]> in
                let refreshOptions = RefreshAccountOptions()
                refreshOptions.includeTransactions = true
                let enabledAccounts = storedAccounts.filter{ $0.disabled == false}
                return MoneySoftManager.shared.refreshAccounts(enabledAccounts, refreshOptions: refreshOptions)
            }.then { refreshedAccounts->Promise<[FinancialTransactionModel]> in
                storedAccounts = refreshedAccounts
                let transactionFilter = TransactionFilter()
                transactionFilter.fromDate = 90.days.earlier
                transactionFilter.toDate = Date() 
                transactionFilter.count = 1000
                transactionFilter.offset = 0
                return MoneySoftManager.shared.getTransactions(transactionFilter)
            }.then { transactions->Promise<Bool> in
                AppData.shared.financialTransactions = transactions
                let postFinancialTransactionsReq = DataHelperUtil.shared.postFinancialTransactionsReq(transactions)
                return CheqAPIManager.shared.postTransactions(postFinancialTransactionsReq)
            }.then { success->Promise<AuthUser> in
                return AuthConfig.shared.activeManager.getCurrentUser()
            }.then { authUser->Promise<AuthUser> in
                return AuthConfig.shared.activeManager.retrieveAuthToken(authUser)
            }.done { authUser in
                resolver.fulfill(authUser)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
}
