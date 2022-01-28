//
//  TuyaSecurityModeDelegate.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TuyaSecuritySDKErrorCode.h"
#import "TuyaSecurityModeType.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TuyaSecurityModeDelegate <NSObject>

@optional

#pragma mark - Security Alarm

/// home will alarm after delay time.
///
/// @param delayTime delay time
- (void)homeWillAlarmWithDelayTime:(long long)delayTime;

/// home open alarm
- (void)homeDidAlarm;

/// home calcel alarm
- (void)homeDidCancelAlarm;

#pragma mark - Security Arm

/// home enter mode
///
/// @param mode target model
/// @param delayTime delay time
- (void)homeDidEnterModeWithMode:(TuyaSecurityModeType)mode
                       delayTime:(long long)delayTime;

/// request failure call back
///
/// @param errorType error type
/// @param errorMessage error message
- (void)operationErrorWithErrorType:(TuyaSecuritySDKErrorCode)errorType 
                       errorMessage:(NSString *)errorMessage;

/// alarm voice changed
///
/// @param open voice open or close
- (void)alarmVoiceDidChangedWithOpen:(BOOL)open;

/// should update irregular devices
- (void)shouldUpdateIrregularDevices;

/// should update abnormal devices
- (void)shouldUpdateAbnormalDevices;

/// home online state changed
- (void)homeOnlineStateDidChangeWithOnline:(BOOL)online;

/// should update home alarm detail info
- (void)shouldUpdateAlarmDetailInfo;

/// gateway device armed result
/// @param targetMode arm mode
/// @param deviceId gateway device id
/// @param success arm success
/// @param isFirstUpload is first result report
- (void)gatewayDeviceArmedResult:(TuyaSecurityModeType)targetMode
                        deviceId:(NSString *)deviceId
                         success:(BOOL)success isFirstUpload:(BOOL)isFirstUpload;

/// security gateway device online state changed
/// @param onlineType 类型
- (void)hasSecurityGatewayOnlineState:(TYSecurityGatewayDeviceOnlineType)onlineType;



@end

NS_ASSUME_NONNULL_END
