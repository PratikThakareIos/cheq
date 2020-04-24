//
// LendingAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class LendingAPI {
    /**

     - parameter amount: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getBorrowPreview(amount: Int, completion: @escaping ((_ data: GetLendingPreviewResponse?,_ error: Error?) -> Void)) {
        getBorrowPreviewWithRequestBuilder(amount: amount).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Lending/borrow/preview/{amount}
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "directDebitAgreement" : "directDebitAgreement",
  "amount" : 0.8008281904610115,
  "repaymentAmount" : 1.4658129805029452,
  "requestCashoutFeedback" : true,
  "cashoutDate" : "cashoutDate",
  "loanAgreement" : "loanAgreement",
  "installments" : [ {
    "repaymentAmount" : 0.8008281904610115,
    "repaymentDate" : "repaymentDate",
    "fee" : 6.027456183070403
  }, {
    "repaymentAmount" : 0.8008281904610115,
    "repaymentDate" : "repaymentDate",
    "fee" : 6.027456183070403
  } ],
  "repaymentDate" : "repaymentDate",
  "fee" : 6.027456183070403,
  "abstractLoanAgreement" : "abstractLoanAgreement",
  "companyName" : "companyName",
  "acnAbn" : "acnAbn"
}}]
     
     - parameter amount: (path)  

     - returns: RequestBuilder<GetLendingPreviewResponse> 
     */
    open class func getBorrowPreviewWithRequestBuilder(amount: Int) -> RequestBuilder<GetLendingPreviewResponse> {
        var path = "/v1/Lending/borrow/preview/{amount}"
        let amountPreEscape = "\(amount)"
        let amountPostEscape = amountPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{amount}", with: amountPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetLendingPreviewResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getIncomingTransactions(completion: @escaping ((_ data: [SalaryTransactionResponse]?,_ error: Error?) -> Void)) {
        getIncomingTransactionsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Lending/salarytransactions/recent
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example=[ {
  "date" : "2000-01-23T04:56:07.000+00:00",
  "amount" : 6.027456183070403,
  "isSalary" : true,
  "description" : "description",
  "transactionId" : 0
}, {
  "date" : "2000-01-23T04:56:07.000+00:00",
  "amount" : 6.027456183070403,
  "isSalary" : true,
  "description" : "description",
  "transactionId" : 0
} ]}]

     - returns: RequestBuilder<[SalaryTransactionResponse]> 
     */
    open class func getIncomingTransactionsWithRequestBuilder() -> RequestBuilder<[SalaryTransactionResponse]> {
        let path = "/v1/Lending/salarytransactions/recent"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[SalaryTransactionResponse]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getLending(completion: @escaping ((_ data: GetLendingOverviewResponse?,_ error: Error?) -> Void)) {
        getLendingWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Lending/overview
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "recentBorrowings" : {
    "totalFees" : 4.145608029883936,
    "totalRepaymentAmount" : 2.027123023002322,
    "repaymentDate" : "repaymentDate",
    "feesPercent" : 7.386281948385884,
    "totalCashRequested" : 3.616076749251911,
    "hasOverdueLoans" : true
  },
  "decline" : {
    "declineDescription" : "declineDescription",
    "learnMoreLink" : "learnMoreLink",
    "declineTitle" : "declineTitle",
    "declineReason" : "None"
  },
  "eligibleRequirement" : {
    "userAction" : {
      "link" : "link",
      "action" : "ResolveNameConflict",
      "description" : "description",
      "title" : "title"
    },
    "kycStatus" : "Blocked",
    "hasBankAccountDetail" : true,
    "workingLocation" : "FromFixedLocation",
    "hasEmploymentDetail" : true,
    "proofOfAddressStatus" : "Required",
    "isReviewingPayCycle" : true,
    "hasPayCycle" : true,
    "hasProofOfProductivity" : true
  },
  "loanSetting" : {
    "cashoutLimitInformation" : "cashoutLimitInformation",
    "repaymentSettleHours" : 5,
    "maximumAmount" : 0,
    "isFirstTime" : true,
    "minimalAmount" : 6,
    "incrementalAmount" : 1,
    "payCycleStartDate" : "2000-01-23T04:56:07.000+00:00",
    "nextPayDate" : "2000-01-23T04:56:07.000+00:00",
    "cashoutLimitLearnMoreLink" : "cashoutLimitLearnMoreLink"
  },
  "borrowOverview" : {
    "allActivities" : [ {
      "date" : "date",
      "amount" : 2.3021358869347655,
      "notes" : "notes",
      "cheqPayReference" : "cheqPayReference",
      "loanAgreement" : "loanAgreement",
      "fee" : 7.061401241503109,
      "type" : "Cashout",
      "settlementTimingInfo" : "settlementTimingInfo",
      "hasMissedRepayment" : true,
      "directDebitAgreement" : "directDebitAgreement",
      "isOverdue" : true,
      "exactFee" : 9.301444243932576,
      "repaymentDate" : "repaymentDate",
      "status" : "Unprocessed"
    }, {
      "date" : "date",
      "amount" : 2.3021358869347655,
      "notes" : "notes",
      "cheqPayReference" : "cheqPayReference",
      "loanAgreement" : "loanAgreement",
      "fee" : 7.061401241503109,
      "type" : "Cashout",
      "settlementTimingInfo" : "settlementTimingInfo",
      "hasMissedRepayment" : true,
      "directDebitAgreement" : "directDebitAgreement",
      "isOverdue" : true,
      "exactFee" : 9.301444243932576,
      "repaymentDate" : "repaymentDate",
      "status" : "Unprocessed"
    } ],
    "activities" : [ {
      "date" : "date",
      "amount" : 2.3021358869347655,
      "notes" : "notes",
      "cheqPayReference" : "cheqPayReference",
      "loanAgreement" : "loanAgreement",
      "fee" : 7.061401241503109,
      "type" : "Cashout",
      "settlementTimingInfo" : "settlementTimingInfo",
      "hasMissedRepayment" : true,
      "directDebitAgreement" : "directDebitAgreement",
      "isOverdue" : true,
      "exactFee" : 9.301444243932576,
      "repaymentDate" : "repaymentDate",
      "status" : "Unprocessed"
    }, {
      "date" : "date",
      "amount" : 2.3021358869347655,
      "notes" : "notes",
      "cheqPayReference" : "cheqPayReference",
      "loanAgreement" : "loanAgreement",
      "fee" : 7.061401241503109,
      "type" : "Cashout",
      "settlementTimingInfo" : "settlementTimingInfo",
      "hasMissedRepayment" : true,
      "directDebitAgreement" : "directDebitAgreement",
      "isOverdue" : true,
      "exactFee" : 9.301444243932576,
      "repaymentDate" : "repaymentDate",
      "status" : "Unprocessed"
    } ],
    "availableCashoutAmount" : 5.637376656633329
  }
}}]

     - returns: RequestBuilder<GetLendingOverviewResponse> 
     */
    open class func getLendingWithRequestBuilder() -> RequestBuilder<GetLendingOverviewResponse> {
        let path = "/v1/Lending/overview"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetLendingOverviewResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter amount: (query)  (optional)
     - parameter fee: (query)  (optional)
     - parameter date: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getMultiBorrowPreview(amount: String? = nil, fee: String? = nil, date: String? = nil, completion: @escaping ((_ data: GetLendingPreviewResponse?,_ error: Error?) -> Void)) {
        getMultiBorrowPreviewWithRequestBuilder(amount: amount, fee: fee, date: date).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Lending/borrow/preview/repayment/multi
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "directDebitAgreement" : "directDebitAgreement",
  "amount" : 0.8008281904610115,
  "repaymentAmount" : 1.4658129805029452,
  "requestCashoutFeedback" : true,
  "cashoutDate" : "cashoutDate",
  "loanAgreement" : "loanAgreement",
  "installments" : [ {
    "repaymentAmount" : 0.8008281904610115,
    "repaymentDate" : "repaymentDate",
    "fee" : 6.027456183070403
  }, {
    "repaymentAmount" : 0.8008281904610115,
    "repaymentDate" : "repaymentDate",
    "fee" : 6.027456183070403
  } ],
  "repaymentDate" : "repaymentDate",
  "fee" : 6.027456183070403,
  "abstractLoanAgreement" : "abstractLoanAgreement",
  "companyName" : "companyName",
  "acnAbn" : "acnAbn"
}}]
     
     - parameter amount: (query)  (optional)
     - parameter fee: (query)  (optional)
     - parameter date: (query)  (optional)

     - returns: RequestBuilder<GetLendingPreviewResponse> 
     */
    open class func getMultiBorrowPreviewWithRequestBuilder(amount: String? = nil, fee: String? = nil, date: String? = nil) -> RequestBuilder<GetLendingPreviewResponse> {
        let path = "/v1/Lending/borrow/preview/repayment/multi"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "amount": amount, 
            "fee": fee, 
            "date": date
        ])

        let requestBuilder: RequestBuilder<GetLendingPreviewResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter amount: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getRepaymentOptions(amount: Double, completion: @escaping ((_ data: GetRepaymentOptionsResponse?,_ error: Error?) -> Void)) {
        getRepaymentOptionsWithRequestBuilder(amount: amount).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Lending/{amount}/repayments/options
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "multiRepaymentOptions" : [ {
    "installments" : [ {
      "repaymentAmount" : 0.8008281904610115,
      "repaymentDate" : "repaymentDate",
      "fee" : 6.027456183070403
    }, {
      "repaymentAmount" : 0.8008281904610115,
      "repaymentDate" : "repaymentDate",
      "fee" : 6.027456183070403
    } ]
  }, {
    "installments" : [ {
      "repaymentAmount" : 0.8008281904610115,
      "repaymentDate" : "repaymentDate",
      "fee" : 6.027456183070403
    }, {
      "repaymentAmount" : 0.8008281904610115,
      "repaymentDate" : "repaymentDate",
      "fee" : 6.027456183070403
    } ]
  } ],
  "oneTimeRepayment" : {
    "repaymentAmount" : 0.8008281904610115,
    "repaymentDate" : "repaymentDate",
    "fee" : 6.027456183070403
  },
  "multiRepaymentAttention" : "multiRepaymentAttention"
}}]
     
     - parameter amount: (path)  

     - returns: RequestBuilder<GetRepaymentOptionsResponse> 
     */
    open class func getRepaymentOptionsWithRequestBuilder(amount: Double) -> RequestBuilder<GetRepaymentOptionsResponse> {
        var path = "/v1/Lending/{amount}/repayments/options"
        let amountPreEscape = "\(amount)"
        let amountPostEscape = amountPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{amount}", with: amountPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetRepaymentOptionsResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postBorrow(request: PostLoanRequest? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        postBorrowWithRequestBuilder(request: request).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - POST /v1/Lending/borrow
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func postBorrowWithRequestBuilder(request: PostLoanRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1/Lending/borrow"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter salaryTransactions: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postSalaryTransactions(salaryTransactions: PostSalaryTransactionsRequest? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        postSalaryTransactionsWithRequestBuilder(salaryTransactions: salaryTransactions).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - PUT /v1/Lending/salarytransactions
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter salaryTransactions: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func postSalaryTransactionsWithRequestBuilder(salaryTransactions: PostSalaryTransactionsRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1/Lending/salarytransactions"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: salaryTransactions)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putBankAccount(request: PutBankAccountRequest? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        putBankAccountWithRequestBuilder(request: request).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - PUT /v1/Lending/bankaccount
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func putBankAccountWithRequestBuilder(request: PutBankAccountRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1/Lending/bankaccount"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
