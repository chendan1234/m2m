//
//  CDArmModel.h
//  m2mSecurity
//
//  Created by chendan on 2022/1/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDArmModel : NSObject

@property (nonatomic, copy) void(^overBlock)(void);//成功保存设备
@property (nonatomic, copy) void(^failBlock)(NSString *reason);//失败

-(void)saveDevice;//保存设备



@end

NS_ASSUME_NONNULL_END
