//
//  SelectTimeView.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/1.
//

#import "SelectTimeView.h"

@interface SelectTimeView ()

@end

@implementation SelectTimeView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SelectTimeView" owner:nil options:nil]lastObject];
}

//1天
- (IBAction)oneDay:(id)sender {
    if (self.selectTimeBlock) {
        self.selectTimeBlock(1);
    }
}
//2天
- (IBAction)towDay:(id)sender {
    if (self.selectTimeBlock) {
        self.selectTimeBlock(2);
    }
}
//7天
- (IBAction)seDay:(id)sender {
    if (self.selectTimeBlock) {
        self.selectTimeBlock(7);
    }
}

//取消
- (IBAction)cancel:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}


@end
