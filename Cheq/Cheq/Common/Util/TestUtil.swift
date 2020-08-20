//
//  TestUtil.swift
//  Cheq
//
//  Created by Xuwei Liang on 1/10/19.
//  Copyright © 2019 Cheq. All rights reserved.
//

import UIKit

import PromiseKit
import DateToolsSwift

//import MobileSDK


/**
 TestUtil is a singleton class used across the app for generating **test data** for testing and development phases. Please note that data from **TestUtil** shouldn't be used for production. **TestUtil** encapsulates many test data generating methods thats useful during development phase.
 */
class TestUtil {
    
    /// Singleton instance
    static let shared = TestUtil()
    
    /// Private init to implement Singleton
    private init() {}
    
    /// Address suffix for test data use
    let addressSuffix = ["Magaret Street, Sydney NSW 2000", "York Street, Sydney NSW 2000"]
    
    /// Array for generating random String
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-"
    
    /// Array of numbers for generating number combinations
    let numbers = "0123456789"
    
    /// Array of email suffixes for random email
    let suffix = ["gmail.com", "hotmail.com", "facebook.com", "cheq.com.au"]
    
    /// Helper method for generating randomString of a given length
    func randomString(_ length: Int)-> String {
        var result = ""
        for _ in 0..<length {
            result.append(letters.randomElement() ?? "a")
        }
        return result
    }
    
    /// Helper method to generate random mobile phone number of a given length
    func randomPhone(_ length: Int)-> String {
        var result = ""
        for _ in 0..<length {
            result.append(numbers.randomElement() ?? "0")
        }
        return result
    }
    
    /// Helper method to generate a random residential address
    func randomAddress()-> String {
        let addrSuffix = addressSuffix.randomElement() ?? addressSuffix[0]
        let streetNum = randomPhone(3)
        return String("\(streetNum) \(addrSuffix)")
    }
    
    /// Random email generator
    func randomEmail()-> String {
        let randomPrefix = randomString(10)
        let randomSuffix = "testcheq.com.au"
        return "\(randomPrefix)@\(randomSuffix)"
    }
    
    /// If the test email is suffix is **testcheq.com.au**, then with a backend hack in development environment, the verification code will always be **111111**
    func emailVerificationCode()-> String {
        return "111111"
    }
    
    /// Generating a random password
    func randomPassword()-> String {
        return randomString(12)
    }
    
    /// Generate employer details **Put** request
    func putEmployerDetailsReq()-> PutUserEmployerRequest {
        ///Request used earlier
        /*
        let employerReq = PutUserEmployerRequest(employerName: TestUtil.shared.testEmployerName(), employmentType: .fulltime, workingLocation: .fromFixedLocation, latitude:  -33.8653556, longitude:  151.205377, address: TestUtil.shared.testEmployeAddress(), state:"", country: TestUtil.shared.testCountry(), postCode: TestUtil.shared.testPostcode())
        */
        ///current request
        
        let employerReq = PutUserEmployerRequest(employerName: TestUtil.shared.testEmployerName(), employmentType: .fulltime, address: TestUtil.shared.testEmployeAddress())
        
        return employerReq
    }
    
    /// Helper method for **PUT** user details request
    func putUserDetailsReq()-> PutUserDetailRequest {
        
        let testUtil = TestUtil.shared
        let req = PutUserDetailRequest(firstName: testUtil.testFirstname(), lastName: testUtil.testLastname(), mobile: testUtil.testMobile())
        return req
    }
    
    /// Helper method for generating a list of **DynmaicFormInput** to test **DynamicFormViewController**
    func testDynamicInputs()->[DynamicFormInput] {
        let usernameInput = DynamicFormInput(type: .text, title: "Username")
        let password = DynamicFormInput(type: .password, title: "Password")
        let checkBox = DynamicFormInput(type: .checkBox, title: "isOwner")
        let confirm = DynamicFormInput(type: .confirmButton, title: "Confirm")
        let spacer = DynamicFormInput(type: .spacer, title: "spacer")
        return [usernameInput, password, checkBox, confirm, spacer]
    }
    
    /// Helper to generate weak password
    func weakPassword()-> String {
        return "12345678"
    }
    
