//
//  MenLingView.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/24.
//

#import "MenLingView.h"

@interface MenLingView ()
@property (weak, nonatomic) IBOutlet UIButton *shengYinBtn;
@property (weak, nonatomic) IBOutlet UIButton *dianLiangBtn;

@end

@implementation MenLingView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MenLingView" owner:nil options:nil]lastObject];
}

-(void)setModel:(TuyaSmartDeviceModel *)model{
    _model = model;
    
    NSString *dian = [NSString stringWithFormat:@"电池电量 %@%%",model.dps[@"145"]];
    [self.dianLiangBtn setTitle:dian forState:UIControlStateNormal];
    
}

//声音
- (IBAction)shenYin:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setImage:[UIImage imageNamed:@"jingyin"] forState:UIControlStateNormal];
        sender.selected = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"yinliang"] forState:UIControlStateNormal];
        sender.selected = YES;
    }
    
    if (self.shengYin) {
        self.shengYin(sender.selected);
    }
}

//录制
- (IBAction)luzhi:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setImage:[UIImage imageNamed:@"luzhi"] forState:UIControlStateNormal];
        sender.selected = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"luzhi-dianji"] forState:UIControlStateNormal];
        sender.selected = YES;
    }
    
    if (self.luZhi) {
        self.luZhi(sender.selected);
    }
}

//说话
- (IBAction)shuoHua:(UIButton *)sender {
    if (sender.isSelected) {
        [sender setImage:[UIImage imageNamed:@"shuohua"] forState:UIControlStateNormal];
        sender.selected = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"shuohua-dianji"] forState:UIControlStateNormal];
        sender.selected = YES;
    }
    
    if (self.shuoHua) {
        self.shuoHua(sender.selected);
    }
}

//截图
- (IBAction)jietu:(id)sender {
    if (self.jiePing) {
        self.jiePing();
    }
}

//全屏
- (IBAction)quanPing:(UIButton *)sender {
    if (self.quanPing) {
        self.quanPing(sender.selected);
    }
}

- (IBAction)lisi:(id)sender {
    if (self.lisi) {
        self.lisi();
    }
}



@end
