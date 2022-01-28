//
//  TuyaSecurityAlarmDetailModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TuyaSecurityAlarmMessageModel.h"
#import "TuyaSecurityAlarmOperationModel.h"

NS_ASSUME_NONNULL_BEGIN

/// Alarm detail
@interface TuyaSecurityAlarmDetailModel : NSObject

/// alarm description
@property (nonatomic, copy) NSString *stateDescription;

/// Whether the alarm system is on or off
@property (nonatomic, assign) BOOL isEnableVoice;

/// alarm operations
@property (nonatomic, strong) NSArray<TuyaSecurityAlarmOperationModel *>*operations;

/// alarm messages
@property (nonatomic, strong) NSArray<TuyaSecurityAlarmMessageModel *>*alarmMessages;


@end

NS_ASSUME_NONNULL_END