    func validEmail()-> Bool {
        return true
    }
    
    /// Helper method returning a test email. In some test cases, we want to stick with using the same email. e.g. Login to perform linking bank accounts.
    func testEmail()-> String {
        return "xuwei@cheq.com.au"
    }
    
    /// Helper method for getting a password. Sometimes, we want to always use the same password for testing with registered account. e.g. Login to perform linking bank accounts.
    func testPass()-> String {
        return "cheqPass808"
    }
    
    /// Helper method to retriev a test address.
    func testAddress()-> String {
        return String(describing: "60 \(addressSuffix[0])")
    }
    
    /// Helper method to retrieve data to fill in question form
    func testMobile()-> String {
        return "0405090733"
    }
    
    /// Helper method to retrieve data to fill in question form
    func testFirstname()-> String {
        return "Bob"
    }
    
    /// Helper method to retrieve data to fill in question form
    func testLastname()-> String {
        return "Builder"
    }
    
    /// Helper method to retrieve data to fill in question form
    func testBirthday()-> Date {
        return 25.years.earlier
    }
    
    /// retrieve DOB format style for formatting Date to fill in question form
    func dobFormatStyle()->String {
        return "dd/MM/yyyy"
    }
    
    /// Helper method to retrieve data to fill in question form
    func testEmployerName()-> String {
        return "Cheq Pty Ltd"
    }
    
    /// Helper method to retrieve data to fill in question form
    func testEmploymentType()-> PutUserEmployerRequest.EmploymentType {
        return .fulltime
    }
    
    /// Helper method to retrieve data to fill in question form
    func testEmployeAddress()-> String {
        return "60 Margaret Street, Sydney 2000 NSW"
    }
    
    /// Helper method to retrieve data to fill in question form
    func testPostcode()-> String {
        return "2000"
    }
    
    /// Helper method to retrieve data to fill in question form
    func testState(){
       
    }

    /// Helper method to retrieve data to fill in question form
    func testCountry()-> String {
        return "Australia"
    }
    
    /// Helper method to retrievce a random positive amount
    func randomPositiveAmount()->Double {
        return Double.random(in: 0...1000)
    }
    
    /// Helper method to retrievce a random signed amount. Can be negative or positive.
    func randomAmount()->Double {
        return Double.random(in: -100...100)
    }
    
    /// Helper method to retrievce a random int amount. Can be negative or positive.
    func randomIntAmount()->Int {
        return Int.random(in: -100...100)
    }
    
    /// Helper method to retrievce a random Double amount. Can be negative or positive.
    func randomBillAmount()->Double {
        return Double.random(in: -1000...1000)
    }
    
    /// Helper method for creating a random past date
    func randomDate()-> Date {
        let random = Int.random(in: 0...30)
        return random.days.earlier
    }
    
    /// Giving back a random Boolean value
    func randomBool()-> Bool {
        return Bool.random()
    }
    
    /// Helper method to return a random **LoanActivity.ModelType**
    func randomLoanActivityType()->LoanActivity.ModelType {
        return randomBool() ? LoanActivity.ModelType.cashout : LoanActivity.ModelType.repayment
    }
    
    /// Generate a list of LoanActivity to test UI for Lending screen
    func testLoanActivities()->[LoanActivity] {
        _ = [Date(), 1.days.earlier, 2.days.earlier, 2.days.earlier, 3.days.earlier]
        var loanActivities = [LoanActivity]()
        for _ in 0..<10 {
            
         let loanActivity = LoanActivity.init(amount: randomAmount(), fee: 5.0, exactFee: 2.0, date: FormatterUtil.shared.defaultDateFormatter().string(from: randomDate()), cheqPayReference: "", type: randomLoanActivityType(), status: .credited, hasMissedRepayment: false, isOverdue: false, loanAgreement: "", directDebitAgreement: "", repaymentDate: FormatterUtil.shared.defaultDateFormatter().string(from: randomDate()), notes: "", settlementTimingInfo: "")
            
//            let loanActivity = LoanActivity(amount: randomAmount(), fee: 5.0, date: FormatterUtil.shared.defaultDateFormatter().string(from: randomDate()), cheqPayReference: "", type: randomLoanActivityType(), status: .credited, loanAgreement: "", directDebitAgreement: "", notes: "", repaymentDate: FormatterUtil.shared.defaultDateFormatter().string(from: randomDate()))
//
                
              //  LoanActivity(amount: randomAmount(), fee: 5.0, date: FormatterUtil.shared.defaultDateFormatter().string(from: randomDate()), type: randomLoanActivityType())
            loanActivities.append(loanActivity)
        }
        return loanActivities
    }
    
