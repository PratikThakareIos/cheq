//
// FirebaseAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class FirebaseAPI {
    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getTestingToken(completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        getTestingTokenWithRequestBuilder().execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - GET /v1/Firebase/token
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer

     - returns: RequestBuilder<Void> 
     */
    open class func getTestingTokenWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/v1/Firebase/token"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getToken(completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        getTokenWithRequestBuilder().execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - GET /v1/Firebase/token/refresh
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer

     - returns: RequestBuilder<Void> 
     */
    open class func getTokenWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/v1/Firebase/token/refresh"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter financialAccountId: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func testRefreshAccount(financialAccountId: Int, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        testRefreshAccountWithRequestBuilder(financialAccountId: financialAccountId).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - POST /v1/Firebase/moneysoft/refreshaccount/{financialAccountId}
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter financialAccountId: (path)  

     - returns: RequestBuilder<Void> 
     */
    open class func testRefreshAccountWithRequestBuilder(financialAccountId: Int) -> RequestBuilder<Void> {
        var path = "/v1/Firebase/moneysoft/refreshaccount/{financialAccountId}"
        let financialAccountIdPreEscape = "\(financialAccountId)"
        let financialAccountIdPostEscape = financialAccountIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{financialAccountId}", with: financialAccountIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
