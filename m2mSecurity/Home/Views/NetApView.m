//
//  NetApView.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/3.
//

#import "NetApView.h"

@interface NetApView ()

@end

@implementation NetApView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"NetApView" owner:nil options:nil]lastObject];
}
- (IBAction)link:(id)sender {
    NSURL *url = [NSURL URLWithString:@"App-prefs:root=WIFI"];

        if ([[UIApplication sharedApplication] canOpenURL:url]) {

           [[UIApplication sharedApplication] openURL:url];

       }
}
- (IBAction)next:(id)sender {
    if (self.nextBlock) {
        self.nextBlock();
    }
}

@end
