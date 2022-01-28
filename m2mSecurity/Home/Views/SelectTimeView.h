//
//  SelectTimeView.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectTimeView : UIView

+(instancetype)reload;

@property (nonatomic, copy) void(^selectTimeBlock)(NSInteger day);
@property (nonatomic, copy) void(^cancelBlock)(void);

@end

NS_ASSUME_NONNULL_END
