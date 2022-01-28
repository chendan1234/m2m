//
//  TuyaSecurityHomeArmedModeChangedModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TuyaSecurityModeType.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityHomeArmedModeChangedModel : NSObject

/// current mode
@property (nonatomic, assign) TuyaSecurityModeType mode;

/// switch mode unique identification
@property (nonatomic, strong) NSString *uid;

/// switch mode result state
@property (nonatomic, strong) NSString *stage;

/// arm mode countdown time
@property (nonatomic, assign) long long enterTime;


@end

NS_ASSUME_NONNULL_END

