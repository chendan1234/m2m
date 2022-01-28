//
//  TuyaSmartDoorBellManager.h
//  TuyaSmartCameraKit
//
//  Created by 傅浪 on 2021/1/13.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, TYDoorBellError) {
    TYDoorBellError_NoError         = 0,
    TYDoorBellError_AnsweredByOther = -1001,
    TYDoorBellError_DidCanceled     = -1002,
    TYDoorBellError_TimeOut         = -1003,
    TYDoorBellError_AnsweredBySelf  = -1004,
    TYDoorBellError_NotAnswered     = -1005,
    TYDoorBellError_NotSupport      = -1006,
    TYDoorBellError_InvalidParam    = -1007,
};

@class TuyaSmartDeviceModel;

@interface TuyaSmartDoorBellCallModel : NSObject

/// call type, "doorbell" or "ac_doorbell", or custom type
@property (nonatomic, strong) NSString *type;
/// the device id of doorbell call
@property (nonatomic, strong) NSString *devId;
/// the sub device's node id which calling
@property (nonatomic, strong) NSString *nodeId;
/// the call event identifier
@property (nonatomic, strong) NSString *messageId;
/// the time of doorbell call be triggered
@property (nonatomic, assign) NSInteger time;
/// did answered
@property (nonatomic, assign, readonly, getter=isAnsweredBySelf) BOOL answeredBySelf;
/// is answered by other user
@property (nonatomic, assign, readonly, getter=isAnsweredByOther) BOOL answeredByOther;
/// is device canceled this call event
@property (nonatomic, assign, readonly, getter=isCanceled) BOOL canceled;

/// is a NVR sub device
@property (nonatomic, assign, readonly) BOOL isSubDevice;

- (NSDictionary *)map;

@end

@protocol TuyaSmartDoorBellObserver <NSObject>

@optional

- (void)doorBellCall:(TuyaSmartDoorBellCallModel *)callModel didReceivedFromDevice:(TuyaSmartDeviceModel *)deviceModel;

- (void)doorBellCallDidRefuse:(TuyaSmartDoorBellCallModel *)callModel;

- (void)doorBellCallDidHangUp:(TuyaSmartDoorBellCallModel *)callModel;

- (void)doorBellCallDidAnsweredByOther:(TuyaSmartDoorBellCallModel *)callModel;

- (void)doorBellCallDidCanceled:(TuyaSmartDoorBellCallModel *)callModel timeOut:(BOOL)isTimeOut;

@end

@interface TuyaSmartDoorBellManager : NSObject

@property (nonatomic, strong, readonly) NSArray<id<TuyaSmartDoorBellObserver>> *allObservers;

@property (nonatomic, assign) BOOL ignoreWhenCalling;

@property (nonatomic, assign) NSInteger doorbellRingTimeOut;

+ (instancetype)sharedInstance;

- (void)addObserver:(id<TuyaSmartDoorBellObserver>)observer;

- (TYDoorBellError)answerDoorBellCall:(NSString *)messageId;

- (void)refuseDoorBellCall:(NSString *)messageId;

- (TYDoorBellError)hangupDoorBellCall:(NSString *)messageId;

- (void)removeObserver:(id<TuyaSmartDoorBellObserver>)observer;

- (void)removeAllObservers;

@end
