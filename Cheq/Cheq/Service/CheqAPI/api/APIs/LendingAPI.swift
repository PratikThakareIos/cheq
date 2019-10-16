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
    open class func getBorrowPreview(amount: Double, completion: @escaping ((_ data: GetLoanPreviewResponse?,_ error: Error?) -> Void)) {
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
  "cashoutDate" : "cashoutDate",
  "loanAgreement" : "loanAgreement",
  "repaymentDate" : "repaymentDate",
  "fee" : 6.027456183070403
}}]
     
     - parameter amount: (path)  

     - returns: RequestBuilder<GetLoanPreviewResponse> 
     */
    open class func getBorrowPreviewWithRequestBuilder(amount: Double) -> RequestBuilder<GetLoanPreviewResponse> {
        var path = "/v1/Lending/borrow/preview/{amount}"
        let amountPreEscape = "\(amount)"
        let amountPostEscape = amountPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{amount}", with: amountPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetLoanPreviewResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

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
  "decline" : {
    "declineDescription" : "declineDescription",
    "declineReason" : "None"
  },
  "eligibleRequirement" : {
    "kycStatus" : "NotStarted",
    "hasBankAccountDetail" : true,
    "hasEmploymentDetail" : true
  },
  "loanSetting" : {
    "maximumAmount" : 0,
    "minimalAmount" : 6,
    "incrementalAmount" : 1
  },
  "borrowOverview" : {
    "canUploadTimesheet" : true,
    "activities" : [ {
      "date" : "date",
      "amount" : 5.637376656633329,
      "type" : "Cashout"
    }, {
      "date" : "date",
      "amount" : 5.637376656633329,
      "type" : "Cashout"
    } ],
    "availableCashoutAmount" : 5.962133916683182
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

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postTime(request: PostWorksheetRequest? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        postTimeWithRequestBuilder(request: request).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - POST /v1/Lending/timesheets/geolocation
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func postTimeWithRequestBuilder(request: PostWorksheetRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1/Lending/timesheets/geolocation"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
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

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func resolveIdentityConflict(completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        resolveIdentityConflictWithRequestBuilder().execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - PUT /v1/Lending/identityconflict/resolve
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer

     - returns: RequestBuilder<Void> 
     */
    open class func resolveIdentityConflictWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/v1/Lending/identityconflict/resolve"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
