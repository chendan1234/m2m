//
//  CDHelper.m
//  security
//
//  Created by chendan on 2021/5/25.
//

#import "CDHelper.h"
#import <CommonCrypto/CommonDigest.h>
#import "UIView+ProgressView.h"

#import "CDLoginViewController.h"

#import "HttpRequest.h"
#import "CDSubscribeModel.h"
#import "CDPayViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "ShuXingView.h"
#import "LSTPopView.h"


@interface CDHelper()<TuyaSmartHomeDelegate>

@end

@implementation CDHelper

#pragma mark---------------单利---------------
+ (id)shareInstace{
    static id shareInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstace = [[CDHelper alloc]init];
    });
    return shareInstace;
}

#pragma mark---------------获取当前view 的 viewcontroller---------------
+(UIViewController*)viewControllerWithView:(UIView *)view{
    UIView *tmpSupView = view.superview;
    UIResponder* nextResponder = [tmpSupView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return (UIViewController*)nextResponder;
    }else{
        return [CDHelper viewControllerWithView:tmpSupView];
    }
}

#pragma mark---------------获取当前屏幕显示的viewcontroller---------------
+(UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

#pragma mark -- 将16进制颜色转换成UIColor
+ (UIColor *)getColor:(NSString *)hexColor {
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}

//验证码 倒计时按钮
+(void)countTime:(UILabel *)sender
{
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                sender.text = @"再次发送";
                sender.userInteractionEnabled = YES;
//                sender.textColor = KBlueColor;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                sender.text = [NSString stringWithFormat:@"%@s", strTime];
                sender.userInteractionEnabled = NO;
//                sender.textColor = KColorA(180, 180, 180, 1);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}


#pragma mark 检测密码格式 密码8-32位必须包含数字和字母
+(BOOL)isValidatePassword:(NSString *)password {
    //密码字符格式
    NSString * regex = @"(?![^a-zA-Z0-9]+$)(?![^a-zA-Z/D]+$)(?![^0-9/D]+$).{8,32}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:password]&&(password.length <= 32)&&(password.length >= 8);
}

#pragma mark 检测邮箱格式
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark 检测用户名是否合法 4-32位，由中文/字母/数字组成，但不能是纯数字
+(BOOL)isValidateUserName:(NSString *)userName {
    NSInteger length = [userName lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    length -= (length - userName.length) / 2;
    if (length<4||length>15) {
        return NO;
    }
    
    NSString *userNameregex = @"([\u4e00-\u9fa5]|[a-zA-Z0-9_]){4,32}$";
    NSPredicate *userNamepred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameregex];
    return [userNamepred evaluateWithObject:userName];
}

#pragma mark 手机号码校验
+(BOOL)isValidateTel:(NSString *)mobileNum{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
//    NSString * PHS = @"^((\\+86)|(86))?(1)\\d{10}$";
    
    NSString *PHS = @"^(17[0-9]|13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES)
        || ([regextestphs evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//随机获取用户名
+(NSString *)getUsernameWithTel:(NSString *)tel{
    return [NSString stringWithFormat:@"m2m%@",tel];
}



//json转字典
+(NSDictionary *)jsonToDic:(NSString *)jsonStr{
    NSError * error = nil;
    NSData * getJsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:&error];
    
}

//字典转json
+(NSString *)dicToJson:(NSDictionary *)dic{
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+(void)setUserInfoWith:(NSDictionary *)userDic token:(NSString *)token{
    NSMutableDictionary *dic = (NSMutableDictionary *)[self getUserInfo];
    dic[@"loginToken"] = token;
    dic[@"userId"] = userDic[@"userId"];
    dic[@"userName"] = userDic[@"userName"];
    dic[@"phone"] = userDic[@"mobile"];
    dic[@"email"] = userDic[@"email"];
    dic[@"address"] = userDic[@"address"];
    dic[@"sex"] = userDic[@"sex"];
    
    [self saveUserInfo:dic];
    
}

+(NSDictionary *)getUserInfo{
    NSString *jsonStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"userInfo"];
    return [self jsonToDic:jsonStr];
}

+(void)saveUserInfo:(NSDictionary *)info{
    [[NSUserDefaults standardUserDefaults]setObject:[self dicToJson:info] forKey:@"userInfo"];
}


+(void)dealWithXiongMaiErrorWithCode:(NSInteger)code vc:(id)vc{
    UIViewController *showVC = (UIViewController *)vc;
    NSString *msg = @"发生错误, 请稍后重试!";
    NSString *codeStr = [NSString stringWithFormat:@"%ld",code];
    NSInteger realCode = [[codeStr substringFromIndex:3] intValue];
    switch (realCode) {
        case 4000:
            msg = @"用户名或密码错误";
            break;
        case 4010:
            msg = @"验证码错误";
            break;
        case 4011:
            msg = @"密码不一致";
            break;
        case 4012:
            msg = @"用户已存在";
            break;
        case 4013:
            msg = @"用户名为空";
            break;
        case 4014:
            msg = @"密码为空";
            break;
        case 4015:
            msg = @"确认密码为空";
            break;
        case 4016:
            msg = @"手机号为空";
            break;
        case 4017:
            msg = @"用户名格式不正确";
            break;
        case 4018:
            msg = @"密码格式不正确";
            break;
        case 4019:
            msg = @"确认密码格式不正确";
            break;
        case 4020:
            msg = @"手机号格式不正确";
            break;
        case 4021:
            msg = @"手机号已存在";
            break;
        case 4022:
            msg = @"手机号不存在";
            break;
        case 4023:
            msg = @"邮箱已存在";
            break;
        case 4024:
            msg = @"邮箱不存在";
            break;
        case 4025:
            msg = @"用户不存在";
            break;
        case 4026:
            msg = @"原密码错误";
            break;
        case 4027:
            msg = @"修改密码失败";
            break;
        case 4029:
            msg = @"用户ID为空";
            break;
        case 4030:
            msg = @"验证码为空";
            break;
        case 4031:
            msg = @"邮箱为空";
            break;
        case 4032:
            msg = @"邮箱格式不正确";
            break;
        case 4100:
            msg = @"设备非法不允许添加";
            break;
        case 4101:
            msg = @"设备已经存在";
            break;
        case 4104:
            msg = @"设备uuid参数异常";
            break;
        case 4105:
            msg = @"设备用户名参数异常";
            break;
        case 4106:
            msg = @"设备密码参数异常";
            break;
        case 4300:
            msg = @"发送失败";
            break;
        case 4400:
            msg = @"短信接口验证失败，请联系我们";
            break;
        case 4401:
            msg = @"短信接口参数错误，请联系我们";
            break;
        case 4402:
            msg = @"每个手机号一天最多发送三次验证码";
            break;
        case 4403:
            msg = @"发送失败，请稍后再试";
            break;
        case 4404:
            msg = @"发送太频繁了，请间隔2分钟";
            break;
            
        default:
            break;
    }
    
    [showVC.view pv_failureLoading:msg];
}

+(void)dealWithPingTaiErrorWithVC:(id)vc result:(id)result
{
    if ([vc isKindOfClass:[UIViewController class]]) {
        UIViewController *VC = (UIViewController *)vc;
        NSString *errorMessage = result[@"message"];
        if (errorMessage.length) {
            [VC.view pv_warming:errorMessage];
        }
        
        if ([result[@"code"] intValue] == 501) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loginOut];
            });
        }
    }
}

