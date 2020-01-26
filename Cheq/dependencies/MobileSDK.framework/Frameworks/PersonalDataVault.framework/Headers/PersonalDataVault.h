//
//  PersonalDataVault.h
//  pdv ios
//
//  Version "7.1"
//
//  Created by eWise on 10/29/15.
//  Copyright � 2015 eWise. All rights reserved.
//
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UpdateInstitutionResponse.h"
#import "InstitutionOption.h"
#import "AccountRequest.h"
#import "DeleteOfflineAccountsResponse.h"
#import <Mantle/Mantle.h>

@class UpdateInstitutionResponse;
@class DeleteOfflineAccountsResponse;

/// Since `UpdateInstitutionResponse` has the same properties as `OfflineAccountResponse`
/// we'll use type alias instead of creating duplicate class
/// NOTE: EwVerify is always `nil` since this is an offline API
typedef UpdateInstitutionResponse OfflineAccountResponse;

@interface EwError : MTLModel <MTLJSONSerializing>
@property NSInteger code;
@property NSString *name;
@property NSString *message;
@property NSString *additionalMessage;
@end

@interface EWInitResponse : NSObject
@property NSString *status;
@property EwError *error;
@end

@interface EWConfigureResponse : NSObject
@property NSString *status;
@property EwError *error;
@end

@interface EWLogonResponse : NSObject
@property NSString *status;
@property NSError *ewError;
@end

@interface EWRegisterUserResponse : NSObject
@property NSString *status;
@property NSString *code;
@property NSString *message;
@property NSString *moreInfo;
@property NSError *ewError;
@end

@interface EWGetInstitutionsInstitution : NSObject
@property NSString *instCode;
@property NSString *instDesc;
@end

@interface EWGetInstitutionsGroup : NSObject
@property NSString *groupDesc;
@property NSString *groupId;
@property NSArray<EWGetInstitutionsInstitution *> *institutions;
@end

@interface EWGetInstitutionsData : NSObject
@property NSArray<EWGetInstitutionsGroup *> *groups;
@end

@interface EWGetInstitutionsResponse : NSObject
@property NSString *status;
@property EWGetInstitutionsData *data;
@property EwError *error;
@end

@interface EWVerify : MTLModel <MTLJSONSerializing>
@property NSString *prompt;// The value that will be passed
@property NSString *base64Image;
@property NSString *type; // ACA returns (eg. confirm)
@property NSString *input; // Bool in Android
@end

@interface EwVerify: MTLModel <MTLJSONSerializing>
@property (copy, nonatomic) NSString *base64Image;
@property (copy, nonatomic) NSString *imageUrl;
@property (assign, nonatomic) BOOL inputRequired;
@property (copy, nonatomic) NSString *prompt;
@property  (copy, nonatomic) NSString *type;
@end

@interface EWAccountData : MTLModel <MTLJSONSerializing>
@property NSString *accountHash;
@property NSString *accountId;
@property NSString *accountName;
@property NSString *accountNumber;
@property NSNumber *availBalance;
@property NSNumber *balance;
@property NSInteger category;
@property NSString *currency;
@property NSString *data;
@property NSDictionary *dataObject;
@property NSString *updatedAt;
@property NSString *instId;
@end

@interface EWRestoreAccountsResponse : MTLModel <MTLJSONSerializing>
@property NSString *status;
@property NSString *instId;
@property NSString *message;
@property EWAccountData *data;
@property BOOL partial;
@property EwError *error;

/**
 Returns NSDictionary equivalent value for this model.
 
 If for example, `error` property is `nil` then no "error" key will not be present in NSDictionary.
 
 @return NSDictionary, can be converted to JSON
 */
- (NSDictionary *)toJSON;

@end

@interface EWUpdateAccountsResponse : EWRestoreAccountsResponse
@property EWVerify *verify;

- (NSDictionary *)toJSON;
@end

