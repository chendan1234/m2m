//
//  NetThreeView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/30.
//

#import "NetThreeView.h"
#import "UIImage+TYQRCode.h"

@interface NetThreeView ()
@property (weak, nonatomic) IBOutlet UIImageView *qrImgV;

@end

@implementation NetThreeView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"NetThreeView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)setupQRWithWifiName:(NSString *)ssid password:(NSString *)password token:(NSString *)token{
    
    NSDictionary *dictionary = @{
        @"s": ssid,
        @"p": password,
        @"t": token
    };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString *wifiJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        UIImage *image = [UIImage ty_qrCodeWithString:wifiJsonStr width:300];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.qrImgV.image = image;
        });
    });
   
}



- (IBAction)tip:(id)sender {
    if (self.tipBlcok) {
        self.tipBlcok();
    }
}

@end
