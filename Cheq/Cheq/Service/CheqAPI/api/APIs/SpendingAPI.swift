//
// SpendingAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class SpendingAPI {
    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSpendingAllTransactions(completion: @escaping ((_ data: [DailyTransactionsResponse]?,_ error: Error?) -> Void)) {
        getSpendingAllTransactionsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Spending/transactions
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example=[ {
  "date" : "date",
  "transactions" : [ {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  }, {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  } ]
}, {
  "date" : "date",
  "transactions" : [ {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  }, {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  } ]
} ]}]

     - returns: RequestBuilder<[DailyTransactionsResponse]> 
     */
    open class func getSpendingAllTransactionsWithRequestBuilder() -> RequestBuilder<[DailyTransactionsResponse]> {
        let path = "/v1/Spending/transactions"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[DailyTransactionsResponse]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSpendingCategoryStats(completion: @escaping ((_ data: GetSpendingCategoryResponse?,_ error: Error?) -> Void)) {
        getSpendingCategoryStatsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Spending/categories
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "categoryAmountStats" : [ {
    "totalAmount" : 7.061401241503109,
    "categoryAmount" : 2.3021358869347655,
    "categoryTitle" : "categoryTitle",
    "categoryCode" : "Benefits",
    "categoryId" : 5
  }, {
    "totalAmount" : 7.061401241503109,
    "categoryAmount" : 2.3021358869347655,
    "categoryTitle" : "categoryTitle",
    "categoryCode" : "Benefits",
    "categoryId" : 5
  } ],
  "monthAmountStats" : [ {
    "amount" : 0.8008281904610115,
    "month" : "month"
  }, {
    "amount" : 0.8008281904610115,
    "month" : "month"
  } ]
}}]

     - returns: RequestBuilder<GetSpendingCategoryResponse> 
     */
    open class func getSpendingCategoryStatsWithRequestBuilder() -> RequestBuilder<GetSpendingCategoryResponse> {
        let path = "/v1/Spending/categories"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetSpendingCategoryResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSpendingOverview(completion: @escaping ((_ data: GetSpendingOverviewResponse?,_ error: Error?) -> Void)) {
        getSpendingOverviewWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Spending/overview
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "recentTransactions" : [ {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  }, {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  } ],
  "upcomingBills" : [ {
    "amount" : 1.4658129805029452,
    "recurringFrequency" : "Weekly",
    "dueDate" : "dueDate",
    "categoryTitle" : "categoryTitle",
    "description" : "description",
    "merchant" : "merchant",
    "daysToDueDate" : 5,
    "merchantLogoUrl" : "merchantLogoUrl",
    "categoryCode" : "Benefits"
  }, {
    "amount" : 1.4658129805029452,
    "recurringFrequency" : "Weekly",
    "dueDate" : "dueDate",
    "categoryTitle" : "categoryTitle",
    "description" : "description",
    "merchant" : "merchant",
    "daysToDueDate" : 5,
    "merchantLogoUrl" : "merchantLogoUrl",
    "categoryCode" : "Benefits"
  } ],
  "currentDateTimeUtc" : "currentDateTimeUtc",
  "lastSuccessfulUpdatedAtUtc" : "lastSuccessfulUpdatedAtUtc",
  "overviewCard" : {
    "infoIcon" : "infoIcon",
    "numberOfDaysTillPayday" : 6,
    "payCycleEndDate" : "payCycleEndDate",
    "allAccountCashBalance" : 0.8008281904610115,
    "payCycleStartDate" : "payCycleStartDate"
  },
  "topCategoriesAmount" : [ {
    "totalAmount" : 7.061401241503109,
    "categoryAmount" : 2.3021358869347655,
    "categoryTitle" : "categoryTitle",
    "categoryCode" : "Benefits",
    "categoryId" : 5
  }, {
    "totalAmount" : 7.061401241503109,
    "categoryAmount" : 2.3021358869347655,
    "categoryTitle" : "categoryTitle",
    "categoryCode" : "Benefits",
    "categoryId" : 5
  } ]
}}]

     - returns: RequestBuilder<GetSpendingOverviewResponse> 
     */
    open class func getSpendingOverviewWithRequestBuilder() -> RequestBuilder<GetSpendingOverviewResponse> {
        let path = "/v1/Spending/overview"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetSpendingOverviewResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSpendingOverviewCategories(completion: @escaping ((_ data: GetSpendingOverviewResponse?,_ error: Error?) -> Void)) {
        getSpendingOverviewCategoriesWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Spending/overview/categories
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "recentTransactions" : [ {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  }, {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  } ],
  "upcomingBills" : [ {
    "amount" : 1.4658129805029452,
    "recurringFrequency" : "Weekly",
    "dueDate" : "dueDate",
    "categoryTitle" : "categoryTitle",
    "description" : "description",
    "merchant" : "merchant",
    "daysToDueDate" : 5,
    "merchantLogoUrl" : "merchantLogoUrl",
    "categoryCode" : "Benefits"
  }, {
    "amount" : 1.4658129805029452,
    "recurringFrequency" : "Weekly",
    "dueDate" : "dueDate",
    "categoryTitle" : "categoryTitle",
    "description" : "description",
    "merchant" : "merchant",
    "daysToDueDate" : 5,
    "merchantLogoUrl" : "merchantLogoUrl",
    "categoryCode" : "Benefits"
  } ],
  "currentDateTimeUtc" : "currentDateTimeUtc",
  "lastSuccessfulUpdatedAtUtc" : "lastSuccessfulUpdatedAtUtc",
  "overviewCard" : {
    "infoIcon" : "infoIcon",
    "numberOfDaysTillPayday" : 6,
    "payCycleEndDate" : "payCycleEndDate",
    "allAccountCashBalance" : 0.8008281904610115,
    "payCycleStartDate" : "payCycleStartDate"
  },
  "topCategoriesAmount" : [ {
    "totalAmount" : 7.061401241503109,
    "categoryAmount" : 2.3021358869347655,
    "categoryTitle" : "categoryTitle",
    "categoryCode" : "Benefits",
    "categoryId" : 5
  }, {
    "totalAmount" : 7.061401241503109,
    "categoryAmount" : 2.3021358869347655,
    "categoryTitle" : "categoryTitle",
    "categoryCode" : "Benefits",
    "categoryId" : 5
  } ]
}}]

     - returns: RequestBuilder<GetSpendingOverviewResponse> 
     */
    open class func getSpendingOverviewCategoriesWithRequestBuilder() -> RequestBuilder<GetSpendingOverviewResponse> {
        let path = "/v1/Spending/overview/categories"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetSpendingOverviewResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSpendingOverviewTransactions(completion: @escaping ((_ data: GetSpendingOverviewResponse?,_ error: Error?) -> Void)) {
        getSpendingOverviewTransactionsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Spending/overview/transactions
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "recentTransactions" : [ {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  }, {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  } ],
  "upcomingBills" : [ {
    "amount" : 1.4658129805029452,
    "recurringFrequency" : "Weekly",
    "dueDate" : "dueDate",
    "categoryTitle" : "categoryTitle",
    "description" : "description",
    "merchant" : "merchant",
    "daysToDueDate" : 5,
    "merchantLogoUrl" : "merchantLogoUrl",
    "categoryCode" : "Benefits"
  }, {
    "amount" : 1.4658129805029452,
    "recurringFrequency" : "Weekly",
    "dueDate" : "dueDate",
    "categoryTitle" : "categoryTitle",
    "description" : "description",
    "merchant" : "merchant",
    "daysToDueDate" : 5,
    "merchantLogoUrl" : "merchantLogoUrl",
    "categoryCode" : "Benefits"
  } ],
  "currentDateTimeUtc" : "currentDateTimeUtc",
  "lastSuccessfulUpdatedAtUtc" : "lastSuccessfulUpdatedAtUtc",
  "overviewCard" : {
    "infoIcon" : "infoIcon",
    "numberOfDaysTillPayday" : 6,
    "payCycleEndDate" : "payCycleEndDate",
    "allAccountCashBalance" : 0.8008281904610115,
    "payCycleStartDate" : "payCycleStartDate"
  },
  "topCategoriesAmount" : [ {
    "totalAmount" : 7.061401241503109,
    "categoryAmount" : 2.3021358869347655,
    "categoryTitle" : "categoryTitle",
    "categoryCode" : "Benefits",
    "categoryId" : 5
  }, {
    "totalAmount" : 7.061401241503109,
    "categoryAmount" : 2.3021358869347655,
    "categoryTitle" : "categoryTitle",
    "categoryCode" : "Benefits",
    "categoryId" : 5
  } ]
}}]

     - returns: RequestBuilder<GetSpendingOverviewResponse> 
     */
    open class func getSpendingOverviewTransactionsWithRequestBuilder() -> RequestBuilder<GetSpendingOverviewResponse> {
        let path = "/v1/Spending/overview/transactions"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetSpendingOverviewResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSpendingOverviewUpcomingBills(completion: @escaping ((_ data: GetSpendingOverviewResponse?,_ error: Error?) -> Void)) {
        getSpendingOverviewUpcomingBillsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Spending/overview/upcomingbills
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "recentTransactions" : [ {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  }, {
    "date" : "date",
    "amount" : 0.8008281904610115,
    "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
    "financialInstitutionId" : "financialInstitutionId",
    "categoryTitle" : "categoryTitle",
    "financialAccountName" : "financialAccountName",
    "description" : "description",
    "merchant" : "merchant",
    "categoryCode" : "Benefits",
    "merchantLogoUrl" : "merchantLogoUrl"
  } ],
  "upcomingBills" : [ {
    "amount" : 1.4658129805029452,
    "recurringFrequency" : "Weekly",
    "dueDate" : "dueDate",
    "categoryTitle" : "categoryTitle",
    "description" : "description",
    "merchant" : "merchant",
    "daysToDueDate" : 5,
    "merchantLogoUrl" : "merchantLogoUrl",
    "categoryCode" : "Benefits"
  }, {
    "amount" : 1.4658129805029452,
    "recurringFrequency" : "Weekly",
    "dueDate" : "dueDate",
    "categoryTitle" : "categoryTitle",
    "description" : "description",
    "merchant" : "merchant",
    "daysToDueDate" : 5,
    "merchantLogoUrl" : "merchantLogoUrl",
    "categoryCode" : "Benefits"
  } ],
  "currentDateTimeUtc" : "currentDateTimeUtc",
  "lastSuccessfulUpdatedAtUtc" : "lastSuccessfulUpdatedAtUtc",
  "overviewCard" : {
    "infoIcon" : "infoIcon",
    "numberOfDaysTillPayday" : 6,
    "payCycleEndDate" : "payCycleEndDate",
    "allAccountCashBalance" : 0.8008281904610115,
    "payCycleStartDate" : "payCycleStartDate"
  },
  "topCategoriesAmount" : [ {
    "totalAmount" : 7.061401241503109,
    "categoryAmount" : 2.3021358869347655,
    "categoryTitle" : "categoryTitle",
    "categoryCode" : "Benefits",
    "categoryId" : 5
  }, {
    "totalAmount" : 7.061401241503109,
    "categoryAmount" : 2.3021358869347655,
    "categoryTitle" : "categoryTitle",
    "categoryCode" : "Benefits",
    "categoryId" : 5
  } ]
}}]

     - returns: RequestBuilder<GetSpendingOverviewResponse> 
     */
    open class func getSpendingOverviewUpcomingBillsWithRequestBuilder() -> RequestBuilder<GetSpendingOverviewResponse> {
        let path = "/v1/Spending/overview/upcomingbills"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetSpendingOverviewResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSpendingSpecificCategoryStats(_id: Int, completion: @escaping ((_ data: GetSpendingSpecificCategoryResponse?,_ error: Error?) -> Void)) {
        getSpendingSpecificCategoryStatsWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Spending/categories/{id}
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "dailyTransactions" : [ {
    "date" : "date",
    "transactions" : [ {
      "date" : "date",
      "amount" : 0.8008281904610115,
      "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
      "financialInstitutionId" : "financialInstitutionId",
      "categoryTitle" : "categoryTitle",
      "financialAccountName" : "financialAccountName",
      "description" : "description",
      "merchant" : "merchant",
      "categoryCode" : "Benefits",
      "merchantLogoUrl" : "merchantLogoUrl"
    }, {
      "date" : "date",
      "amount" : 0.8008281904610115,
      "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
      "financialInstitutionId" : "financialInstitutionId",
      "categoryTitle" : "categoryTitle",
      "financialAccountName" : "financialAccountName",
      "description" : "description",
      "merchant" : "merchant",
      "categoryCode" : "Benefits",
      "merchantLogoUrl" : "merchantLogoUrl"
    } ]
  }, {
    "date" : "date",
    "transactions" : [ {
      "date" : "date",
      "amount" : 0.8008281904610115,
      "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
      "financialInstitutionId" : "financialInstitutionId",
      "categoryTitle" : "categoryTitle",
      "financialAccountName" : "financialAccountName",
      "description" : "description",
      "merchant" : "merchant",
      "categoryCode" : "Benefits",
      "merchantLogoUrl" : "merchantLogoUrl"
    }, {
      "date" : "date",
      "amount" : 0.8008281904610115,
      "financialInstitutionLogoUrl" : "financialInstitutionLogoUrl",
      "financialInstitutionId" : "financialInstitutionId",
      "categoryTitle" : "categoryTitle",
      "financialAccountName" : "financialAccountName",
      "description" : "description",
      "merchant" : "merchant",
      "categoryCode" : "Benefits",
      "merchantLogoUrl" : "merchantLogoUrl"
    } ]
  } ],
  "monthAmountStats" : [ {
    "amount" : 0.8008281904610115,
    "month" : "month"
  }, {
    "amount" : 0.8008281904610115,
    "month" : "month"
  } ]
}}]
     
     - parameter _id: (path)  

     - returns: RequestBuilder<GetSpendingSpecificCategoryResponse> 
     */
    open class func getSpendingSpecificCategoryStatsWithRequestBuilder(_id: Int) -> RequestBuilder<GetSpendingSpecificCategoryResponse> {
        var path = "/v1/Spending/categories/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetSpendingSpecificCategoryResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter financialAccountIds: (query)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getSpendingStatus(financialAccountIds: String? = nil, completion: @escaping ((_ data: GetSpendingStatusResponse?,_ error: Error?) -> Void)) {
        getSpendingStatusWithRequestBuilder(financialAccountIds: financialAccountIds).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Spending/status
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "transactionStatus" : "Categorising"
}}]
     
     - parameter financialAccountIds: (query)  (optional)

     - returns: RequestBuilder<GetSpendingStatusResponse> 
     */
    open class func getSpendingStatusWithRequestBuilder(financialAccountIds: String? = nil) -> RequestBuilder<GetSpendingStatusResponse> {
        let path = "/v1/Spending/status"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        var url = URLComponents(string: URLString)
        url?.queryItems = APIHelper.mapValuesToQueryItems([
            "financialAccountIds": financialAccountIds
        ])

        let requestBuilder: RequestBuilder<GetSpendingStatusResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getUpcomingBills(completion: @escaping ((_ data: [GetUpcomingBillResponse]?,_ error: Error?) -> Void)) {
        getUpcomingBillsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Spending/upcoming
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example=[ {
  "amount" : 1.4658129805029452,
  "recurringFrequency" : "Weekly",
  "dueDate" : "dueDate",
  "categoryTitle" : "categoryTitle",
  "description" : "description",
  "merchant" : "merchant",
  "daysToDueDate" : 5,
  "merchantLogoUrl" : "merchantLogoUrl",
  "categoryCode" : "Benefits"
}, {
  "amount" : 1.4658129805029452,
  "recurringFrequency" : "Weekly",
  "dueDate" : "dueDate",
  "categoryTitle" : "categoryTitle",
  "description" : "description",
  "merchant" : "merchant",
  "daysToDueDate" : 5,
  "merchantLogoUrl" : "merchantLogoUrl",
  "categoryCode" : "Benefits"
} ]}]

     - returns: RequestBuilder<[GetUpcomingBillResponse]> 
     */
    open class func getUpcomingBillsWithRequestBuilder() -> RequestBuilder<[GetUpcomingBillResponse]> {
        let path = "/v1/Spending/upcoming"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[GetUpcomingBillResponse]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