    /// Generate a dummy Loan Agreement text
    func testLoanAgreement()->String {
        return """
        A loan agreement is an agreement between two parties whereby one party (usually referred to as the ‘lender’) agrees to provide a loan to the other party (usually referred to as the ‘borrower’).
        
        Downloading your free legal document is easy. Fill in the required information and your document will be emailed to you instantly.
        
        You will need the following information to generate your document:
        
        name of the lender and borrower; and
        address of the lender and borrower.
        """
    }
    
    /**
     Generate a mock **GetLendingPreviewResponse**
     */
    func testLoanPreview()->GetLendingPreviewResponse {
        let amount = Double(AppData.shared.amountSelected) ?? 0.0
        let fee = Double(AppData.shared.loanFee)
        let formatter = FormatterUtil.shared.defaultDateFormatter()
                
        let loanPreview = GetLendingPreviewResponse(amount: amount, fee: fee, repaymentAmount: 200.0, cashoutDate: formatter.string(from: Date()), repaymentDate: formatter.string(from: 7.days.later), abstractLoanAgreement: testLoanAgreement(), loanAgreement: testLoanAgreement(), directDebitAgreement: testLoanAgreement(), companyName: "Cheq Pty Ltd", acnAbn:  "1234567890",requestCashoutFeedback: false, installments: [InstallmentDetail]())
        
        return loanPreview
    }
    
    /**
     Convert data types from **GetUpcomingBillResponse.CategoryCode** to **SlimTransactionResponse.CategoryCode**. This shouldn't be neccessary once Swagger definition has consolidate **CategoryCode**.
     */
    fileprivate func slimTransactionCategoryCode(_ code: GetUpcomingBillResponse.CategoryCode)->SlimTransactionResponse.CategoryCode {
        let slimTransactionCategoryCode = SlimTransactionResponse.CategoryCode(rawValue: code.rawValue) ?? .benefits
        return slimTransactionCategoryCode
    }
    
    /// Helper method to retrieve random CategoryCode, this is useful for testing UI
    fileprivate func randomCategoryCode()->GetUpcomingBillResponse.CategoryCode {
        let categoryCodes: [GetUpcomingBillResponse.CategoryCode] = [.benefits, .bills, .employmentIncome, .entertainment, .financialServices, .fitness, .groceries, .health, .household, .ondemandIncome, .otherDeposit, .others, .restaurantsAndCafes, .secondaryIncome, .shopping, .tobaccoAndAlcohol, .transport, .travel, .workAndEducation]
        return categoryCodes.randomElement() ?? .bills
    }
    
    /// Helper method for random recurring frequency
    fileprivate func randomRecurringFrequency()->GetUpcomingBillResponse.RecurringFrequency {
        let recurringFreqencyTypes: [GetUpcomingBillResponse.RecurringFrequency] = [.bimonthly, .fortnightly, .halfYearly, .monthly, .quarterly, .weekly, .yearly]
        return recurringFreqencyTypes.randomElement() ?? .weekly
    }
     
    /// Helper method to generate a list of **GetUpcomingBillResponse**
    fileprivate func upcomingBillResponses()-> [GetUpcomingBillResponse] {
        var result = [GetUpcomingBillResponse]()
        for _ in 1...20 {
            let code = randomCategoryCode()
            let getUpcomingBillResponse = GetUpcomingBillResponse(_description: TestUtil.shared.randomString(100), merchant: TestUtil.shared.randomString(30), merchantLogoUrl: "", amount: TestUtil.shared.randomBillAmount(), dueDate: FormatterUtil.shared.simpleDateFormatter().string(from: 5.days.later), daysToDueDate: 5, recurringFrequency: randomRecurringFrequency(), categoryCode: code, categoryTitle: code.rawValue)
            result.append(getUpcomingBillResponse)
        }
        return result
    }
    
