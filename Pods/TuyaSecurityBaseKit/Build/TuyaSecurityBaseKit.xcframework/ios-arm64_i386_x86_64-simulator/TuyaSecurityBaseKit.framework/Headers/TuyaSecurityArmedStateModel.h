//
//  TuyaSecurityArmedStateModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TuyaSecurityModeType.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityArmedStateModel : NSObject

/// current mode
@property (nonatomic, assign) TuyaSecurityModeType mode;

/// switch mode unique identification
@property (nonatomic, copy) NSString *uid;

/// switch mode result state
@property (nonatomic, copy) NSString *stage;

/// armed mode enter time
@property (nonatomic, assign) long long armedCountdown;


@end

NS_ASSUME_NONNULL_END

