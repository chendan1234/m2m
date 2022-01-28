//
//  NonomalDeviceView.h
//  m2mSecurity
//
//  Created by chendan on 2021/12/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NonomalDeviceView : UIView

+(instancetype)reload;

@property (nonatomic, copy) void(^cancelBlock)(void);
@property (nonatomic, copy) void(^sureBlock)(void);

@property (nonatomic, strong) NSArray *dataArr;

@end

NS_ASSUME_NONNULL_END
