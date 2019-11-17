//
//  ApiListener.h
//  MobileSDK
//
//  Created by Nathan Phillips on 22/11/18.
//  Copyright © 2018 Moneysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ApiErrorModel;

/**
This class is an asynchronous handler for an API request which returns a single, strongly typed object as it's "success" result.
*/
@interface ApiListener<T: id>: NSObject
@property void(^successHandler)(T);
@property void(^errorHandler)(ApiErrorModel*);

/**
Creates An `ApiListener` with the specified success and error handlers.
@param successHandler : A closure which is called when success occurs.
@param errorHandler: A closure which is called when an error occurs.
*/
- (id)initWithSuccessHandler:(void(^)(T result))successHandler errorHandler:(void(^)(ApiErrorModel* error))errorHandler;

/**
Fires when the API gets a successful response.
*/
- (void)onSuccess:(T)result;

/**
Fires when the API returns an error.
*/
- (void)onError:(ApiErrorModel*)error;

@end
