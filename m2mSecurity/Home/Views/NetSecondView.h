//
//  NetSecondView.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetSecondView : UIView

+(instancetype)reload;

@property (nonatomic, copy)void(^nextBlcok)(void);
@property (weak, nonatomic) IBOutlet UITextField *wifiTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

NS_ASSUME_NONNULL_END