+(void)loginOut{
    [[TuyaSmartUser sharedInstance]loginOut:^{
        [CDAppUser setUser:[[CDAppUser alloc]init]];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:KUserId];
        [self setupHomeId:0];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc]initWithRootViewController:[[CDLoginViewController alloc]init]];
    } failure:^(NSError *error) {
        [[UIApplication sharedApplication].keyWindow pv_failureLoading:@"退出登录失败"];
    }];
}


+(void)setupAlterWithVC:(id)vc title:(NSString *)title message:(NSString *)message sure:(SureBlock)sure{
    
    if (![vc isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    UIViewController *VC = (UIViewController *)vc;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
    
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sure();
    }]];
        
    dispatch_async(dispatch_get_main_queue(), ^{
        //present出AlertView
        [VC presentViewController:alertController animated:YES completion:nil];
    });
}

+ (NSString *)time_timestampToString:(NSInteger)timestamp{

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];

    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];

     [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSString* string=[dateFormat stringFromDate:confromTimesp];

    return string;

}

+ (NSString *)time_timestampToString2:(NSInteger)timestamp{

    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];

    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];

     [dateFormat setDateFormat:@"yyyy-MM-dd"];

    NSString* string=[dateFormat stringFromDate:confromTimesp];

    return string;

}

+(NSString *)getServiceDayWith:(NSInteger)serviceDay{
    
    NSInteger year = serviceDay / 365;
    NSInteger last = serviceDay % 365;
    NSInteger month = last / 30;
    
    NSString *yearStr = @"";
    if (year) {
        yearStr = [NSString stringWithFormat:@"%ld年",year];
    }
    
    NSString *monthStr = @"";
    if (month) {
        monthStr = [NSString stringWithFormat:@"%ld个月",month];
    }
    
    return [NSString stringWithFormat:@"%@%@",yearStr,monthStr];
    
}

