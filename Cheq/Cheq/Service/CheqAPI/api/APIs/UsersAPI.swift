//
// UsersAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class UsersAPI {
    /**

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func forgetPassword(request: PostForgetPasswordRequest? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        forgetPasswordWithRequestBuilder(request: request).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - POST /v1/Users/password/forget
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func forgetPasswordWithRequestBuilder(request: PostForgetPasswordRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1/Users/password/forget"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getUser(completion: @escaping ((_ data: GetUserResponse?,_ error: Error?) -> Void)) {
        getUserWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Users
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "userDetail" : {
    "firstName" : "firstName",
    "lastName" : "lastName",
    "residentialAddress" : "residentialAddress",
    "mobile" : "mobile",
    "dateOfBirth" : "dateOfBirth",
    "unitApartmentNumber" : "unitApartmentNumber"
  },
  "employer" : {
    "address" : "address",
    "employmentType" : "Fulltime",
    "workingLocation" : "FromFixedLocation",
    "latitude" : 0.8008281904610115,
    "employerName" : "employerName",
    "noFixedAddress" : true,
    "longitude" : 6.027456183070403
  }
}}]

     - returns: RequestBuilder<GetUserResponse> 
     */
    open class func getUserWithRequestBuilder() -> RequestBuilder<GetUserResponse> {
        let path = "/v1/Users"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetUserResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getUserActions(completion: @escaping ((_ data: GetUserActionResponse?,_ error: Error?) -> Void)) {
        getUserActionsWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Users/actions
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "showReconnect" : true,
  "userAction" : "None",
  "linkedInstitutionName" : "linkedInstitutionName",
  "showClose" : true,
  "actionRequiredGuidelines" : [ "actionRequiredGuidelines", "actionRequiredGuidelines" ],
  "link" : "link",
  "showChatWithUs" : true,
  "detail" : "detail",
  "title" : "title",
  "linkedInstitutionId" : "linkedInstitutionId",
  "canSelectBank" : true
}}]

     - returns: RequestBuilder<GetUserActionResponse> 
     */
    open class func getUserActionsWithRequestBuilder() -> RequestBuilder<GetUserActionResponse> {
        let path = "/v1/Users/actions"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetUserActionResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func getUserOnfidoKyc(completion: @escaping ((_ data: GetUserKycResponse?,_ error: Error?) -> Void)) {
        getUserOnfidoKycWithRequestBuilder().execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /v1/Users/kyc
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "kycStatus" : "Blocked",
  "applicantId" : "applicantId",
  "sdkToken" : "sdkToken"
}}]

     - returns: RequestBuilder<GetUserKycResponse> 
     */
    open class func getUserOnfidoKycWithRequestBuilder() -> RequestBuilder<GetUserKycResponse> {
        let path = "/v1/Users/kyc"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetUserKycResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func postPushNotificationToken(request: PostPushNotificationRequest? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        postPushNotificationTokenWithRequestBuilder(request: request).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - POST /v1/Users/notification/token
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func postPushNotificationTokenWithRequestBuilder(request: PostPushNotificationRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1/Users/notification/token"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putKycCheck(completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        putKycCheckWithRequestBuilder().execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - PUT /v1/Users/kyc/check
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer

     - returns: RequestBuilder<Void> 
     */
    open class func putKycCheckWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/v1/Users/kyc/check"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putUser(completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        putUserWithRequestBuilder().execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - PUT /v1/Users
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer

     - returns: RequestBuilder<Void> 
     */
    open class func putUserWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/v1/Users"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putUserDetail(request: PutUserDetailRequest? = nil, completion: @escaping ((_ data: GetUserResponse?,_ error: Error?) -> Void)) {
        putUserDetailWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - PUT /v1/Users/detail
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "userDetail" : {
    "firstName" : "firstName",
    "lastName" : "lastName",
    "residentialAddress" : "residentialAddress",
    "mobile" : "mobile",
    "dateOfBirth" : "dateOfBirth",
    "unitApartmentNumber" : "unitApartmentNumber"
  },
  "employer" : {
    "address" : "address",
    "employmentType" : "Fulltime",
    "workingLocation" : "FromFixedLocation",
    "latitude" : 0.8008281904610115,
    "employerName" : "employerName",
    "noFixedAddress" : true,
    "longitude" : 6.027456183070403
  }
}}]
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<GetUserResponse> 
     */
    open class func putUserDetailWithRequestBuilder(request: PutUserDetailRequest? = nil) -> RequestBuilder<GetUserResponse> {
        let path = "/v1/Users/detail"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetUserResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putUserEmployer(request: PutUserEmployerRequest? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        putUserEmployerWithRequestBuilder(request: request).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - PUT /v1/Users/employer
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func putUserEmployerWithRequestBuilder(request: PutUserEmployerRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1/Users/employer"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func putUserOnfidoKyc(request: PutUserOnfidoKycRequest? = nil, completion: @escaping ((_ data: GetUserKycResponse?,_ error: Error?) -> Void)) {
        putUserOnfidoKycWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - PUT /v1/Users/kyc
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     - examples: [{contentType=application/json, example={
  "kycStatus" : "Blocked",
  "applicantId" : "applicantId",
  "sdkToken" : "sdkToken"
}}]
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<GetUserKycResponse> 
     */
    open class func putUserOnfidoKycWithRequestBuilder(request: PutUserOnfidoKycRequest? = nil) -> RequestBuilder<GetUserKycResponse> {
        let path = "/v1/Users/kyc"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<GetUserKycResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func requestUserSignupVerificationCode(completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        requestUserSignupVerificationCodeWithRequestBuilder().execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - POST /v1/Users/signup/request
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer

     - returns: RequestBuilder<Void> 
     */
    open class func requestUserSignupVerificationCodeWithRequestBuilder() -> RequestBuilder<Void> {
        let path = "/v1/Users/signup/request"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func resetPassword(request: PutResetPasswordRequest? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        resetPasswordWithRequestBuilder(request: request).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - PUT /v1/Users/password/reset
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func resetPasswordWithRequestBuilder(request: PutResetPasswordRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1/Users/password/reset"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter request: (body)  (optional)
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func verifyUserSingupCode(request: PutUserSingupVerificationCodeRequest? = nil, completion: @escaping ((_ data: Void?,_ error: Error?) -> Void)) {
        verifyUserSingupCodeWithRequestBuilder(request: request).execute { (response, error) -> Void in
            if error == nil {
                completion((), error)
            } else {
                completion(nil, error)
            }
        }
    }


    /**
     - PUT /v1/Users/signup/confirm
     - API Key:
       - type: apiKey Authorization 
       - name: Bearer
     
     - parameter request: (body)  (optional)

     - returns: RequestBuilder<Void> 
     */
    open class func verifyUserSingupCodeWithRequestBuilder(request: PutUserSingupVerificationCodeRequest? = nil) -> RequestBuilder<Void> {
        let path = "/v1/Users/signup/confirm"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Void>.Type = SwaggerClientAPI.requestBuilderFactory.getNonDecodableBuilder()

        return requestBuilder.init(method: "PUT", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