@interface EWAuthPrompt : NSObject
@property NSInteger index;
@property NSInteger type;
@property NSString *value;
@end

@interface EWAuthData : NSObject
@property NSString* instId;
@property NSArray<EWAuthPrompt *> *prompts;
-(EWAuthData*)copy;
-(BOOL)setPrompt:(NSInteger)index value:(NSString*)value;
-(NSString*)getValue:(NSInteger)index;
@end

@interface EWRemoveData : NSObject
@property NSArray<NSString *> *instList;
@end

@interface EWRemoveInstitutionsResponse : NSObject
@property NSString *status;
@property EWRemoveData *data;
@property EwError *error;
@end

@interface EWGetPromptsResponse : NSObject
@property NSString *status;
@property EWAuthData *data;
@property EwError *error;
@end

@interface EWLoginUrlData : NSObject
@property NSString *loginUrlMobile;
@property NSString *loginUrlDesktop;
@end

@interface EWGetLoginUrlResponse : NSObject
@property NSString *status;
@property EWLoginUrlData *data;
@property EwError *error;
@end


@interface EWUserProfile : NSObject
@property NSString *iid;
@property NSString *uid;
@property NSString *desc;
@property BOOL foundInDevice;
@end

@interface EWGetUserProfileData : NSObject
@property NSArray<EWUserProfile *> *userprofile;
@end

@interface EWGetUserProfileResponse : NSObject
@property NSString *status;
@property EWGetUserProfileData *data;
@property EwError *error;
@end

@interface EWDate : MTLModel <MTLJSONSerializing>
@property NSNumber *year;
@property NSNumber *month;
@property NSNumber *date;

- (NSString *)getDateWithFormat:(NSString *)format;
@end

@interface EWTransaction : MTLModel <MTLJSONSerializing>

@property (strong, nonatomic) EWDate *date;
/**
 @brief Transaction date with date format yyyy-MM-dd.
 @see date
 */
@property (strong, nonatomic) NSString *transactionDate;
@property (copy, nonatomic) NSString *ewdescription;
@property (strong, nonatomic) NSNumber *amount;
@property (copy, nonatomic) NSString *currency;
@property (copy, nonatomic) NSString *data;
@property (copy, nonatomic) NSString *fingerprint;
@property NSDictionary<NSString *, id> *dataObject;

@end

@interface Transaction: MTLModel <MTLJSONSerializing>
@property (strong, nonatomic) NSNumber *amount;
@property (copy, nonatomic) NSString *currency;
@property (copy, nonatomic) NSString *data;
@property NSDictionary<NSString *, id> *dataObject;
@property (copy, nonatomic) NSString *date;
/**
 @brief Transaction date with date format @b yyyy-MM-dd.
 
 @see date
 */
@property (copy, nonatomic) NSString *transactionDate;
// description has been inherited from NSObject already
@property (copy, nonatomic) NSString *fingerprint;

- (void)setDescription:(NSString *)description;
@end

@interface Account : MTLModel <MTLJSONSerializing>

@property (copy, nonatomic) NSString *accountHash;
@property (copy, nonatomic) NSString *accountName;
@property (copy, nonatomic) NSString *accountNumber;
@property (copy, nonatomic) NSString *availBalance;
@property (copy, nonatomic) NSString *balance;
@property (assign, nonatomic) NSInteger category;
@property (copy, nonatomic) NSString *currency;
@property (copy, nonatomic) NSString *data;
@property (strong, nonatomic) NSDictionary<NSString *, id> *dataObject;
@property (strong, nonatomic) NSArray<NSString *> *linkedAccounts; // No linkedAccounts in response
@property (assign, nonatomic) BOOL online;
@property (strong, nonatomic) NSArray<Transaction *> *transactions;
@property (copy, nonatomic) NSString *updatedAt;

- (id)init;

@end

@interface EWAccountTransaction : MTLModel <MTLJSONSerializing>
@property NSString *instId;
@property NSString *accountId;
@property EWAccountData *account;
@property NSArray<EWTransaction*> *transactions;
@end

