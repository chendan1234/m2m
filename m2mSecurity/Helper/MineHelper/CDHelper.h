//
//  CDHelper.h
//  security
//
//  Created by chendan on 2021/5/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CDCommonDefine.h"
#import "DeviceModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^SureBlock)(void);
typedef void(^TFSureBlock)(NSString *tf);
typedef void(^selectBlock)(NSString *selectValue);

 

//定义设备类型
typedef enum{
    DeviceCategroyCDYanGan  = 0,
    DeviceCategroyCDShiPing,
    DeviceCategroyCDMenChi,
    DeviceCategroyCDSOS,
    DeviceCategroyCDRenTi,
    DeviceCategroyCDShuiJin,
    DeviceCategroyCDWangGuan,
    DeviceCategroyCDShengGuang,
    DeviceCategroyCDYaoKong,
    DeviceCategroyCDOther,
} DeviceCategroyCD;

@class CDSubscribeModel;

@interface CDHelper : NSObject

//获取当前view 的 viewcontroller
+(UIViewController*)viewControllerWithView:(UIView *)view;

//获取当前屏幕显示的viewcontroller
+(UIViewController *)getCurrentVC;

//将16进制颜色转换成UIColor
+ (UIColor *)getColor:(NSString *)hexColor;

//倒计时
+(void)countTime:(UILabel *)sender;

//检查密码是否有效
+(BOOL)isValidatePassword:(NSString *)password;

//检查邮箱格式是否正确
+(BOOL)isValidateEmail:(NSString *)email;

//检测用户名
+(BOOL)isValidateUserName:(NSString *)userName;

//检测手机号是否正确
+(BOOL)isValidateTel:(NSString *)mobileNum;

//随机获取用户名
+(NSString *)getUsernameWithTel:(NSString *)tel;

//处理雄迈的错误
+(void)dealWithXiongMaiErrorWithCode:(NSInteger)code vc:(id)vc;
//处理平台错误
+(void)dealWithPingTaiErrorWithVC:(id)vc result:(id)result;

//json转字典
+(NSDictionary *)jsonToDic:(NSString *)jsonStr;

//字典转json
+(NSString *)dicToJson:(NSDictionary *)dic;

+(void)setUserInfoWith:(NSDictionary *)userDic token:(NSString *)token;

+(NSDictionary *)getUserInfo;

+(void)loginOut;

+(void)setupAlterWithVC:(id)vc title:(NSString *)title message:(NSString *)message sure:(SureBlock)sure;

+(NSString *)time_timestampToString:(NSInteger)timestamp;
+ (NSString *)time_timestampToString2:(NSInteger)timestamp;
+(NSString *)getServiceDayWith:(NSInteger)serviceDay;
+(void)createOrderWithVC:(id)vc model:(CDSubscribeModel *)model;
+(dispatch_source_t)countTimeWithLab:(UILabel *)lab time:(NSInteger)time;
+(void)setupTFAlertWithVC:(id)vc title:(NSString *)title placeHolder:(NSString *)placeHolder sure:(TFSureBlock)sure;
+(void)setupOneBtnAlterWithVC:(id)vc title:(NSString *)title message:(NSString *)message sure:(SureBlock)sure;

+ (NSString* )md5HexDigest:(NSString* )input;//md5加密, 用于涂鸦登录
+(NSString *)getWifiName;
+(NSString *)getDeviceImageModel:(TuyaSmartDeviceModel *)model;

+(void)setupHomeId:(long)homeId;
+(NSInteger)getHomeId;

+(NSString *)getCurrentTimeStrap;
+(NSString *)getBeforeTimeStrapWithDay:(NSInteger)day;

+ (void)judgeIsHavedWangGuanWithVc:(id)vc deviceModel:(TuyaSmartDeviceModel *)model;
+(BOOL)isHaveWangGuan;
+(BOOL)isWangGuan2:(TuyaSmartDeviceModel *)model;
+(TuyaSmartDeviceModel *)getWangGuanModel;

//获取 / 设置 当前的设备类型
+(NSString *)getDeviceCategory;
+(void)setDeviceCategoryWithCategory:(NSString *)category;

+(NSInteger)getDeviceCategoryWithModel:(TuyaSmartDeviceModel *)model;
+(BOOL)isShengGuangWithModel:(TuyaSmartDeviceModel *)model;
+(BOOL)isWangGuanWithModel:(TuyaSmartDeviceModel *)model;

+(DeviceModel *)setDeviceModelWithImage:(NSString *)imageStr title:(NSString *)title contentType:(NSInteger)contentType;

+(NSString *)getMMSSFromSS:(NSInteger)seconds;

//设置属性弹框
+(void)setupShuXingTanKuangWith:(NSArray *)dataArr viewH:(CGFloat)viewH title:(NSString *)title selectBlock:(selectBlock)selectBlock;

//获取未读消息条数
+(void)getNoReadMessageNum;

//更加url, 返回一张图片
+(UIImage *)getImageFromURL:(NSString *)fileURL;

+(NSString *)getUidWith:(NSString *)uid;


//多语言
+(NSString *)getLanguageWithKey:(NSString *)key;

//创建家庭之后, 绑定服务商
+(void)bindDefaultChannel;


@end

NS_ASSUME_NONNULL_END
