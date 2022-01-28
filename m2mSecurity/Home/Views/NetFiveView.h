//
//  NetFiveView.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetFiveView : UIView

+(instancetype)reload;

@property (nonatomic, copy) void(^resetBlock)(void);

@end

NS_ASSUME_NONNULL_END
