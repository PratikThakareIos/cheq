//
//  Institution.h
//  PersonalDataVault
//
//  Created by Julius Lundang on 27/12/2017.
//  Copyright © 2017 eWise. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PersonalDataVault.h"
#import <Mantle/Mantle.h>

@class Account;

@interface Institution : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) NSArray<Account *> *accounts;
@property (copy, nonatomic) NSString *institutionId;

@end
