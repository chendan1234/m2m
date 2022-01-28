//
//  TuyaSecurity.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>
#import "TuyaSecurityAlarmType.h"
#import "TuyaSecurityCancelAlarmAction.h"
#import "TuyaSecurityMessageType.h"
#import "TuyaSecurityAlarmDetailModel.h"
#import "TuyaSecurityAbnormalDeviceModel.h"
#import "TuyaSecurityHomeBaseStateModel.h"
#import "TuyaSecurityEmergencyContactModel.h"
#import "TuyaSecurityMessageModel.h"
#import "TuyaSecurityCameraInfoModel.h"
#import "TuyaSecuritySensorModel.h"
#import "TuyaSecurityDeviceRuleModel.h"
#import "TuyaSecurityModeSettingDeviceModel.h"
#import "TuyaSecurityModeDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TuyaSecurity : NSObject

#pragma mark - Register Delegate

/// register delegate
///
/// @param homeId home id
/// @param delegate delegate
- (void)registerSecurityModeDelegateWithHomeId:(long long)homeId 
                                      delegate:(id <TuyaSecurityModeDelegate>)delegate;


/// destroy delegate
- (void)onDestroy;

#pragma mark - Security Alarm

/// Trigger an emergency alarm.
///
/// @param homeId homeId
/// @param alarmType alarm type
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)triggerAlarmWithHomeId:(long long)homeId 
                     alarmType:(TYHSGatewaySOSType)alarmType 
                       success:(void(^)(BOOL result))success 
                       failure:(void(^)(NSError *error))failure;

/// Get alarm information
///
/// @param homeId homeId
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)getAlarmInfoWithHomeId:(long long)homeId 
                       success:(void(^)(TuyaSecurityAlarmDetailModel *result))success 
                       failure:(void(^)(NSError *error))failure;

/// Cancel alarm
///
/// @param homeId homeId
/// @param action target action
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)cancelAlarmWithHomeId:(long long)homeId 
                       action:(TYHSGatewayStateUpdateType)action 
                      success:(void(^)(BOOL result))success 
                      failure:(void(^)(NSError *error))failure;

/// Send alarm to platform
///
/// @param homeId homeId
/// @param alarmMessageIds alarm ids
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)sendAlarmToPlatformWithHomeId:(long long)homeId
                      alarmMessageIds:(NSArray<NSString *> *)alarmMessageIds
                              success:(void(^)(BOOL result))success
                              failure:(void(^)(NSError *error))failure;

/// Enable alarm voice
///
/// @param homeId homeId
- (void)enableAlarmVoiceWithHomeId:(long long)homeId;

/// Disable alarm voice
///
/// @param homeId homeId
- (void)disableAlarmVoiceWithHomeId:(long long)homeId;

#pragma mark - Security Arm Rules

/// Get the security equipment rules
///
/// @param homeId homeId
/// @param mode current mode
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)getDevicesInRuleByModeWithHomeId:(long long)homeId 
                                    mode:(TuyaSecurityModeType)mode
                                 success:(void(^)(TuyaSecurityModeSettingDeviceModel *result))success 
                                 failure:(void(^)(NSError *error))failure;

/// Save the security equipment rules
///
/// @param homeId homeId
/// @param mode current mode
/// @param data the gateway and equipment list of rules
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)saveDevicesByModeWithHomeId:(long long)homeId 
                               mode:(TuyaSecurityModeType)mode
                               data:(NSArray<TuyaSecurityDeviceRuleModel *>*)data 
                            success:(void(^)(BOOL result))success 
                            failure:(void(^)(NSError *error))failure;

#pragma mark - Security Delay

/// Get armed delay time by mode
///
/// @param homeId homeId
/// @param mode current mode
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)getArmedDelayTimeByModeWithHomeId:(long long)homeId 
                                     mode:(TuyaSecurityModeType)mode
                                  success:(void(^)(NSInteger result))success 
                                  failure:(void(^)(NSError *error))failure;

/// Get alarm delay time by mode
///
/// @param homeId homeId
/// @param mode current mode
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)getAlarmDelayTimeByModeWithHomeId:(long long)homeId 
                                     mode:(TuyaSecurityModeType)mode
                                  success:(void(^)(NSInteger result))success 
                                  failure:(void(^)(NSError *error))failure;

/// Save the delay of the save mode specified rules
///
/// @param homeId homeId
/// @param mode target mode
/// @param enableDelayTime disarmed delay time
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)updateArmedDelayTimeWithHomeId:(long long)homeId 
                                  mode:(TuyaSecurityModeType)mode
                       enableDelayTime:(NSInteger)enableDelayTime 
                               success:(void(^)(BOOL result))success 
                               failure:(void(^)(NSError *error))failure;

/// Save the alarm delay of the save mode specified rules
///
/// @param homeId homeId
/// @param mode target mode
/// @param alarmDelayTime alarm delay time
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)updateAlarmDelayTimeWithHomeId:(long long)homeId 
                                  mode:(TuyaSecurityModeType)mode
                        alarmDelayTime:(NSInteger)alarmDelayTime 
                               success:(void(^)(BOOL result))success 
                               failure:(void(^)(NSError *error))failure;

#pragma mark - Security Emergency Contact

/// Add new emergency contact
///
/// @param homeId homeId
/// @param phone emergency contact phone
/// @param email emergency contact email
/// @param firstName emergency contact firstName
/// @param lastName emergency contact lastName
/// @param areaCode emergency contact areaCode
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)addEmergencyContactWithHomeId:(long long)homeId 
                                phone:(NSString *)phone 
                                email:(NSString *)email 
                            firstName:(NSString *)firstName 
                             lastName:(NSString *)lastName 
                             areaCode:(NSString *)areaCode 
                              success:(void(^)(BOOL result))success 
                              failure:(void(^)(NSError *error))failure;

