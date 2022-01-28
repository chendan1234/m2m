//
//  TYSocialProtocol.h
//  TYSocialOverseas
//
//  Created by TuyaInc on 2018/11/29.
//

#ifndef TYSocialProtocol_h
#define TYSocialProtocol_h

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TYSocialShareModel;

typedef NS_ENUM(NSUInteger, TYSocialType) {
    TYSocialWechat          = 0,
    TYSocialWechatMoment    = 1,   //微信朋友圈
    TYSocialQQ              = 2,
    TYSocialQQSpace         = 3,   //qq空间
    TYSocialEmail           = 7,
    TYSocialSMS             = 8,
    TYSocialMore            = 11,
};

typedef NS_ENUM(NSUInteger, TYSocialShareContentType) {
    TYSocialShareContentText,       //未使用
    TYSocialShareContenttImage,     //单图分享
    TYSocialShareContentH5,         //web分享
    TYSocialShareContentImageUrl,   //单图URL分享
};

typedef void (^TYSuccessHandler)(void);
typedef void (^TYFailureHandler)(void);

@protocol TYSocialProtocol <NSObject>

@optional

// 注册
- (void)registerWithType:(TYSocialType)type appKey:(NSString *)appKey appSecret:(NSString *)appSecret;
- (void)registerWithType:(TYSocialType)type appKey:(NSString *)appKey appSecret:(NSString *)appSecret universalLink:(NSString *)universalLink;

// 分享
- (void)shareTo:(TYSocialType)type shareModel:(TYSocialShareModel *)shareModel success:(TYSuccessHandler)success failure:(TYFailureHandler)failure;

// 是否初始化&&已安装
- (BOOL)avaliableForType:(TYSocialType)type;

// 重定向
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;

// Universal Links
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler;

@end

NS_ASSUME_NONNULL_END

#endif /* TYSocialProtocol_h */