+(void)createOrderWithVC:(id)vc model:(CDSubscribeModel *)model{
    
    if (![vc isKindOfClass:[UIViewController class]]) {
        return;
    }
    UIViewController *VC = (UIViewController *)vc;
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"amount"] = @(model.money/100);
    parames[@"life"] = @(model.serviceDay);
    parames[@"service_name"] = model.serviceName;
    parames[@"user_id"] = [[NSUserDefaults standardUserDefaults]objectForKey:KUserId];
    
    [VC.view pv_showTextDialog:@"正在生成订单..."];
    [HttpRequest HR_PaymentWithParams:parames success:^(id result) {
        [VC.view pv_hideMBHub];
        if ([result[@"code"] intValue] == 200) {
            NSData *jsonData = [result[@"data"] dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            model.paymentIntentClientSecret = result[@"clientSecret"];
            CDPayViewController *payVC = [[CDPayViewController alloc]init];
            payVC.model = model;
            [VC.navigationController pushViewController:payVC animated:YES];
        }else{
            [self dealWithPingTaiErrorWithVC:VC result:result];
        }
    } failure:^(NSError *error) {
        [VC.view pv_failureLoading:KNetWorkError];
    }];
}

+(dispatch_source_t)countTimeWithLab:(UILabel *)lab time:(NSInteger)time
{
    if ([lab.text containsString:@"剩余"]) {
        return nil;
    }
    __block NSInteger timeout = time/1000 + 15*60 - [[NSDate date] timeIntervalSince1970];//倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                lab.text = @"剩余00:00";
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                lab.text = [NSString stringWithFormat:@"剩余%@",[self getMMSSFromSS:timeout]];
                timeout--;
            });
            
        }
    });
    dispatch_resume(_timer);
    
    return _timer;
}

//传入 秒  得到 xx:xx:xx
+(NSString *)getMMSSFromSS:(NSInteger)seconds{

//    NSInteger seconds = [totalTime integerValue];
    
//    NSString *hour = [NSString stringWithFormat:@"%02ld",(seconds/3600)];
    //format of minute
    NSString *minute = [NSString stringWithFormat:@"%02ld",(seconds/60)];
    //format of second
    NSString *second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",minute,second];

    return format_time;

}


//弹框
+(void)setupTFAlertWithVC:(id)vc title:(NSString *)title placeHolder:(NSString *)placeHolder sure:(TFSureBlock)sure{
    
    if (![vc isKindOfClass:[UIViewController class]]) {
        return;
    }
    UIViewController *VC = (UIViewController *)vc;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        
    //在AlertView中添加一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = placeHolder;
    }];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *field = alertController.textFields.firstObject;
        if (field.text.length) {
            sure(field.text);
        }else{
            [VC.view pv_warming:placeHolder];
        }
    }]];
        
        
        
    //present出AlertView
    [VC presentViewController:alertController animated:YES completion:nil];
}


+(void)setupOneBtnAlterWithVC:(id)vc title:(NSString *)title message:(NSString *)message sure:(SureBlock)sure{
    
    if (![vc isKindOfClass:[UIViewController class]]) {
        return;
    }
    
    UIViewController *VC = (UIViewController *)vc;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sure();
    }]];
        
    dispatch_async(dispatch_get_main_queue(), ^{
        //present出AlertView
        [VC presentViewController:alertController animated:YES completion:nil];
    });
}

+ (NSString* )md5HexDigest:(NSString* )input {
    const char *cStr = [input UTF8String];

        unsigned char result[CC_MD5_DIGEST_LENGTH];

        CC_MD5(cStr, strlen(cStr), result);

        return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",

                 result[0], result[1], result[2], result[3],

                 result[4], result[5], result[6], result[7],

                 result[8], result[9], result[10], result[11],

                 result[12], result[13], result[14], result[15]

                 ] lowercaseString];
}

+(NSString *)getWifiName{
    NSString *ssid = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            ssid = [dict valueForKey:@"SSID"];
        }
    }
    return ssid;
}


