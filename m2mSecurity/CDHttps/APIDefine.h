//
//  APIDefine.h
//  YouJia
//
//  Created by user on 15/6/4.
//  Copyright (c) 2015年 hhxh. All rights reserved.
//

#ifndef YouJia_APIDefine_h
#define YouJia_APIDefine_h
/**
 * 本类描述:所有的API借口宏定义
 */

//token
//#define Token  [CDAppUser getUser].tokenId




#define KPuclic @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCsLGekXJFaFk9ncuEaK6iJn00cczBZ+F8hJlpPetOC1YB4cPbmOwUHOXjE1r64CuMpQxYfJojdYxXzLk/s5/Ykd5jGdYMjbts3P6NgeS7DCdF+KJT3F18xpkOD/rVHdN1pnlWuim2U6EeSE9RTXvR5h1aRZLw2At1sC6HAY/7UfwIDAQAB"

#define KPrivate @"MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAJJ9SsIumi+QSq9jhJ3jOivaDtixFn3ZGIzW/xZbnxqojWC5Dm8lMqRnmNdBXHSTmGu+Z2C6mlWydSZa4wbD6cYT9eeRu0wldF/omsWJHV9Rx0hKHDUo3aiV00yrIQgshuMP18wy46yUktdd0BYrxGuljoAcyjxZfmg7VNGNCxptAgMBAAECgYAxOnnNF+wo38y5dDA0/w+lfPpQR/LPCA4ABqBi2xd01f/s6UO4hj+mkEoEzKpNYuxuCOak0xDai8ZixVhWBbChpg4T3XTcd1OkLMgpjiuAtDpFoxPUXc6ssmL3ah7kvLo2FFfLy0bUHWXNKSjHUd4tkgZ4YAS/J7JFQbgGJd0Z4QJBAMcsvvPCAYpoA7vRwNg0Syht6kGL5W+m+/MtXbUzVfuVe+w3QB3N19g4aGTgX7EE39Osfyt9bUlkKHrDFCgf9RcCQQC8SIgrTzD8IMbsA5763wyKHdUXPS9v5wvYHvwbJNoicueTDZ9Lo71wc5qYt1sKQpMp5Zo079Q3+ntns/YkcGcbAkBNWgdey32lrvekPbXTQZveu7E6e4ZDcmpu6rN159YAuvFBr8Nqz8J/6ohAhRMkwGvc3SUWUsPauNcvtgth+edJAkBwcNhxFM/qIiDpnZf5te6lJP+26yFDMLXQEWD5TN7AJ+LH3SC+aUCewUsX3JgP3oZIRQf8iSUxcPL1kXFzfXT1AkAhyiDC1PDzBX8VBMGU/a4JtlaYtDZEDTI/2G2bpiLoz6r+yN8H7nqZsSbDb/kCi0046BFzzixubtNd39evRoRn"


//userID
//#define YouJiaUserID @"30001"
/**
 * 1.服务器地址
 */
//数据服务器地址

//测试库
//#define Service_IP @"http://8b9f5162.ngrok.io/api/"

//正式
#define Service_IP @"http://192.168.1.4:8000/"

//陈洪树本地
//#define Service_IP @"http://192.168.1.37:8000/"


/**
 * 1.新特性
 */
//1.1新特性接口
#define AppNewestAppSetting @"m2micro-app/appSetting/appNewestAppSetting"


/**
 * 2.登陆注册模块
 */
//2.1登陆App
#define Login @"m2micro-auth/app/login"
#define AppTuya @"m2micro-app/appTuya/mapping"

//涂鸦密码
#define TuYapassword @"m2micro-app/appTuya/password"

//上传图片
#define Image_upload @"m2micro-app/appUserController/upload"

//修改个人资料
#define ModifyPersonalData @"m2micro-app/appUserController/modifyPersonalData"

//阿里云验证
#define Authorize @"m2micro-auth/member/oauth/authorize"
#define pushDeviceId @"m2micro-app/appUserDevice/relation"
//注册
#define RegisterApp @"m2micro-app/appUserController/register"

//手机发送验证码
#define SendSmS @"m2micro-app/appUserController/sendSmS"

//邮箱发送验证码
#define EmailSend @"m2micro-app/appUserController/emailSend"

//校验手机号或者邮箱
#define VerificationSmsOrEmail @"m2micro-app/appUserController/verificationSmsOrEmail"

//找回密码
#define RetrievePassword @"m2micro-app/appUserController/retrievePassword"


//修改邮箱
#define ModifyMailbox @"m2micro-app/appUserController/modifyMailbox"

//修改手机号
#define ModifyMobilePhoneNumber @"m2micro-app/appUserController/modifyMobilePhoneNumber"

//修改密码
#define UpdatePassword @"m2micro-app/appUserController/updatePassword"


//订阅列表
#define AppList @"m2micro-app/pay/appList"

//支付参数
#define Payment @"m2micro-app/pay/payment"

//订单列表
#define OrderAppList @"m2micro-app/appOrder/appList"

//订单详情
#define OrderAppInfo @"m2micro-app/appOrder/appInfo"

//退款
#define Refund @"m2micro-app/pay/refund"

//分享, 获取用户信息
#define AppInfoByEmailOrMobile @"m2micro-app/appUserController/appInfoByEmailOrMobile"


/**
 * 3.消息
 */
#define AppPushList @"m2micro-app/appPush/list"
#define AppPushDetail @"m2micro-app/appPush/info"
#define AppPushHaveRead @"m2micro-app/appPush/haveRead"

/**
 * 4.帮助
 */
#define AppAssistance @"m2micro-app/appAssistance/appList"

//用户详情
#define AppUserInfo @"m2micro-app/appUserController/appInfo"






#endif
