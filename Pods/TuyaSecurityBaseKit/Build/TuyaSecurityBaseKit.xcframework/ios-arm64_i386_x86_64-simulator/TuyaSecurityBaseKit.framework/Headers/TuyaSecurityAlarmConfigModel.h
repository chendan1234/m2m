//
//  TuyaSecurityAlarmConfigModel.h
//  TuyaSecurityBaseKit
//
//  Created by Tuya.Inc on 2021/3/9.
//

#import <Foundation/Foundation.h>
#import "TYSecurityArmAbilityEnum.h"

@class TuyaSmartSecurityAlarmPlatformModel,TuyaSecurityAlarmOperationModel;

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityAlarmConfigModel : NSObject

/// Alarm service platform infomation
@property (nonatomic, strong) TuyaSmartSecurityAlarmPlatformModel *info;

/// Alarm operations
@property (nonatomic, strong) NSArray<TuyaSecurityAlarmOperationModel *> *actions;

@end

@interface TuyaSmartSecurityAlarmPlatformModel : NSObject

/// Alarm count down dead time line
@property (nonatomic, assign) NSTimeInterval deadline;

/// Alarm count down current time line
@property (nonatomic, assign) long long currentMillis;

/// Current time interval
@property (nonatomic, assign) NSTimeInterval ct;

/// Alarm service platform description
@property (nonatomic, copy) NSString *desc;

/// Alarm service platform name
@property (nonatomic, copy) NSString *mcName;

/// Alarm id
@property (nonatomic, copy) NSString *alarmId;

/// Alarm service platform type
@property (nonatomic, assign) TYSecurityLocationMonitorState mcState;

/// Whether the alarm has been sent to the alarm receiving center
@property (nonatomic, assign) BOOL dispatched;

/// Alarm voice state
@property (nonatomic, assign) BOOL voice;


@end

NS_ASSUME_NONNULL_END
