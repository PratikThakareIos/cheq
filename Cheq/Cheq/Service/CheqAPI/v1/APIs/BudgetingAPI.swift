//
// BudgetingAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class BudgetingAPI {
    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getBudgets(completion: @escaping ((_ data: GetUserBudgetResponse?,_ error: Error?) -> Void)) {
        getBudgetsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Budgeting
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "recurringFrequency" : "recurringFrequency",
  "totalSpending" : 6.027456183070403,
  "totalBudget" : 0.8008281904610115,
  "requireSetupProcess" : true,
  "startDate" : "startDate",
  "userBudgets" : [ {
    "hide" : true,
    "categoryTitle" : "categoryTitle",
    "estimatedBudget" : 5,
    "id" : 1,
    "categoryCode" : "categoryCode",
    "actualSpending" : 5
  }, {
    "hide" : true,
    "categoryTitle" : "categoryTitle",
    "estimatedBudget" : 5,
    "id" : 1,
    "categoryCode" : "categoryCode",
    "actualSpending" : 5
  } ]
}}]

     - returns: RequestBuilder<GetUserBudgetResponse> 
     */
    open class func getBudgetsWithRequestBuilder() -> RequestBuilder<GetUserBudgetResponse> {
        let path = "/v1/Budgeting"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetUserBudgetResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func updateUserBudget(request: PutUserBudgetsRequest? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        updateUserBudgetWithRequestBuilder(request: request).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - PUT /v1/Budgeting
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func updateUserBudgetWithRequestBuilder(request: PutUserBudgetsRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1/Budgeting"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
