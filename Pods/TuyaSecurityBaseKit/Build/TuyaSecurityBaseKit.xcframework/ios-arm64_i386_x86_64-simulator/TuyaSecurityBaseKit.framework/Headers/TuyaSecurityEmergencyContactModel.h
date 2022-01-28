//
//  TuyaSecurityEmergencyContactModel.h
//  TuyaSecuritySDK
//
//  Copyright (c) 2014-2021 Tuya (https://developer.tuya.com/)

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/// Emergency contact
@interface TuyaSecurityEmergencyContactModel : NSObject

/// Emergency contact area code
@property (nonatomic, copy) NSString *areaCode;

/// Emergency contact phone
@property (nonatomic, copy) NSString *phone;

/// Emergency contact first name
@property (nonatomic, copy) NSString *firstName;

/// Emergency contact last name
@property (nonatomic, copy) NSString *lastName;

/// Emergency contact id
@property (nonatomic, assign) NSInteger contactId;

/// Emergency contact create time
@property (nonatomic, assign) long long createTime;

/// Emergency contact full name
@property (nonatomic, copy) NSString *fullName;

/// Emergency contact email
@property (nonatomic, copy) NSString *email;


@end

NS_ASSUME_NONNULL_END

