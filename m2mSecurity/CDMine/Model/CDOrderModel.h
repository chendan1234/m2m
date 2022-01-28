//
//  CDOrderModel.h
//  Security
//
//  Created by chendan on 2021/8/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDOrderModel : NSObject

//appName = "\U9648\U4e39";
//createTime = 1628040515000;
//expireTime = "<null>";
//life = 30;
//mobile = 15050568544;
//money = 100;
//orderId = 018ca297c7bf4b4cbf2936d1fc5f4564;
//orderNumber = 20210804012835;
//paymetIntentId = "<null>";
//purchaseTime = "<null>";
//reasonForRefund = "<null>";
//serviceName = "7\U5929\U8ba2\U9605";
//startTime = "<null>";
//status = 6;
//userId = 110fda88a75e4aefbfcc685ea928f79f;

@property (nonatomic, strong)NSString *appName;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *orderId;
@property (nonatomic, strong)NSString *orderNumber;
@property (nonatomic, strong)NSString *serviceName;
@property (nonatomic, strong)NSString *reasonForRefund;//拒绝理由
@property (nonatomic, strong)NSString *payment;//支付需要

@property (nonatomic, assign)NSInteger createTime;
@property (nonatomic, assign)NSInteger expireTime;
@property (nonatomic, assign)NSInteger life;
@property (nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger startTime;
@property (nonatomic, assign)NSInteger money;
@property (nonatomic, assign)NSInteger purchaseTime;



@end

NS_ASSUME_NONNULL_END
