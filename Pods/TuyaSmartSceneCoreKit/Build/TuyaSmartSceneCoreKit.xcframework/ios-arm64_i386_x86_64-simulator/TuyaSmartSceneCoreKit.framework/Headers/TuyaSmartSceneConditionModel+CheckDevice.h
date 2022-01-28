//
//  TuyaSmartSceneConditionModel+CheckDevice.h
//  TuyaSmartSceneKit
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import "TuyaSmartSceneConditionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartSceneConditionModel (CheckDevice)

/// Check whether the equipment is abnormal. Returns yes if the condition does not contain a device.
/// @return YES: Device is normal or this is not a device, NO：Device is abnormal.
- (BOOL)checkWhetherDeviceIsNormal;

/// Whether the current condition content is a device.
- (BOOL)cd_isDevice;

@end

NS_ASSUME_NONNULL_END
