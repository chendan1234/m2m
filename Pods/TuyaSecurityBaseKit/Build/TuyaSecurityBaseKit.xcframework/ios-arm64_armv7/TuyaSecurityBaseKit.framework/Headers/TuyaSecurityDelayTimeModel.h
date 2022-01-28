//
//  TuyaSecurityDelayTimeModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/// armed delay time and alarm delay time
@interface TuyaSecurityDelayTimeModel : NSObject

/// armed delay time
@property (nonatomic, assign) NSInteger enableDelayTime;

/// alarm delay time
@property (nonatomic, assign) NSInteger alarmDelayTime;


@end

NS_ASSUME_NONNULL_END

