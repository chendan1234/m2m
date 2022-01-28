//
//  CDOrderDetailModel.h
//  Security
//
//  Created by chendan on 2021/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDOrderDetailModel : NSObject

//address = "<null>";
//cardNumber = "<null>";
//email = "825415639@qq.com";
//mobile = 15050568544;
//money = 120;
//name = "<null>";
//orderId = 8319a012d2c749f987bf77dbb1091837;
//orderInfo = "2021-08-04 09-55-25  \U751f\U6210\U9884\U652f\U4ed8\U8ba2\U5355\U6210\U529f/n";
//orderNumber = 20210804095525;
//payWay = "<null>";
//serialNumber = "<null>";
//serviceName = "7*24 \U5c0f\U65f6\U4eba\U5de5\U76d1\U63a7\U670d\U52a1 * 1\U6708";
//status = 1;
//userName = "\U9648\U4e39";

@property (nonatomic, strong)NSString *orderNumber;
@property (nonatomic, strong)NSString *orderInfo;
@property (nonatomic, strong)NSString *serviceName;
@property (nonatomic, strong)NSString *orderId;
@property (nonatomic, assign)NSInteger money;
@property (nonatomic, assign)NSInteger status;
@property (nonatomic, assign)NSInteger life;
@property (nonatomic, assign)NSInteger createTime;



@end

NS_ASSUME_NONNULL_END
