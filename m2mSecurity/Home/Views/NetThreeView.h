//
//  NetThreeView.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetThreeView : UIView

+(instancetype)reload;
@property (nonatomic, copy)void(^tipBlcok)(void);

-(void)setupQRWithWifiName:(NSString *)ssid password:(NSString *)password token:(NSString *)token;



@end

NS_ASSUME_NONNULL_END
