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
@property void(^ _Nonnull successHandler)(T _Nonnull);
@property void(^ _Nonnull errorHandler)(ApiErrorModel* _Nonnull);

/**
Creates An `ApiListener` with the specified success and error handlers.
@param successHandler : A closure which is called when success occurs.
@param errorHandler : A closure which is called when an error occurs.
*/
- (id _Nonnull )initWithSuccessHandler:(void(^_Nonnull)(T _Nonnull result))successHandler
                          errorHandler:(void(^_Nonnull)(ApiErrorModel* _Nonnull error))errorHandler;

/**
Fires when the API gets a successful response.
*/
- (void)onSuccess:( T _Nonnull )result;

/**
Fires when the API returns an error.
*/
- (void)onError:( ApiErrorModel* _Nonnull )error;

@end
