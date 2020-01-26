//
//  InstitutionOption.h
//  PersonalDataVault
//
//  Created by Julius Lundang on 26/12/2017.
//  Copyright © 2017 eWise. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "InstitutionFilter.h"

@interface InstitutionOption : NSObject

/// Defaults to `true`
@property (assign, nonatomic) BOOL includeTransactions;
@property (strong, nonatomic) InstitutionFilter *filters;

- (id)init;

@end
