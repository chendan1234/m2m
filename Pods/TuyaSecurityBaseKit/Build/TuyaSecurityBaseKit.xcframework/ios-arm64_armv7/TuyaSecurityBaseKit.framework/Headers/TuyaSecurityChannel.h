//
//  TuyaSecurity.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TuyaSecurityChannelConfigResultModel.h"
#import "TuyaSecurityChannelCodeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityChannel : NSObject

/// Query app channel config
/// @param success success callback
/// @param failure failure callback
- (void)queryChannelConfigInformation:(void(^)(TuyaSecurityChannelConfigResultModel *result))success
                              failure:(void(^)(NSError *error))failure;


/// Do not bind the service code temporarily
/// @param success success callback
/// @param failure failure callback
- (void)skipBinding:(void(^)(BOOL result))success
            failure:(void(^)(NSError *error))failure;

/// Bind default service code
/// @param success success callback
/// @param failure failure callback
- (void)bindDefaultChannelCode:(void(^)(BOOL result))success
                       failure:(void(^)(NSError *error))failure;

/// Get service code status
/// @param success success callback
/// @param failure failure callback
- (void)getChannelCodeStatus:(void(^)(TuyaSecurityChannelCodeModel *result))success
                     failure:(void(^)(NSError *error))failure;

/// Bind service code
/// @param code code the service code
/// @param success success callback
/// @param failure failure callback
- (void)bindChannelCode:(NSString *)code
                success:(void(^)(BOOL result))success
                failure:(void(^)(NSError *error))failure;

/// Ability to change service code
/// @param success success callback
/// @param failure failure callback
- (void)hasChangeChannelCodeAbility:(void(^)(BOOL result))success
                            failure:(void(^)(NSError *error))failure;

/// Change the service code
/// @param code code the service code
/// @param success success callback
/// @param failure failure callback
- (void)changeChannelCode:(NSString *)code
                  success:(void(^)(NSString *result))success
                  failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
