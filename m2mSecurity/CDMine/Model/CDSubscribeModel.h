//
//  CDSubscribeModel.h
//  Security
//
//  Created by chendan on 2021/8/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDSubscribeModel : NSObject

//createDate = 1627869721000;
//id = 4;
//money = 3000000;
//serviceDay = 1825;
//serviceName = "7*24 \U5c0f\U65f6\U4eba\U5de5\U76d1\U63a7\U670d\U52a1 * 5\U5e74";

@property (nonatomic, assign)NSInteger money;
@property (nonatomic, assign)NSInteger serviceDay;
@property (nonatomic, strong)NSString *serviceName;
@property (nonatomic, strong)NSString *timeStr;
@property (nonatomic, strong)NSString *paymentIntentClientSecret;


@property (nonatomic, strong)NSString *num;
@property (nonatomic, strong)NSString *cvc;
@property (nonatomic, assign)NSInteger expMonth;
@property (nonatomic, assign)NSInteger expYear;

@end

NS_ASSUME_NONNULL_END