    /// Helper method to generate a list of **CategoryAmountStatResponse**
    func topCategoriesAmount(_ numOfItems: Int)->[CategoryAmountStatResponse] {
        let range = 0..<numOfItems
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
    
    /// Helper method to generate random **RemoteBank**
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
    
    /// Helper method to generate **SlimTransactionResponse** for testing UI. Takes **numberOfItems** as the amount parameter to generate.
    func randomTransactions(_ numberOfItems: Int)->[SlimTransactionResponse] {
        var transactions = [SlimTransactionResponse]()
        for _ in 0..<numberOfItems {
            let code = self.slimTransactionCategoryCode(self.randomCategoryCode())
            let dateString = FormatterUtil.shared.simpleDateFormatter().string(from: TestUtil.shared.randomDate())
            let randomBank = TestUtil.shared.randomRemoteBank()
            let slimTransactionResponse = SlimTransactionResponse(_description: TestUtil.shared.randomString(100),
                                                                  amount: TestUtil.shared.randomAmount(),
                                                                  date: dateString,
                                                                  categoryTitle: code.rawValue,
                                                                  categoryCode: code,
                                                                  merchant: TestUtil.shared.randomString(30),
                                                                  merchantLogoUrl: "",
                                                                  financialAccountName: randomBank.name,
                                                                  financialInstitutionLogoUrl: randomBank.logoUrl,
                                                                  financialInstitutionId: "")
            transactions.append(slimTransactionResponse)
        }
        return transactions
    }
    
    /// Helper method to generate a list of **MonthAmountStatResponse** for testing UI.
    func testMonthAmountStatResponse()->[MonthAmountStatResponse] {
        var result = [MonthAmountStatResponse]()
        let months = [ FormatterUtil.shared.monthFromDate(2.months.earlier),
                       FormatterUtil.shared.monthFromDate(1.months.earlier),
                       FormatterUtil.shared.monthFromDate(Date()),
                       FormatterUtil.shared.monthFromDate(1.months.later)]
        for i in 0...3 {
            let monthAmountStatResponse = MonthAmountStatResponse(amount: randomPositiveAmount(), month: months[i])
            result.append(monthAmountStatResponse)
        }
        return result
    }
     
    /// Helper method to generate a list of **DailyTransactionsResponse**
    func testDailTransactions()->[DailyTransactionsResponse] {
        var transactions = [DailyTransactionsResponse]()
        for _ in 0...20 {
            let dateString = FormatterUtil.shared.simpleDateFormatter().string(from: randomDate())
            let transaction = DailyTransactionsResponse(date: dateString, transactions: randomTransactions(20))
            transactions.append(transaction)
        }
        return transactions
    }
    
    /// Helper method for **GetSpendingSpecificCategoryResponse** to test during development
    func testSpendingCategoryById()->GetSpendingSpecificCategoryResponse {
        let monthAmountStats = testMonthAmountStatResponse()
        let response = GetSpendingSpecificCategoryResponse(monthAmountStats: monthAmountStats, dailyTransactions: testDailTransactions())
        return response
    }
    
    /// Helper method for **GetSpendingCategoryResponse** to test during development
    func testSpendingCategories()->GetSpendingCategoryResponse {
        let monthAmountStats = testMonthAmountStatResponse()
        let response = GetSpendingCategoryResponse(monthAmountStats: monthAmountStats, categoryAmountStats: topCategoriesAmount(19))
        return response
    }
    
    /// Helper method for **GetSpendingOverviewResponse** to test during development
    func testSpendingOverview()->GetSpendingOverviewResponse {
        let startDate = FormatterUtil.shared.simpleDateFormatter().string(from: 5.days.later)
        let endDate = FormatterUtil.shared.simpleDateFormatter().string(from: 10.days.later)
        let overviewCard = SpendingOverviewCard(allAccountCashBalance: 1000.0, numberOfDaysTillPayday: 10, payCycleStartDate: startDate, payCycleEndDate: endDate, infoIcon: "")
        let upcomingBillResponses = self.upcomingBillResponses()

        let spendingOverview = GetSpendingOverviewResponse(lastSuccessfulUpdatedAtUtc: "",currentDateTimeUtc : "",overviewCard: overviewCard, upcomingBills: upcomingBillResponses, topCategoriesAmount: self.topCategoriesAmount(5), recentTransactions: self.randomTransactions(5))
        return spendingOverview
    }
    
    /// Helper method for **GetUserBudgetResponse** to test during development
    func testGetBudgets()->GetUserBudgetResponse {
        let startDate = 7.days.later
        let startDateString = FormatterUtil.shared.simpleDateFormatter().string(from: startDate)
        return GetUserBudgetResponse(startDate: startDateString, recurringFrequency: "", requireSetupProcess: true, totalBudget: 1000.0, totalSpending: 900.0, userBudgets: TestUtil.shared.testUserBudgets())
    }
    
    /// Helper method for list **UserBudget**
    func testUserBudgets()->[UserBudget] {
        var results = [UserBudget]()
        for _ in 0...20 {
            let randomCategory = randomCategoryCode()
            let code = DataHelperUtil.shared.categoryAmountStateCode(randomCategory)
            let userBudget = UserBudget(_id: Int.random(in: 0...10000), categoryTitle: code.rawValue, categoryCode: code.rawValue, estimatedBudget: randomAmount(), actualSpending: randomIntAmount(), hide: true)
            results.append(userBudget)
        }
        return results
    }
    
    /// Helper method for building a mock **GetLendingOverviewResponse**
    func testLendingOverview()->GetLendingOverviewResponse {
        
        
        let loanSetting = LoanSetting(maximumAmount: 200, minimalAmount: 100, incrementalAmount: 100, isFirstTime: true, payCycleStartDate: nil, nextPayDate: nil, repaymentSettleHours: nil, cashoutLimitInformation: "", cashoutLimitLearnMoreLink: "")
       
        // let loanSetting = LoanSetting(maximumAmount: 200, minimalAmount: 100, incrementalAmount: 100)
        let loanActivities = [LoanActivity]()
        let borrowOverview = BorrowOverview(availableCashoutAmount: 200, activities: TestUtil.shared.testLoanActivities(), allActivities: loanActivities)
        
        let eligibleRequirement = EligibleRequirement(hasEmploymentDetail: true, hasPayCycle: true, isReviewingPayCycle: true, hasProofOfProductivity: true, workingLocation: .fromMultipleLocations, userAction: .none, hasBankAccountDetail: true, kycStatus: EligibleRequirement.KycStatus.success, proofOfAddressStatus: .success)
        
        // ignore decline for now
        let decline = DeclineViewTestUtil.shared.generateDeclineDetails(DeclineDetail.DeclineReason.creditAssessment)
        
        let repaymentDate = FormatterUtil.shared.userFriendlyDateFormatter().string(from: 7.days.later)
    
        let recentBorrowingSummary = RecentBorrowingSummary(totalCashRequested: 200.0, totalRepaymentAmount: 200.0, totalFees: 10.0, feesPercent: 5.0, repaymentDate: repaymentDate, hasOverdueLoans: true)
        
        let lendingOverview = GetLendingOverviewResponse(loanSetting: loanSetting, borrowOverview: borrowOverview, recentBorrowings: recentBorrowingSummary, eligibleRequirement: eligibleRequirement, decline: nil)
        return lendingOverview
    }
    
    /**
    Sometimes we want to test UI flow that requires logged in authToken. This method is for assisting the automation of logging in programmatically with test account, so that the code can jump into the part where we need the authUser with authToken to start testing.
     */
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
    
    /**
     This is a helper method to automatically register a new user for cheq and go through a lot of the tedious steps required during onboard. So that developer can jump into testing linking of bank with MoneySoft SDK quickly.
     */
    func autoSetupRegisteredCheqAccount()->Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
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
            }.done { authUser in
                resolver.fulfill(authUser)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
    
    /**
     Similar to the above 2 method. Using PromiseKit to automate the setting up of data so that we can jump into the testing of in progress work.
     */
    func autoSetupAccount()->Promise<AuthUser> {
        return Promise<AuthUser>() { resolver in
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
            }.done { authUser in
                resolver.fulfill(authUser)
            }.catch { err in
                resolver.reject(err)
            }
        }
    }
}
