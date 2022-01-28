//
//  MessageDetailModel.h
//  m2mSecurity
//
//  Created by chendan on 2021/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageDetailModel : NSObject

//createTime = 1633939168000;
//info = "Your order\U301020210806093821\U3011has been closed due to the overdue payment. <a onclick=\"window.webkit.messageHandlers.callbackHandler.postMessage('{&quot;type&quot;:&quot;1&quot;,&quot;orderId&quot;:&quot;544f863a232a49e780e858ff2868dae4&quot;}')\" style=\"text-decoration:underline;\">Check the details.</a>\n";
//pushId = 41672bcf9e5c4096955a361d31f565c6;
//title = "Your order has been closed.\n";
//userId = 110fda88a75e4aefbfcc685ea928f79f;

@property (nonatomic, assign)NSInteger createTime;
@property (nonatomic, strong)NSString *info;
@property (nonatomic, strong)NSString *pushId;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *userId;

@end

NS_ASSUME_NONNULL_END
