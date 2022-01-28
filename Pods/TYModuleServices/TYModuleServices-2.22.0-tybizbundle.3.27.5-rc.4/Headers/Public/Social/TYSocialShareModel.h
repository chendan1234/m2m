//
//  TYSocialShareModel.h
//  TYSocial
//
//  Created by TuyaInc on 2018/5/31.
//

#import <Foundation/Foundation.h>
#import "TYSocialProtocol.h"

@interface TYSocialShareModel : NSObject

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSArray<NSString *> *recipients;
@property (copy, nonatomic) NSArray<NSString *> *ccRecipients;
@property (copy, nonatomic) NSArray<NSString *> *bccRecipients;

@property (assign, nonatomic) TYSocialShareContentType mediaType;
@property (assign, nonatomic) TYSocialType shareType;

@property (nonatomic, assign) BOOL needCopyLink;
@property (nonatomic, strong) NSArray<NSNumber/*TYSocialType*/ *> *blackList;

+ (instancetype)modelWithShareType:(TYSocialType)shareType;
- (instancetype)initWithShareType:(TYSocialType)shareType;

@end