@interface EWRestoreTransactionsResponse : MTLModel <MTLJSONSerializing>
@property NSString *instId;
@property NSString *status;
@property NSString *message;
@property NSNumber *updatetime;
@property NSArray<EWAccountTransaction*> *accountTransactions;
@property NSArray<EWRestoreTransactionsResponse*> *responses;
@property BOOL partial;
@property EwError *error;

/**
 Returns NSDictionary equivalent value for this model.
 
 If for example, `error` property is `nil` then no "error" key will not be present in NSDictionary.
 
 @return NSDictionary, can be converted to JSON
 */
- (NSDictionary *)toJSON;

@end

@interface EWUpdateTransactionsResponse : EWRestoreTransactionsResponse
@property EWVerify *verify;

- (NSDictionary *)toJSON;

@end

@interface EWUpdateTransactionConfig : NSObject
@property EWAuthData *data;
@property NSString* startDate;
@property NSString* endDate;
@end

@interface EWInstAndAccountRequest : NSObject
@property NSString *instId;
@property NSArray<NSString*> *accountHashes;
@end

@interface EWSendCustomerInfoType : NSObject
@property NSString *ewid;
@property NSString *ewdescription;
@end

@interface EWSendCustomerInfoRequest : NSObject
@property EWSendCustomerInfoType *type;
@property NSString *notes;
@end

@interface EWSendCustomerInfoResponse : NSObject
@property NSString *status;
@property EwError *error;
@end

@interface EWMessage : NSObject
@property NSString *type;
@property NSString *message;
@end

@interface EWTransferPromptQuestion : NSObject
@property NSString *name;
@property NSString *type;
@property NSArray<NSString*> *options;
@property NSArray<EWMessage*> *messages;
@end

@interface EWTransferPromptAnswer : NSObject
@property NSString *name;
@property NSArray<NSString*> *values;
@end

@interface EWDoTransferResponse : NSObject
@property NSString *status;
@property NSArray<EWTransferPromptQuestion*> *prompts;
@property NSArray<EWMessage*> *messages;
@property EwError *error;
@end

@interface EWSetTransferRequest : NSObject
@property NSArray<EWTransferPromptAnswer*> *prompts;
@property EwError *error;
@end

@interface EWConsentAcct : NSObject
@property NSString *serviceId;
@property NSString *instId;
@property NSString *accountId;
@property BOOL grantConsent;
@end

@interface EWConsentSvc : NSObject
@property NSString *appId;
@property NSString *serviceId;
@property BOOL grantConsent;
@property NSString *descriptionTxt;
@property NSArray<EWConsentAcct*> *accounts;
@end

@interface EWConsentApp : NSObject
@property NSString *userId;
@property NSString *appId;
@property BOOL grantConsent;
@property NSString *descriptionTxt;
@property NSArray<EWConsentSvc*> *services;
@end

@interface EWGetConsentResponse : NSObject
@property NSString *status;
@property NSString *statusCode;
@property NSString *message;
@property NSArray<EWConsentApp*> *consents;
@property EwError *error;
@end

@interface EWSendTransactionsResponse : NSObject
@property NSString *status;
@property NSString *statusCode;
@property NSString *message;
@end

@interface EWRemoveLocalDataResponse : EWRemoveInstitutionsResponse
@property NSString *message;
@property NSNumber *credentials;
@property NSNumber *accounts;
@end

@interface CustomerReportType : NSObject
@property NSString *crId;
@property NSString *descriptionTxt;
@end

@interface CustomerReport : NSObject
@property CustomerReportType *type;
@property NSString *notes;
@end

@interface CustomerReportResponse : NSObject
@property NSString *status;
@property NSString *message;
@property EwError *error;
@property NSDictionary *data;
@end

@interface EWStopResponse : NSObject
@property NSString *status;
@property NSString *message;
@end

