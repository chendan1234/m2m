//
//  NetFiveView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/30.
//

#import "NetFiveView.h"

@implementation NetFiveView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"NetFiveView" owner:nil options:nil]lastObject];
}

- (IBAction)reset:(id)sender {
    if (self.resetBlock) {
        self.resetBlock();
    }
}

@end
