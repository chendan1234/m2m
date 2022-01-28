//
//  TuyaSecurityHomeArmedModeModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TuyaSecurityModeType.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityHomeArmedModeModel : NSObject

/// gateway devices
@property (nonatomic, strong) NSArray<NSString *>*gatewayList;

/// current mode
@property (nonatomic, assign) TuyaSecurityModeType mode;

/// location alarm state
@property (nonatomic, assign) NSInteger alarmState;

/// location alarm countdown
@property (nonatomic, assign) long long alarmCountdown;

/// location online state
@property (nonatomic, assign) NSInteger onlineState;

/// switch mode unique identification
@property (nonatomic, strong) NSString *uid;

/// switch mode result state
@property (nonatomic, strong) NSString *stage;

/// armed mode enter time
@property (nonatomic, assign) long long enterTime;


@end

NS_ASSUME_NONNULL_END