@interface EWDeleteTransactionData : NSObject
@property NSString *instId;
@property NSNumber *deleted;
@end

@interface EWDeleteTransactionsResponse : NSObject
@property NSString *status;
@property NSString *message;
@property EWDeleteTransactionData *data;
@property EwError *error;
@end

@interface EWVersionResponse: NSObject
@property NSString *status;
@property NSString *message;
@property EwError *error;
@property NSString *data;
@end

@interface PersonalDataVaultTyped : NSObject

/**
 Use this constructor when using Remora-enabled ACA(s)
 
 @param view Container view (usually root view)
 @param swanUrl Swan Url
 @param mmUrl MM url
 @param readyCallback Completion handler
 @return PersonalDataVault instance
 */
- (instancetype)initWithView:(UIView *)view
                     swanUrl:(NSString*)swanUrl
                       mmUrl:(NSString*)mmUrl
           withReadyCallback:(void(^)(EWInitResponse *response))readyCallback;
- (void)configure:(NSString *)mmUrl
		  swanUrl:(NSString *)swanUrl
		 callback:(void (^)(EWConfigureResponse *response))callback;
- (void)config:(NSDictionary *)config;
- (void)initialise:(void(^)(NSString *status))completed;
- (void)logon:(NSString *)userName
     password:(NSString *)password
completeBlock:(void(^)(EWLogonResponse *response))completed;
- (void)setUser:(NSString *)userName;
- (void)registerUser:(NSString *)username
           password:(NSString *)password
              email:(NSString *)email
      completeBlock:(void(^)(EWRegisterUserResponse *response))callBack;
/**
 Get all instititions.
 
 @param callback The completion handler to call get all institutions.
 */
- (void)getInstitutions:(void(^)(EWGetInstitutionsResponse *response))callback;
- (BOOL)updateAccounts:(NSArray<NSString *> *)instIds
         completeBlock:(void(^)(EWUpdateAccountsResponse *response))callBack;
- (BOOL)updateAccounts:(NSArray<NSString *> *)instIds
         completeBlock:(void(^)(EWUpdateAccountsResponse *response))callBack
             profileId:(NSString *)profileId
                  auth:(EWAuthData *)auth;
- (void)removeInstitutions:(NSArray<NSString *> *)instList
             completeBlock:(void(^)(EWRemoveInstitutionsResponse *response))callback;
- (BOOL)restoreAccounts:(NSString *)instId
          completeBlock:(void (^)(EWRestoreAccountsResponse *response))callback;
- (EWAuthData *)getCredentials:(NSString *)instId;
- (BOOL)setCredentials:(NSString *)instId credentials:(EWAuthData *)credentials;
- (void)getPrompts:(NSString *)instCode callback:(void(^)(EWGetPromptsResponse *response))callback;
- (void)getUserProfile:(void(^)(EWGetUserProfileResponse *response))callback;
- (BOOL)updateTransactions:(NSArray<NSString *> *)inst
             completeBlock:(void(^)(EWUpdateTransactionsResponse *response))callback;
- (BOOL)updateTransactions:(NSArray<NSString *> *)inst
             completeBlock:(void(^)(EWUpdateTransactionsResponse *response))callback
                      auth:(EWAuthData *)auth;
- (BOOL)updateTransactions:(NSArray<NSString *> *)inst
             completeBlock:(void(^)(EWUpdateTransactionsResponse *response))callback
                    config:(EWUpdateTransactionConfig *)updateTransactionConfig;
- (BOOL)restoreTransaction:(NSArray<EWInstAndAccountRequest *> *)instAndAccounts
                 startDate:(NSString *)startDate
                   endDate:(NSString *)endDate
             completeBlock:(void(^)(EWRestoreTransactionsResponse *response))callback;
- (void)deleteSafe;
- (BOOL)setVerify:(NSString *)instId inputData:(NSString *)inputData;
- (void)sendCustomerInfo:(EWSendCustomerInfoRequest *)info
                complete:(void(^)(EWSendCustomerInfoResponse *response))complete;
