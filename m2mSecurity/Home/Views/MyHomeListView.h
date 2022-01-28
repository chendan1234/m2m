//
//  MyHomeListView.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyHomeListView : UIView

+(instancetype)reload;

@property (nonatomic, copy) void(^myBlock)(NSInteger type,TuyaSmartHomeModel *model);//0点击cell 1点击家庭管理

@property (nonatomic, strong)TuyaSmartHomeModel *model;

@end

NS_ASSUME_NONNULL_END
