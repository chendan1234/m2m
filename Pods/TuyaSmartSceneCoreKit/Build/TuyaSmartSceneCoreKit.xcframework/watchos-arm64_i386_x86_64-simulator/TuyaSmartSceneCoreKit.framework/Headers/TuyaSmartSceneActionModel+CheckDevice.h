//
//  TuyaSmartSceneActionModel+CheckDevice.h
//  TuyaSmartSceneKit
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import "TuyaSmartSceneActionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSmartSceneActionModel (CheckDevice)

/// Check whether the device is abnormal (offline/removed). Returns yes if the action does not contain a device.
/// @return YES: Device is normal or this is not a device, NO: device is abnormal.
- (BOOL)checkWhetherDeviceIsNormal;

@end

NS_ASSUME_NONNULL_END