- (void)sendCustomerReport:(CustomerReport *)report
                  callBack:(void(^)(CustomerReportResponse *response))callBack;
- (void)setAdditionalHeaders:(NSDictionary *)headers;
- (void)doTransfer:(NSString *)instId
     completeBlock:(void(^)(EWDoTransferResponse *response))callback;
- (void)setTransferPrompts:(NSString *) instId prompts:(EWSetTransferRequest *)prompts;
- (void)getLoginUrl:(NSString *)instCode callback:(void(^)(EWGetLoginUrlResponse *response))callback;
- (void)getConsent:(void(^)(EWGetConsentResponse *response))callback;
- (void)setConsent:(NSArray<EWConsentApp *> *)consentApps
          callback:(void(^)(EWGetConsentResponse *response))callback;
- (void)sendTransactions:(NSString *)userId
                  instId:(NSString *)instId
                callback:(void(^)(EWSendTransactionsResponse *response))callback;
- (void)stop:(void(^)(EWStopResponse *response))callback;
- (void)removeLocalData:(NSArray *)instIds
          completeBlock:(void(^)(EWRemoveLocalDataResponse *response))callback;
- (void)deleteTransactions:(NSString *)instId
                  callBack:(void(^)(EWDeleteTransactionsResponse *response))callBack;

/**
 @brief Updates specific institution only. Functionality is the as updateTransaction (update only)

 @param institutionId Institution ID
 @param callback Completion handler
 @param option Options includes filters
 @since v6.2.6
 */
- (void)updateInstitution:(NSString *)institutionId
                  callback:(void(^)(UpdateInstitutionResponse *response))callback
                    option:(InstitutionOption *)option;

/**
 @brief Get PersonalDataVault SDK version

 @param callback Get response in this callback using EWVersionResponse object
 @since v6.3.0
 */
- (void)getVersion:(void(^)(EWVersionResponse *))callback;

/**
 @brief Clients must be able to add an offline account.
 
 @discussion
  - If passed with a @p nil AccountRequest,
    then it will return error code @b 3104 - @em MISSING_ACCOUNT_REQUEST

  - If the offline account to be added generates an @p accountHash that is already existing in the PDV,
    the API will return error code @b 3004 - @em DUPLICATED_ACCOUNT

 @param accountRequest AccountRequest object
 @param callback Completion handler once API finished executing
 @since v6.4.0
 */
- (void)addOfflineAccount:(nonnull AccountRequest *)accountRequest
                 callback:(nonnull void(^)(OfflineAccountResponse * _Nonnull response))callback;

/**
 @brief User must be able to update an existing offline account
 
 @discussion
    - If passed with a @p nil AccountRequest,
    then it will return error code @b 3104 - @em MISSING_ACCOUNT_REQUEST

    - If passed with an AccountRequest that has an @p accountHash that is not existing in the PDV,
    the API will return error code @b 3302 - @em INVALID_ACCOUNT_HASH

    - If the user renames an offline account, and another offline account (of the same type) of the user
    has same name and type, the API will return error code @b 3004 - @em DUPLICATED_ACCOUNT.

 @param accountRequest AccountRequest object
 @param callback Completion handler once API finished executing
 @since v6.4.0
 */
- (void)updateOfflineAccount:(nonnull AccountRequest *)accountRequest
                    callback:(nonnull void(^)(OfflineAccountResponse * _Nonnull response))callback;

/**
 @brief Returns all the list of accounts that were deleted

 @param accountHashes List of account hashes
 @param callback Completion handler once API finished executing,
    returns all account hashes that has been deleted
 @since v6.4.0
 */
- (void)deleteOfflineAccounts:(nonnull NSArray<NSString *> *)accountHashes
                     callback:(nonnull void(^)(DeleteOfflineAccountsResponse * _Nonnull response))callback;
@end
