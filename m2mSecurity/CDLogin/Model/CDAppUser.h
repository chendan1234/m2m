//
//  CDAppUser.h
//  security
//
//  Created by chendan on 2021/6/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDAppUser : NSObject

//var userId:String?
//var username:String?
//var password:String?=nil
//var sex:String?
//var mobile:String=""
//var status:String?
//var lastLoginTime:Int?
//var createTime:Int?
//var online:String?
//var email:String=""
//var expireTime:Int?
//var isDelete:String?
//var avatarUrl:String?
//var grade:String?
//var address:String?

@property (nonatomic, strong)NSString *userId;
@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *password;
@property (nonatomic, strong)NSString *sex;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSString *status;
@property (nonatomic, strong)NSString *online;
@property (nonatomic, strong)NSString *email;
@property (nonatomic, strong)NSString *isDelete;
@property (nonatomic, strong)NSString *avatarUrl;
@property (nonatomic, strong)NSString *grade;
@property (nonatomic, strong)NSString *address;
@property (nonatomic, strong)NSString *tokenId;
@property (nonatomic, assign)BOOL isGuide;
@property (nonatomic, assign)NSInteger lastLoginTime;
@property (nonatomic, assign)NSInteger expireTime;
@property (nonatomic, assign)NSInteger createTime;
@property (nonatomic, assign)NSString *deviceId;
@property (nonatomic, assign)NSString *registrationID;
@property (nonatomic, assign)BOOL isLogin;
@property (nonatomic, assign)BOOL isPush;

+(void)setUser:(CDAppUser *)user;

+(CDAppUser *)getUser;


@end

NS_ASSUME_NONNULL_END
