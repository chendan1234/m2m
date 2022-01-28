//
//  TYSecurityArmAbilityEnum.h
//  TYSecurityArmAbilityModuleServices
//
//  Created by Tuya.Inc on 2021/4/2.
//

#ifndef TYSecurityArmAbilityEnum_h
#define TYSecurityArmAbilityEnum_h

//gateway state
typedef NS_ENUM(NSUInteger, TYSecurityGatewayStatusType) {
    TYSecurityGatewayStatusType_Disarm = 0,
    TYSecurityGatewayStatusType_Stay,
    TYSecurityGatewayStatusType_Leaving,
    TYSecurityGatewayStatusType_Offline,
    TYSecurityGatewayStatusType_No_Gateway,
    TYSecurityGatewayStatusType_Error,
};

//gateway device arm result
typedef NS_ENUM(NSUInteger, TYSecurityGatewayDeviceArmResultType) {
    TYSecurityGatewayDeviceArmResultSuccess = 1,//arm success
    TYSecurityGatewayDeviceArmResultFailed      //arm failure
};

//alarm service platform type
typedef NS_ENUM(NSUInteger, TYSecurityLocationMonitorState) {
    TYSecurityLocationMonitorNotSet = 0,//not set
    TYSecurityLocationMonitorSelfMonitoring,//set monitoring
    TYSecurityLocationMonitoroMonitoring//major monitoring
};

// update home state
typedef NS_ENUM(NSUInteger, TYHSGatewayStateUpdateType) {
    TYHSGatewayStateCancelAlarm = 0,//cancel alarm
    TYHSGatewayStateCancelAlarmAndDisarm = 1,//disarm
};

//sos alarm type
typedef NS_ENUM(NSUInteger, TYHSGatewaySOSType) {
    TYHSGatewaySOSFire = 5,//fire alarm
    TYHSGatewaySOSPanic = 8,//panic alarm
    TYHSGatewaySOSEmergency = 9//emergency alarm
};

//alarm message state
typedef NS_ENUM(NSInteger,AlarmMessageState){
    AlarmMessageStateOpen = 1,// open
    AlarmMessageStateCancel = 2,// cancel
    AlarmMessageStateDone = 3,// done
    AlarmMessageStateMC = 4,//sent to alarm service platform
    AlarmMessageStateDealed = 5//dealed
};

//alrm type
typedef NS_ENUM(NSUInteger, TYSecurityAlarmType) {
    TYSecurityAlarmType_FireSmoke,//fire smoke
    TYSecurityAlarmType_FireCO,// co
    TYSecurityAlarmType_WaterLeak,// water leak
    TYSecurityAlarmType_SOS,//sos
    TYSecurityAlarmType_Default,// default type
    TYSecurityAlarmType_Gas,// gas
    TYSecurityAlarmType_Undefine,//undefine
};

//camera ability
typedef NS_ENUM(NSUInteger, TYSecurityCameraAbility) {
    TYSecurityCameraAbilityP2P,//p2p
    TYSecurityCameraAbilityAISmart,//AI
    TYSecurityCameraAbilityCloudStorage//cloud storage
};

//security init type
typedef NS_ENUM(NSInteger, TYSecurityHomeInitType){
    TYSecurityHomeInitTypeTuyaSmartSecurity = 2,//Tuya Smart
    TYSecurityHomeInitTypeApartmentSecurity = 3//Tuya Apartment
};

//arm mode
typedef NS_ENUM(NSInteger, TYSecurityArmMode){
    TYSecurityArmModeDisarmed = 0,// disarmed
    TYSecurityArmModeStaying = 1,// stay
    TYSecurityArmModeLeaving = 2,//away
    TYSecurityArmModeAllHours = 4,//24 hours
    TYSecurityArmModeUndefine = 100//undefine
};

//location online type
typedef NS_ENUM(NSUInteger, TYSecurityLocationLineState) {    
    TYSecurityLocationLineStateInit = 0,//init state(offline)
    TYSecurityLocationLineStateAllGatewayOnline = 1,//all gateway device online
    TYSecurityLocationLineStateAllGatewayOffline = 2,//some gateway device online
    TYSecurityLocationLineStateSomeGatewayOffline = 3,//some gateway device offline
//    TYSecurityLocationLineStateAllGatewayOffline = 5,
    TYSecurityLocationLineStateNOGatewayDevice = 6,//has no gateway device
    TYSecurityLocationLineStateGatewayDeviceArmBypass = 7,//gateway device has irregular sub device when armed
    TYSecurityLocationLineStateGatewayNoDevice = 8, //location has no deivce
    TYSecurityLocationLineStateGatewayStayingArmNoDevice = 9,//has no rule device on stay mode
    TYSecurityLocationLineStateGatewayLeavingArmNoDevice = 10//has no rule device on away mode
};

typedef NS_ENUM(NSUInteger, TYSecurityGatewayDeviceOnlineType) {
    TYSecurityGatewayDeviceOnlineTypeOnline = 1,//gateway device online
    TYSecurityGatewayDeviceOnlineTypeOffine = 2,//gateway device offline
    TYSecurityGatewayDeviceOnlineNoGateway = 3//no gateway device
};

//weather type
typedef NS_ENUM(NSUInteger, TYSecurityWeatherViewShowType) {
    TYSecurityWeatherViewShowError = 1,//load datas failure
    TYSecurityWeatherViewShowNoLocation = 2,//no address
    TYSecurityWeatherViewShowSuccess = 3//load datas success
};


/// Security error code
typedef enum {
    /// query home information error
    TYSecurityArmAbilityErrorCodeQueryHomeInfo = 900002,
    /// query home mode error
    TYSecurityArmAbilityErrorCodeQueryMode = 900003,
    /// save devices error
    TYSecurityArmAbilityErrorCodeSaveDeviceList = 900007,
    /// Invalid id
    TYSecurityArmAbilityErrorCodeInvalidId = 900008,
    /// Update home mode error.
    TYSecurityArmAbilityErrorCodeUpdateHomeMode = 900009,
    /// Get irregular device error.
    TYSecurityArmAbilityErrorCodeQueryIrregularDevice = 900010,
} TYSecurityArmAbilityErrorCode;


#endif /* TYSecurityArmAbilityEnum_h */