+(NSString *)getDeviceImageModel:(TuyaSmartDeviceModel *)model{
    
    switch ([self getDeviceCategoryWithModel:model]) {
        case DeviceCategroyCDYanGan:
            return @"yg";
            break;
        case DeviceCategroyCDShiPing:
            return @"ml";
            break;
        case DeviceCategroyCDMenChi:
            return @"mc";
            break;
        case DeviceCategroyCDSOS:
            return @"an";
            break;
        case DeviceCategroyCDRenTi:
            return @"rt";
            break;
        case DeviceCategroyCDShuiJin:
            return @"sq";
            break;
        case DeviceCategroyCDWangGuan:
            return @"wg";
            break;
        case DeviceCategroyCDShengGuang:
            return @"sg";
            break;
        case DeviceCategroyCDYaoKong:
            return @"yk";
            break;
        default:
            return @"otherDevice";
            break;
    }
}

+(NSInteger)getDeviceCategoryWithModel:(TuyaSmartDeviceModel *)model{
    if ([model.productId isEqualToString:@"7zkjofkrlff3yxlv"]) {//烟感
        return DeviceCategroyCDYanGan;
    }else if ([model.productId isEqualToString:@"h6brxbdbw4wsot96"] || [model.productId isEqualToString:@"dlffgowcxktqh5oj"] || [model.productId isEqualToString:@"zqc6ufv4naw3mjhv"]){//视频
        return DeviceCategroyCDShiPing;
    }else if ([model.productId isEqualToString:@"zhyza6vd"] || [model.productId isEqualToString:@"bwoihqun"]) {//门磁
        return DeviceCategroyCDMenChi;
    }else if ([model.productId isEqualToString:@"ssp0maqm"] || [model.productId isEqualToString:@"yjag38a2"]) {//紧急按钮
        return DeviceCategroyCDSOS;
    }else if ([model.productId isEqualToString:@"2b8f6cio"] || [model.productId isEqualToString:@"bczzxyyk"]) {//人体
        return DeviceCategroyCDRenTi;
    }else if ([model.productId isEqualToString:@"nwpihrkp"]) {//水侵
        return DeviceCategroyCDShuiJin;
    }else if ([model.productId isEqualToString:@"ynsiasng"] || [model.productId isEqualToString:@"51zp2vqj"]) {//声光
        return DeviceCategroyCDShengGuang;
    }else if ([model.productId isEqualToString:@"fovktdyyal9ni4fc"] || [model.productId isEqualToString:@"tbdtdlawwbfrygmu"]) {//网关
        return DeviceCategroyCDWangGuan;
    }else if ([model.productId isEqualToString:@"p6ju8myv"] || [model.productId isEqualToString:@"kc1jrt0c"]) {//遥控
        return DeviceCategroyCDYaoKong;
    }
    
    return DeviceCategroyCDOther;
}

//是否是声光
+(BOOL)isShengGuangWithModel:(TuyaSmartDeviceModel *)model{
    if ([self getDeviceCategoryWithModel:model] == DeviceCategroyCDShengGuang) {
        return YES;
    }else{
        return NO;
    }
}

+(BOOL)isWangGuanWithModel:(TuyaSmartDeviceModel *)model{
    if ([self getDeviceCategoryWithModel:model] == DeviceCategroyCDWangGuan) {
        return YES;
    }else{
        return NO;
    }
}



+(void)setupHomeId:(long)homeId{
    [[NSUserDefaults standardUserDefaults] setObject:@(homeId) forKey:KHomeId];
}

+(NSInteger)getHomeId{
    return [[[NSUserDefaults standardUserDefaults]objectForKey:KHomeId] longValue];
}

+ (NSString *)getCurrentTimeStrap{
    NSInteger millisecond = [[NSDate date] timeIntervalSince1970] * 1000;
    return [NSString stringWithFormat:@"%ld",millisecond];
}

+ (NSString *)getBeforeTimeStrapWithDay:(NSInteger)day{
    NSInteger millisecond = [[NSDate date] timeIntervalSince1970];
    NSInteger time = (millisecond - day * 60 * 60 * 24)*1000;
    return [NSString stringWithFormat:@"%ld",time];
}

+ (void)judgeIsHavedWangGuanWithVc:(id)vc deviceModel:(TuyaSmartDeviceModel *)model {
    
    if ([self isWangGuan2:model]) {// 添加的是网关设备, 且已经有网关设备了
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:KHavedWangGuan object:nil userInfo:nil];
        
        TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:[CDHelper getHomeId]];
        NSMutableArray *wangGuanArr = [[NSMutableArray alloc]init];
        for (TuyaSmartDeviceModel *deviceModel in home.deviceList) {
            if ([self isWangGuan2:deviceModel]) {
                [wangGuanArr addObject:deviceModel];
            }
        }
        
        if (wangGuanArr.count >=2 ) {
            TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:model.devId];
            [device remove:^{
                [self setupOneBtnAlterWithVC:vc title:@"网关设备添加失败!" message:@"一个家庭只允许添加一个网关, 您已有网关设备, 您可删除之前的网关再做添加..." sure:^{
                    UIViewController *VC = (UIViewController *)vc;
                    [VC.navigationController popToRootViewControllerAnimated:YES];
                }];
            } failure:^(NSError *error) {
                [self judgeIsHavedWangGuanWithVc:vc deviceModel:model];
            }];
        }
    }
}