/// sort the emergency contacts sequence
///
/// @param homeId homeId
/// @param emergencyContacts the modified emergency contacts
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)sortEmergencyContactsWithHomeId:(long long)homeId 
                      emergencyContacts:(NSArray<TuyaSecurityEmergencyContactModel *>*)emergencyContacts 
                                success:(void(^)(BOOL result))success 
                                failure:(void(^)(NSError *error))failure;

/// update emergency contact
///
/// @param homeId homeId
/// @param emergencyContact the modified emergency contacts
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)updateEmergencyContactWithHomeId:(long long)homeId 
                        emergencyContact:(TuyaSecurityEmergencyContactModel *)emergencyContact 
                                 success:(void(^)(BOOL result))success 
                                 failure:(void(^)(NSError *error))failure;

/// Get emergency contacts
///
/// @param homeId homeId
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)getEmergencyContactsWithHomeId:(long long)homeId 
                               success:(void(^)(NSArray<TuyaSecurityEmergencyContactModel *>*result))success 
                               failure:(void(^)(NSError *error))failure;

/// Delete emergency contacts
///
/// @param homeId homeId
/// @param ids the deleted emergency contacts
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)deleteEmergencyContactsWithHomeId:(long long)homeId 
                                      ids:(NSArray<NSNumber *>*)ids 
                                  success:(void(^)(BOOL result))success 
                                  failure:(void(^)(NSError *error))failure;

#pragma mark - Security linkage

/// Acquire bindable sensor list
///
/// @param homeId homeId
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)getBindableSensorsWithHomeId:(long long)homeId 
                             success:(void(^)(NSArray<TuyaSecuritySensorModel *>*result))success 
                             failure:(void(^)(NSError *error))failure;

/// Acquire binding camera list
///
/// @param homeId homeId
/// @param sensorId the target sensorId
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)getBindableCamerasWithHomeId:(long long)homeId 
                            sensorId:(NSString *)sensorId 
                             success:(void(^)(NSArray<TuyaSecurityCameraInfoModel *>*result))success 
                             failure:(void(^)(NSError *error))failure;

/// link cameras to sensors
///
/// @param homeId homeId
/// @param sensorId the target sensorId
/// @param cameraInfo the target camera info
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)linkCamerasToSensorWithHomeId:(long long)homeId 
                             sensorId:(NSString *)sensorId 
                           cameraInfo:(NSArray<TuyaSecurityCameraInfoModel *>*)cameraInfo 
                              success:(void(^)(NSString *result))success 
                              failure:(void(^)(NSError *error))failure;

#pragma mark - Security Arm

/// Get home Info(contain current mode、location online state、location alarm state、arm countdown time 、alarm countdown time)
///
/// @param homeId homeId
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)getHomeStateWithHomeId:(long long)homeId 
                       success:(void(^)(TuyaSecurityHomeBaseStateModel *result))success 
                       failure:(void(^)(NSError *error))failure;

/// Update home mode
///
/// @param homeId homeId
/// @param mode target mode
- (void)updateArmedStateWithHomeId:(long long)homeId 
                              mode:(TuyaSecurityModeType)mode;

/// Get abnormal devices
///
/// @param homeId homeId
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)getAbnormalDevicesWithHomeId:(long long)homeId 
                             success:(void(^)(NSArray<TuyaSecurityAbnormalDeviceModel *>*result))success 
                             failure:(void(^)(NSError *error))failure;

/// Get irregular devices
///
/// @param homeId homeId
/// @param mode target mode
- (void)getIrregularDevicesByModeWithHomeId:(long long)homeId 
                                       mode:(TuyaSecurityModeType)mode
                                    success:(void(^)(NSArray<NSString *>*result))success 
                                    failure:(void(^)(NSError *error))failure;

/// check home allow armed or disarm
///
/// @param homeId home id
/// @param mode current mode
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)hasArmAbilityWithHomeId:(long long)homeId 
                           mode:(TuyaSecurityModeType)mode
                        success:(void(^)(NSArray<NSString *> *result))success
                        failure:(void(^)(NSError *error))failure;

#pragma mark - Security Message

/// get message list
///
/// @param homeId home id
/// @param type message type
/// @param pageIndex page index
/// @param pageSize page size
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)getMessageListWithHomeId:(long long)homeId 
                            type:(TuyaSecurityMessageType)type 
                       pageIndex:(NSInteger)pageIndex 
                        pageSize:(NSInteger)pageSize 
                         success:(void(^)(NSArray<TuyaSecurityMessageModel *>*result))success 
                         failure:(void(^)(NSError *error))failure;

/// search message
/// @param homeId home id
/// @param type message type
/// @param startDate start date
/// @param endDate end date
/// @param pageIndex page index
/// @param pageSize page size
/// @param success callback for successful request
/// @param failure callback for failed request
- (void)searchMessageWithHomeId:(long long)homeId
                           type:(TuyaSecurityMessageType)type
                      startDate:(long long)startDate
                        endDate:(long long)endDate
                      pageIndex:(NSInteger)pageIndex
                       pageSize:(NSInteger)pageSize
                        success:(void(^)(NSArray<TuyaSecurityMessageModel *>*result))success
                        failure:(void(^)(NSError *error))failure;

/// delete message
///
/// @param homeId home id
/// @param messageIds message id
/// @param type message type
/// @param success callback for successful request.
/// @param failure callback for failed request.
- (void)deleteMessageWithHomeId:(long long)homeId 
                     messageIds:(NSArray<NSString *>*)messageIds 
                           type:(TuyaSecurityMessageType)type 
                        success:(void(^)(BOOL result))success 
                        failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
