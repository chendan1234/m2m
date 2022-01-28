//
//  QRView.h
//  m2mSecurity
//
//  Created by chendan on 2021/8/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRView : UIView

+(instancetype)reload;

-(void)setupQRWithWifiName:(NSString *)wifiName password:(NSString *)pwd token:(NSString *)token;

@property (nonatomic, copy)void (^tipBlock)(void);

@end

NS_ASSUME_NONNULL_END
