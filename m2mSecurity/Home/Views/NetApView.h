//
//  NetApView.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetApView : UIView

+(instancetype)reload;

@property (nonatomic, copy) void(^linkHotBlcok)(void);
@property (nonatomic, copy) void(^nextBlock)(void);

@end

NS_ASSUME_NONNULL_END
