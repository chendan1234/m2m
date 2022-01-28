//
//  NetWiredTipView.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/3.
//

#import "NetWiredTipView.h"

@interface NetWiredTipView ()

@property (nonatomic, assign)BOOL isSelect;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation NetWiredTipView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"NetWiredTipView" owner:nil options:nil]lastObject];
}

- (IBAction)tip:(UIButton *)sender {
    if (self.isSelect) {
        self.isSelect = NO;
        [sender setImage:[UIImage imageNamed:@"yq"] forState:UIControlStateNormal];
        self.nextBtn.userInteractionEnabled = NO;
        self.nextBtn.backgroundColor = [CDHelper getColor:@"EBEBEB"];
    }else{
        self.isSelect = YES;
        [sender setImage:[UIImage imageNamed:@"xuan"] forState:UIControlStateNormal];
        self.nextBtn.userInteractionEnabled = YES;
        self.nextBtn.backgroundColor = [CDHelper getColor:@"0075E3"];
    }
}

- (IBAction)next:(id)sender {
    if (self.nextBlcok) {
        self.nextBlcok();
    }
}

@end
