//
//  DeviceDetailTopView.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceDetailTopView : UIView

+(instancetype)reload;
@property (weak, nonatomic) IBOutlet UIButton *selectTimeBtn;

@property (nonatomic, assign)NSInteger day;

@end

NS_ASSUME_NONNULL_END
