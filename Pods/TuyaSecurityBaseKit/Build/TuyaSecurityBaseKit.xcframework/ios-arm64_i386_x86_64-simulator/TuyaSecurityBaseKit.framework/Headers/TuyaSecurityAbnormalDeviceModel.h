//
//  TuyaSecurityAbnormalDeviceModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurityAbnormalDeviceModel : NSObject

/// abnormal device id
@property (nonatomic, copy) NSString *deviceId;

/// abnormal device description
@property (nonatomic, copy) NSString *stateDescription;


@end

NS_ASSUME_NONNULL_END

