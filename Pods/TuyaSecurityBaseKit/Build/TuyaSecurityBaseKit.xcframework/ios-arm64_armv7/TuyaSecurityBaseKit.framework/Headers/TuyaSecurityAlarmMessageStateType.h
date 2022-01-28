//
//  TuyaSecurityAlarmMessageStateType.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

/// alarm message  type
typedef enum {
    /// new alarm
    TuyaSecurityAlarmMessageTypeNew = 1, 
    /// alarm cancelled
    TuyaSecurityAlarmMessageTypeCancel = 2, 
    /// alarm done
    TuyaSecurityAlarmMessageTypeDone = 3, 
    /// dispatch to monitor center
    TuyaSecurityAlarmMessageTypeDispatchMc = 4, 
    /// clear monitor center
    TuyaSecurityAlarmMessageTypeMcClear = 5, 
} TuyaSecurityAlarmMessageType;




