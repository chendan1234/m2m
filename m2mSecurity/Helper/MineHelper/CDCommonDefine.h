//
//  CDCommonDefine.h
//  security
//
//  Created by chendan on 2021/5/25.
//

#ifndef CDCommonDefine_h
#define CDCommonDefine_h

//设备的宽度
#define DEVICE_WIDRH            ([UIScreen mainScreen].bounds.size.width*1.0f)

//设备的高度
#define DEVICE_HEIGHT           ([UIScreen mainScreen].bounds.size.height*1.0f)

//颜色
#define KColorA(r, g, b,a)  [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define KBlueColor [UIColor colorWithRed:(0)/255.0 green:(122)/255.0 blue:(255)/255.0 alpha:(1.0)]

#define KNormalBlueColor [UIColor colorWithRed:(0)/255.0 green:(177)/255.0 blue:(227)/255.0 alpha:(1.0)]

//随机色
#define KRandomColor KColorA(arc4random_uniform(240), arc4random_uniform(230), arc4random_uniform(255),1)


//存储
#define KFindPasswordAccount @"KFindPasswordAccount" //找回密码的账号(邮箱或手机号)


#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight ([[UIScreen mainScreen] bounds].size.height+20-APP_STATUSBAR_HEIGHT)
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height+20-APP_STATUSBAR_HEIGHT)
#define APP_STATUSBAR_HEIGHT (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
#define NavAndStatusHight  self.navigationController.navigationBar.frame.size.height+APP_STATUSBAR_HEIGHT
//获取状态栏和导航条的高度总和
#define getRectNavAndStatusHight  self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height

#define realPlayViewHeight (ScreenHeight > ScreenWidth ? ScreenWidth * 0.8 : ScreenHeight * 0.8)
#define DeviceVersion [[CommonControl getInstance] getDeviceString]
#define NavHeight 64

//token
#define Token  [[[NSUserDefaults standardUserDefaults] objectForKey:KToken] length] ? [[NSUserDefaults standardUserDefaults] objectForKey:KToken] : @""

#define Formal  [[[NSUserDefaults standardUserDefaults] objectForKey:KFormal] length] ? [[NSUserDefaults standardUserDefaults] objectForKey:KFormal] : @""

//弱引用
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;


#define KLanguage @"CDLanguage"

#define KToken @"token"
#define KUserId @"KUserId"
#define KNewFeature @"KNewFeature"
#define KHomeId @"KHomeId"
#define KWiFiName @"KWiFiName"
#define KWiFiPassword @"KWiFiPassword"
#define KIsHaveWangGuan @"KIsHaveWangGuan"
#define KHavedWangGuan @"KHavedWangGuan"

#define KCategory @"KCategory"
#define KHaveNoti @"KHaveNoti"
#define KUpdateExpireTime @"KUpdateExpireTime"
#define KChangeUserIcon @"KChangeUserIcon"
#define KRecNoti @"KRecNoti"






//开放平台App信息，需要在开放平台上面创建APP来生成，每一个APP对应一组不同并且唯一的平台信息，不能重复,如果直接使用下面参数，则后续可能会出现各种问题
#define APPUUID "e0534f3240274897821a126be19b6d46"   //客户唯一标识
#define APPKEY "caae4d4cebd842d99b86263533b8c50b"   //APP唯一标识
#define APPSECRET "3cb982572d4b4ff998a27e442fc60a16"   //内容保护参数
#define MOVECARD 4   //内容保护参数




//#define KToken @"KToken"

#define KMobile @"KMobile"
#define KPassword @"KPassword"
#define KAgree @"KAgree"
#define KLoginAccount @"KLoginAccount"

//标题
#define KChangePwdTitle @"修改密码"
#define KChangePhoneTitle @"修改手机号码"
#define KFindPwdTitle @"找回密码"
#define KRegisterTitle @"注册新用户"
#define KLoginTitle @"登录"
#define KMineTitle @"我的"
#define KChangeUserInoTitle @"修改个人资料"



//错误
#define KNetWorkError @"网络请求失败!"
#define KTelError @"手机号格式不正确!"
#define KTelOrEmailError @"手机号或邮箱格式不正确!"
#define KTelOrEmailEmptyError @"手机号或邮箱不能为空!"
#define KTelEmptyError @"请输入手机号码!"
#define KEmailError @"邮箱格式不正确!"
#define KEmailEmptyError @"请输入邮箱地址!"
#define KSurePasswordError @"两次输入密码不一致!"
#define KPasswordError @"密码8-32位必须包含数字和字母!"
#define KPasswordEmptyError @"密码不能为空!"
#define KOldPasswordEmptyError @"请输入旧密码!"
#define KNewPasswordEmptyError @"请输入新密码!"
#define KCodeError @"请输入短信验证码!"
#define KAgreeError @"必须同意用户服务协议才能注册!"
#define KLoginError @"登录失败!"
#define KChangePwdError @"新登录密码与旧登录密码相同!"
#define KMailNumError @"每个邮箱一天做多发送三次验证码"


//操作
#define KDeleteDeviceSuccess @"设备删除成功"
#define KDeleteDeviceFail @"设备删除失败"
#define KGetDeviceFailToLogin @"获取设备列表失败, 请重新登录!"
#define KGoToYuLan @"进入预览界面"
#define KEnterPhoneOrEmail @"请输入手机号码或邮箱地址"
#define KEnterPhone @"请输入手机号码"
#define KRegistering @"正在注册..."
#define KRegisterSuccess @"用户注册成功!"
#define KChangePwdSuccess @"密码修改成功, 请重新登录!"
#define KChangePwdFail @"密码修改失败!"
#define KChangePwding @"正在修改密码..."
#define KChecking @"正在校验..."
#define KNext @"下一步"
#define KOver @"完成"
#define KEnterCode @"请输入短信验证码"
#define KLogining @"正在登陆..."
#define KPhoneRegister @"手机注册"
#define KEmailRegister @"邮箱注册"
#define KSendCode @"正在发送验证码..."









#endif /* CDCommonDefine_h */
