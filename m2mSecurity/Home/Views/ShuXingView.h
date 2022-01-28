//
//  ShuXingView.h
//  m2mSecurity
//
//  Created by chendan on 2021/9/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShuXingView : UIView

+(instancetype)reload;

@property (nonatomic, strong)NSArray *dataArr;

@property (nonatomic, strong)NSString *title;

@property (nonatomic, copy) void(^cancelBlock)(void);

@property (nonatomic, copy) void(^selectBlock)(NSString *value);



@end

NS_ASSUME_NONNULL_END
