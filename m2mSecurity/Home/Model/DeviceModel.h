//
//  DeviceModel.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceModel : NSObject

@property (nonatomic, strong)NSString *img;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, assign)NSInteger contentType;//0:EZ  1:二维码
@property (nonatomic, assign)BOOL isWangGuan;

@end

NS_ASSUME_NONNULL_END
