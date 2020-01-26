//
//  UpdateInstitutionResponse.h
//  PersonalDataVault
//
//  Created by Julius Lundang on 26/12/2017.
//  Copyright © 2017 eWise. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PersonalDataVault.h"
#import "Institution.h"
#import <Mantle/Mantle.h>

@class EwError;
@class Institution;
@class EwVerify;

@interface UpdateInstitutionResponse : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) Institution *data;
@property (strong, nonatomic) EwError *error;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *status;
@property (strong, nonatomic) EwVerify *verify;

/**
 Returns NSDictionary equivalent value for this model.
 
 If for example, `error` property is `nil` then no "error" key will not be present in NSDictionary.
 
 @return NSDictionary, can be converted to JSON
 */
- (NSDictionary *)toJSON;

@end
