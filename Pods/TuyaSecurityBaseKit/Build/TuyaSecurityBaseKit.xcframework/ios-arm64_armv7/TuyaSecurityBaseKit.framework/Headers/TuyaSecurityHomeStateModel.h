//
//  TuyaSecurityHomeStateModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TuyaSecurityModeType.h"
#import "TuyaSecurityHomeBaseStateModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityHomeStateModel : TuyaSecurityHomeBaseStateModel

/// Home current mode
@property (nonatomic, assign) TuyaSecurityModeType armedMode;

/// Whether the home is alarming
@property (nonatomic, assign) BOOL isAlarming;

/// Home alarm countdown
@property (nonatomic, assign) long long alarmCountdown;

/// Home online state
@property (nonatomic, assign) NSInteger onlineState;

/// armed mode enter time
@property (nonatomic, assign) long long armedCountdown;


@end

NS_ASSUME_NONNULL_END

