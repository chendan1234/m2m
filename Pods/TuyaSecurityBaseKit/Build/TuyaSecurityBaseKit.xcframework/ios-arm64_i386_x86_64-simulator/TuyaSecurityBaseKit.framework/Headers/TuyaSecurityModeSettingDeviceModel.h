//
//  TuyaSecurityModeSettingDeviceModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TuyaSecurityModeSettingItemModel.h"

NS_ASSUME_NONNULL_BEGIN

/// the rule at mode 
@interface TuyaSecurityModeSettingDeviceModel : NSObject

/// security gateway infomations
@property (nonatomic, strong) NSArray<TuyaSecurityModeSettingItemModel *>*securityGateway;

/// virtual gateway infomations
@property (nonatomic, strong) NSArray<TuyaSecurityModeSettingItemModel *>*virtualGateway;

/// camera devices infomations
@property (nonatomic, strong) NSArray<TuyaSecurityModeSettingItemModel *>*ipcDevices;


@end

NS_ASSUME_NONNULL_END

