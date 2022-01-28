//
//  TuyaSecuritySensorModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TuyaSecurityCameraInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecuritySensorModel : NSObject

/// ID of the sensor
@property (nonatomic, copy) NSString *deviceId;

/// The sensor is binding
@property (nonatomic, assign) BOOL isBinding;


@end

NS_ASSUME_NONNULL_END

