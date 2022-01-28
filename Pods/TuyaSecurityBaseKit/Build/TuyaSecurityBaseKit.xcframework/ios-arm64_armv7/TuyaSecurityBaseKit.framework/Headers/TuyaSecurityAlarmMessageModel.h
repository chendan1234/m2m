//
//  TuyaSecurityAlarmMessageModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TYSecurityArmAbilityEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class TYAlarmDetailModel;

/// Alarm message
@interface TuyaSecurityAlarmMessageModel : NSObject

/// Alarm id
@property (nonatomic, copy) NSString *alarmId;

/// Alarm message id
@property (nonatomic, copy) NSString *msgId;

/// Alarm message content
@property (nonatomic, copy) NSString *msgContent;

/// Alarm message title
@property (nonatomic, copy) NSString *msgTitle;

/// product type
@property (nonatomic, copy) NSString *productType;

/// product id
@property (nonatomic, copy) NSString *productId;

/// A list of devices where the alarm occurred
@property (nonatomic, strong) NSArray<NSString *> *deviceIds;

@property (nonatomic, copy) NSString *monitoringDeadline;

/// Alarm type
@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) TYSecurityAlarmType alarmType;

/// Alarm type description
@property (nonatomic, copy) NSString *typeDesc;

@property (nonatomic, copy) NSString *gmtCreate;

/// Alarm message state
@property (nonatomic, assign) AlarmMessageState state;

@property (nonatomic, strong) NSMutableArray<TYAlarmDetailModel *> *details;

@property (nonatomic, assign) NSInteger alarmLeavel;

@end

@interface TYAlarmDetailModel : NSObject

/// room name
@property (nonatomic, copy) NSString *roomName;

/// device name
@property (nonatomic, copy) NSString *deviceName;

/// time string
@property (nonatomic, copy) NSString *timeString;

@end

NS_ASSUME_NONNULL_END