+(BOOL)isHaveWangGuan{
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:KIsHaveWangGuan] isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}


+(BOOL)isWangGuan2:(TuyaSmartDeviceModel *)model{
    if (model.deviceType == 4) {
        return YES;
    }else{
        return NO;
    }
}

+(TuyaSmartDeviceModel *)getWangGuanModel{
    TuyaSmartHome *home = [TuyaSmartHome homeWithHomeId:[CDHelper getHomeId]];
    for (TuyaSmartDeviceModel *deviceModel in home.deviceList) {
        if ([self isWangGuan2:deviceModel]) {
            return deviceModel;
        }
        
//        if ([self getDeviceCategoryWithModel:deviceModel] == DeviceCategroyCDWangGuan) {
//            return deviceModel;
//        }
    }
    return nil;
}

+(NSString *)getDeviceCategory{
    return [[NSUserDefaults standardUserDefaults] objectForKey:KCategory];
}

+(void)setDeviceCategoryWithCategory:(NSString *)category{
    [[NSUserDefaults standardUserDefaults] setObject:category forKey:KCategory];
}


+(DeviceModel *)setDeviceModelWithImage:(NSString *)imageStr title:(NSString *)title contentType:(NSInteger)contentType{
    DeviceModel *model = [[DeviceModel alloc]init];
    model.img = imageStr;
    model.title = title;
    model.contentType = contentType;
    return model;
}

//设置属性弹框
+(void)setupShuXingTanKuangWith:(NSArray *)dataArr viewH:(CGFloat)viewH title:(NSString *)title selectBlock:(selectBlock)selectBlock{
    ShuXingView *view = [ShuXingView reload];
    view.frame = CGRectMake(0, DEVICE_HEIGHT - viewH, DEVICE_WIDRH, viewH);
    view.dataArr = dataArr;
    view.title = title;
    view.layer.cornerRadius = 15;
    view.layer.masksToBounds = YES;
    
    
    LSTPopView *popView = [LSTPopView initWithCustomView:view popStyle:LSTPopStyleSpringFromBottom dismissStyle:LSTDismissStyleSmoothToBottom];
    LSTPopViewWK(popView)
    popView.hemStyle = LSTHemStyleBottom;
    popView.popDuration = 0.25;
    popView.dismissDuration = 0.5;
    popView.isClickFeedback = YES;
    
    
    [view setSelectBlock:^(NSString * _Nonnull value) {
        selectBlock(value);
        [wk_popView dismiss];
    }];
    
    [view setCancelBlock:^{
        [wk_popView dismiss];
    }];
    
    [popView pop];
}


//获取未读消息条数
+(void)getNoReadMessageNum{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"page"] = @(1);
    parames[@"size"] = @(1);
    parames[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:KUserId];
    
    [HttpRequest HR_AppPushListWithParams:parames success:^(id result) {
        if ([result[@"code"] intValue] == 200) {
            NSString *noRead = result[@"data"][@"nread"];
            [[NSNotificationCenter defaultCenter] postNotificationName:KHaveNoti object:noRead];
        }
    } failure:^(NSError *error) {}];
}


//更加url, 返回一张图片
+(UIImage *)getImageFromURL:(NSString *)fileURL {
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    return [UIImage imageWithData:data];
}

+(NSString *)getUidWith:(NSString *)uid{
    return [NSString stringWithFormat:@"m2m%@_m2m",uid];
}


+(NSString *)getLanguageWithKey:(NSString *)key{
    return NSLocalizedStringFromTable(key, KLanguage, @"");
}


//创建家庭之后, 绑定服务商
+(void)bindDefaultChannel{
    //创建家庭后, 绑定服务商
    [[TuyaSecurityChannel new] bindDefaultChannelCode:^(BOOL result) {
        // do something
        NSLog(@"securityChannel----%d",result);
    } failure:^(NSError * _Nonnull error) {
        // do something
        NSLog(@"securityChannelError----%@",error);
    }];
}


@end
