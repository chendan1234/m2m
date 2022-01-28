//
//  QRView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/25.
//

#import "QRView.h"
#import "UIImage+TYQRCode.h"

@interface QRView ()
@property (weak, nonatomic) IBOutlet UIImageView *qrImgV;

@end

@implementation QRView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"QRView" owner:nil options:nil]lastObject];
}

-(void)setupQRWithWifiName:(NSString *)ssid password:(NSString *)password token:(NSString *)token{
    
    NSDictionary *dictionary = @{
        @"s": ssid,
        @"p": password,
        @"t": token
    };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString *wifiJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    UIImage *image = [UIImage ty_qrCodeWithString:wifiJsonStr width:260];
    self.qrImgV.image = image;
}

//听到提示音
- (IBAction)tip:(id)sender {
    if (self.tipBlock) {
        self.tipBlock();
    }
}

@end
