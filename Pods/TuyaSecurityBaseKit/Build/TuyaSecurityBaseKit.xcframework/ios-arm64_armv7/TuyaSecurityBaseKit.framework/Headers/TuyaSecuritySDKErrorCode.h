//
//  TuyaSecuritySDKErrorCode.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

/// Security error code
typedef enum {
    /// undefine error
    TuyaSecuritySDKErrorCodeNotLinkService = 900001, 
    /// query home information error
    TuyaSecuritySDKErrorCodeQueryHomeInfo = 900002, 
    /// query home mode error
    TuyaSecuritySDKErrorCodeQueryMode = 900003, 
    /// open alarm voice error
    TuyaSecuritySDKErrorCodeEnableAlarmVoice = 900004, 
    /// close alarm voice error
    TuyaSecuritySDKErrorCodeDisableAlarmVoice = 900005, 
    /// undefine error
    TuyaSecuritySDKErrorCodeUndefine = 900000, 
    /// invalid argument
    TuyaSecuritySDKErrorCodeInvalidArgument = 900006, 
    /// save devices error
    TuyaSecuritySDKErrorCodeSaveDeviceList = 900007,
} TuyaSecuritySDKErrorCode;




