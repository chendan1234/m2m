//
//  TPSocialLoginModel.h
//  TuyaSmartPublic
//
//  Created by 冯晓 on 16/3/10.
//  Copyright © 2016年 Tuya. All rights reserved.
//

#import "TYSocialProtocol.h"

@interface TPSocialLoginModel : NSObject

+ (instancetype)modelWithJSON:(NSDictionary *)json;


@property (nonatomic, strong) NSString          *userId;

@property (nonatomic, strong) NSString          *accessToken;

@property (nonatomic, strong) NSString          *accessTokenSecret;

@property (nonatomic, strong) NSString          *code;

@property (nonatomic, strong) NSString          *nickName;

@property (nonatomic, strong) NSString          *headPic;

@property (nonatomic, strong) NSString          *expirationDate;

@property (nonatomic, assign) TYSocialType      type;

@end
