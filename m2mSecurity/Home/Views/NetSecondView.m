//
//  NetSecondView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/30.
//

#import "NetSecondView.h"

@implementation NetSecondView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"NetSecondView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.wifiTF.text = [CDHelper getWifiName];
    NSString *lastWifiName = [[NSUserDefaults standardUserDefaults]objectForKey:KWiFiName];
    
    if ([self.wifiTF.text isEqualToString:lastWifiName]) {
        self.passwordTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:KWiFiPassword];
    }
}

- (IBAction)next:(id)sender {
    
    if (self.wifiTF.text.length == 0) {
        [[CDHelper viewControllerWithView:self].view pv_warming:@"请输入Wi-Fi名称"];
        return;
    }
    
    if (self.passwordTF.text.length == 0) {
        [[CDHelper viewControllerWithView:self].view pv_warming:@"请输入Wi-Fi密码"];
        return;
    }
    
    if (self.nextBlcok) {
        self.nextBlcok();
    }
}

@end
