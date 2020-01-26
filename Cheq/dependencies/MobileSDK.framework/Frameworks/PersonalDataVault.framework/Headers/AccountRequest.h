//
//  AccountRequest.h
//  PersonalDataVault
//
//  Created by Julius Lundang on 09/03/2018.
//

#import <Foundation/Foundation.h>


@interface AccountRequest : NSObject

@property (copy, nonatomic) NSString *type;
/// Account number
@property (copy, nonatomic) NSString *number; // accountNumber
@property (copy, nonatomic) NSString *name; // accountName
@property (copy, nonatomic) NSString *balance;
@property (copy, nonatomic) NSString *currency;
@property (copy, nonatomic) NSString *funds; // availBalance
@property (copy, nonatomic) NSString *data;
@property (assign, nonatomic) BOOL multiple;
@property (strong, nonatomic) NSArray<NSString *> *linkedAccounts;

- (instancetype)initWithType:(NSString *)type
                      number:(NSString *)number
                        name:(NSString *)name
                     balance:(NSString *)balance
                    currency:(NSString *)currency
                       funds:(NSString *)funds
                        data:(NSString *)data
                    multiple:(BOOL)multiple
              linkedAccounts:(NSArray<NSString *> *)linkedAccounts NS_DESIGNATED_INITIALIZER;

@end
