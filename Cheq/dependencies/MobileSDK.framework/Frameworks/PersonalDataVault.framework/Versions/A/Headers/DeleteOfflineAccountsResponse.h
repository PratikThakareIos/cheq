//
//  DeleteOfflineAccountsResponse.h
//  PersonalDataVault
//
//  Created by Julius Lundang on 09/03/2018.
//  Copyright © 2018 eWise. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PersonalDataVault.h"

@class EwError;

@interface DeleteOfflineAccountsResponse : NSObject

/// List of delete account hashes
@property (strong, nonatomic) NSArray<NSString *> *data;
@property (strong, nonatomic) EwError *error;
@property (copy, nonatomic) NSString *message;
@property (copy, nonatomic) NSString *status;

@end
