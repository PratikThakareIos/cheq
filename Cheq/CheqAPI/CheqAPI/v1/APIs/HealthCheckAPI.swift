//
// HealthCheckAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire

open class HealthCheckAPI {
    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getHealthCheck(completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        getHealthCheckWithRequestBuilder().execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - GET /HealthCheck
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer

     - returns: RequestBuilder<Void> 
     */
    open class func getHealthCheckWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/HealthCheck"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

}
