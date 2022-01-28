//
//  HelpModel.h
//  m2mSecurity
//
//  Created by chendan on 2021/10/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelpModel : NSObject

//assistanceId = 1d05da474ae64757bac142a6a9f9cce8;
//content = "<p>\U8bbfk</p>";
//createTime = 1628563655000;
//publishName = admin;
//publishTime = 1628564006000;
//status = 1;
//title = 1234567890123456789012345678901;

@property (nonatomic, assign)NSInteger createTime;
@property (nonatomic, assign)NSInteger publishTime;
@property (nonatomic, strong)NSString *assistanceId;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *publishName;
@property (nonatomic, strong)NSString *title;

@end

NS_ASSUME_NONNULL_END
