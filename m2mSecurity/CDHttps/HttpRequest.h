//
//  HttpRequest.h
//  YouJia
//
//  Created by user on 15/6/8.
//  Copyright (c) 2015年 hhxh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIDefine.h"

typedef void(^SuccessBlock)(id result);
typedef void(^FailureBlock)(NSError*error);

@interface HttpRequest : NSObject
//单例
+(HttpRequest*)shareManager;

// GET请求
+ (void)HR_getWithPath:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
// POST请求
+ (void)HR_postWithPath:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
//
/**
 * @author gaofu, 15-09-16 18:09:41
 *
 * 上传二进制文件
 * @param path 二进制文件服务器地址
 * @param imageDate 二进制文件
 * @param success 成功回调
 * @param failure 失败回调
 */
+ (void)HR_ImageUpdateWithContent:(NSData*)imageDate success:(SuccessBlock)success failure:(FailureBlock)failure;


#pragma mark---------------二维码POST请求---------------
+(void)HR_postEWMWithPath:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 *********************************所有的数据请求都在这里*****************************
 */

//假数据
//列表
+ (void)HR_DataGetListWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
//列表
+ (void)HR_DataCollectWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
//列表
+ (void)HR_DataBookingWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
//列表
+ (void)HR_DataUnCollectWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
 * 1.新特性
 */
//1.1新特性接口
+ (void)HR_AppNewestAppSettingWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;


/**
* 2.登录模块
*/
//2.1登陆App

+ (void)HR_LoginWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)HR_AppTuyaWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//涂鸦密码
+ (void)HR_TuYapasswordWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

+ (void)HR_ModifyPersonalDataWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//阿里云验证
+ (void)HR_AuthorizeWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//注册
+ (void)HR_RegisterAppWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//手机发送验证码
+ (void)HR_SendSmSWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//邮箱发送验证码
+ (void)HR_EmailSendWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//校验手机号或者邮箱
+ (void)HR_VerificationSmsOrEmailWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//找回密码
+ (void)HR_RetrievePasswordWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//修改邮箱
+ (void)HR_ModifyMailboxWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//修改手机号
+ (void)HR_ModifyMobilePhoneNumberWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//修改密码
+ (void)HR_UpdatePasswordWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)sendPushDeviceId:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//订阅列表
+ (void)HR_AppListWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//支付参数
+ (void)HR_PaymentWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//订单列表
+ (void)HR_OrderAppListWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//订单详情
+ (void)HR_OrderAppInfoWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//退款
+ (void)HR_RefundWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//分享, 获取用户信息
+ (void)HR_AppInfoByEmailOrMobileWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 * 3.消息
 */
+ (void)HR_AppPushListWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)HR_AppPushDetailWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;
+ (void)HR_AppPushHaveReadWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

/**
 * 4.帮助
 */
+ (void)HR_AppAssistanceWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;

//用户详情
+ (void)HR_AppUserInfoWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure;



@end
