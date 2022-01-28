//
//  HttpRequest.m
//  YouJia
//
//  Created by user on 15/6/8.
//  Copyright (c) 2015年 hhxh. All rights reserved.
//

#import "HttpRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "APIDefine.h"
#import "CDCommonDefine.h"


#define Request(path) [[self getManager] POST:(Service_IP path) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {\
\
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {\
success(responseObject);\
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {\
failure(error);\
}]

#define RequestContent(path) [[self getManager] POST:[NSString stringWithFormat:@"%@%@",Service_IP,path] parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {\
\
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {\
success(responseObject);\
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {\
failure(error);\
}]

#define RequestGET(path) [[self getManager] GET:(Service_IP path) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {\
\
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {\
success(responseObject);\
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {\
failure(error);\
}]


#define RequestForm(path) [[self getFormManager] POST:(Service_IP path) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {\
\
} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {\
success(responseObject);\
} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {\
failure(error);\
}]






/**
 *本类描述:网络请求层封装
 */
@implementation HttpRequest
#pragma mark---------------单例---------------
+(HttpRequest *)shareManager{
    static HttpRequest *request;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[HttpRequest alloc]init];
    });
    return  request;
}
#pragma mark---------------GET请求---------------
//+(void)HR_getWithPath:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
//    [manager GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
//}

+(void)HR_getWithPath:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager GET:path parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark---------------POST请求---------------
+(void)HR_postWithPath:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"Authorization"];
    [manager POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

#pragma mark---------------二维码POST请求---------------
+(void)HR_postEWMWithPath:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"Authorization"];
    
    
    
    [manager POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

//#pragma mark---------------POST请求---------------
//+(void)HR_postWithPath:(NSString *)path params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//
//    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"Authorization"];
//    [manager POST:path parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success(responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure(error);
//    }];
//}

//+(AFHTTPSessionManager *)getManager
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"Authorization"];
//    return manager;
//}

// 返回值需要RSA加密的
+(AFHTTPSessionManager *)getManagerRSA
{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    return manager;
}

+(AFHTTPSessionManager *)getManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    return manager;
}

+(AFHTTPSessionManager *)getFormManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"Authorization"];
    return manager;
}

#pragma mark--------------- 上传二进制文件---------------
+ (void)HR_ImageUpdateWithContent:(NSData*)imageDate success:(SuccessBlock)success failure:(FailureBlock)failure
{

    if (imageDate.length)
    {
        NSString *imageName = [NSString stringWithFormat:@"formIOS%06d",arc4random()%999999];
        
        NSString *uploadPath = [NSString stringWithFormat:@"%@%@",Service_IP,Image_upload];
        
        NSMutableDictionary *parames = [[NSMutableDictionary alloc]init];
        
        [[self getManager]POST:uploadPath parameters:parames constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            //拼接你的要上传的2进制文件
            [formData appendPartWithFileData:imageDate name:@"file" fileName:[NSString stringWithFormat:@"%@.png",imageName] mimeType:@"image/png"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }
    else
    {
        NSLog(@"上传二进制内容为空");
    }
    
}




#pragma mark*********************************所有的数据请求都在这里*****************************
/**
 * 1.新特性
 */
//1.1新特性接口
+ (void)HR_AppNewestAppSettingWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    RequestForm(AppNewestAppSetting);
}

/**
* 2.登录模块
*/
//2.1登陆App 表单+GET
+ (void)HR_LoginWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager.requestSerializer setValue:Token forHTTPHeaderField:@"Authorization"];
    
    [manager GET:(Service_IP Login) parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    failure(error);
    }];
    
    
}

+ (void)HR_AppTuyaWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    Request(AppTuya);
}

//涂鸦密码
+ (void)HR_TuYapasswordWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    RequestForm(TuYapassword);
}

//2.1修改个人资料
+ (void)HR_ModifyPersonalDataWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    Request(ModifyPersonalData);
}

//阿里云验证
+ (void)HR_AuthorizeWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    RequestGET(Authorize);
}
    //阿里云验证
+ (void)sendPushDeviceId:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
        Request(pushDeviceId);
}
//注册
+ (void)HR_RegisterAppWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    Request(RegisterApp);
}

//手机发送验证码 json+拼接
+ (void)HR_SendSmSWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *url = [NSString stringWithFormat:@"%@/%@",SendSmS,content];
    RequestContent(url);
}

//邮箱发送验证码
+ (void)HR_EmailSendWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    RequestForm(EmailSend);
}


//校验手机号或者邮箱
+ (void)HR_VerificationSmsOrEmailWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    Request(VerificationSmsOrEmail);
}

//找回密码  表单+拼接
+ (void)HR_RetrievePasswordWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",Service_IP,RetrievePassword,content];
     [[AFHTTPSessionManager manager] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
     }];
}

//修改邮箱 表单
+ (void)HR_ModifyMailboxWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    RequestForm(ModifyMailbox);
}

//修改手机号 表单+拼接
+ (void)HR_ModifyMobilePhoneNumberWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",Service_IP,ModifyMobilePhoneNumber,content];
     [[self getFormManager] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
     }];
}

//修改密码
+ (void)HR_UpdatePasswordWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",Service_IP,UpdatePassword,content];
     [[self getFormManager] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
     }];
}

//订阅列表
+ (void)HR_AppListWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    RequestForm(AppList);
}

//支付参数
+ (void)HR_PaymentWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    Request(Payment);
}

//订单列表
+ (void)HR_OrderAppListWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    RequestForm(OrderAppList);
}

//订单详情 表单+拼接
+ (void)HR_OrderAppInfoWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",Service_IP,OrderAppInfo,content];
     [[self getFormManager] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure(error);
     }];
}

//退款
+ (void)HR_RefundWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    RequestForm(Refund);
}

//分享, 获取用户信息
+ (void)HR_AppInfoByEmailOrMobileWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    RequestForm(AppInfoByEmailOrMobile);
}

/**
 * 3.消息
 */
+ (void)HR_AppPushListWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    RequestForm(AppPushList);
}

+ (void)HR_AppPushDetailWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",Service_IP,AppPushDetail,content];
    [[self getFormManager] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               success(responseObject);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               failure(error);
    }];
}

+ (void)HR_AppPushHaveReadWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",Service_IP,AppPushHaveRead,content];
    [[self getFormManager] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               success(responseObject);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               failure(error);
    }];
}

/**
 * 4.帮助
 */
+ (void)HR_AppAssistanceWithParams:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    RequestForm(AppAssistance);
}

//用户详情
+ (void)HR_AppUserInfoWithContent:(NSString *)content Params:(NSDictionary *)params success:(SuccessBlock)success failure:(FailureBlock)failure{
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",Service_IP,AppUserInfo,content];
    [[self getFormManager] POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               success(responseObject);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               failure(error);
    }];
}




@end
