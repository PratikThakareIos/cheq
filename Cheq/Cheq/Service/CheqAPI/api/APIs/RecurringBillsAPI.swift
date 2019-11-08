//
// RecurringBillsAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class RecurringBillsAPI {
    /**

     - parameter _id: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func deleteRecurringBill(_id: Int, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        deleteRecurringBillWithRequestBuilder(_id: _id).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - DELETE /v1/RecurringBills/{id}
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter _id: (path)  

     - returns: RequestBuilder<Void> 
     */
    open class func deleteRecurringBillWithRequestBuilder(_id: Int) -> RequestBuilder<Void> {
        var path = "/v1/RecurringBills/{id}"
        let _idPreEscape = "\(_id)"
        let _idPostEscape = _idPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{id}", with: _idPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getRecurringBills(completion: @escaping ((_ data: [GetRecurringBillResponse]?,_ error: Error?) -> Void)) {
        getRecurringBillsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/RecurringBills
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example=[ {
  "amount" : 6.027456183070403,
  "recurringFrequency" : "Weekly",
  "endDate" : "endDate",
  "isAddedByUser" : true,
  "description" : "description",
  "merchant" : "merchant",
  "id" : 0,
  "merchantLogoUrl" : "merchantLogoUrl",
  "startDate" : "startDate"
}, {
  "amount" : 6.027456183070403,
  "recurringFrequency" : "Weekly",
  "endDate" : "endDate",
  "isAddedByUser" : true,
  "description" : "description",
  "merchant" : "merchant",
  "id" : 0,
  "merchantLogoUrl" : "merchantLogoUrl",
  "startDate" : "startDate"
} ]}]

     - returns: RequestBuilder<[GetRecurringBillResponse]> 
     */
    open class func getRecurringBillsWithRequestBuilder() -> RequestBuilder<[GetRecurringBillResponse]> {
        let path = "/v1/RecurringBills"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<[GetRecurringBillResponse]>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postRecurringBill(request: PostRecurringBillRequest? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        postRecurringBillWithRequestBuilder(request: request).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - POST /v1/RecurringBills
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func postRecurringBillWithRequestBuilder(request: PostRecurringBillRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1/RecurringBills"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}