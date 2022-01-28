//
// TuyaSmartSceneManager+Home.h
// TuyaSmartSceneKit
//
// Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <TuyaSmartSceneCoreKit/TuyaSmartSceneCoreKit.h>
#import <TuyaSmartDeviceKit/TuyaSmartDeviceKit.h>

@interface TuyaSmartSceneManager (Home)

/// Get action device list in the current room with the specify room id.
///
/// @param roomId The room ID.
///
/// @retrun The TuyaSmartDeviceModel list, the more information you can see TuyaSmartDeviceModel class.
- (NSArray<TuyaSmartDeviceModel *> *)getActionDeviceListWithRoomId:(long long)roomId;

/// Get condition device list for the current room in the scene with specify room id.
///
/// @param roomId The room ID.
///
/// @return The TuyaSmartDeviceModel list, the more information you can see TuyaSmartDeviceModel class.
- (NSArray<TuyaSmartDeviceModel *> *)getConditionDeviceListWithRoomId:(long long)roomId;

/// Get group list for action in the scene with specify the current room id.
///
/// @param roomId The room ID.
///
/// @return The TuyaSmartGroupModel list for action in the scene, more information you can see TuyaSmartGroupModel class.
- (NSArray<TuyaSmartGroupModel *> *)getActionGroupListWithRoomId:(long long)roomId;

@end
