//
//  DeviceDetailHeaderView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/27.
//

#import "DeviceDetailHeaderView.h"

@interface DeviceDetailHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *dianLab;
@property (weak, nonatomic) IBOutlet UILabel *otherLab;
@property (weak, nonatomic) IBOutlet UILabel *otherNumLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *otherH;

@property (nonatomic, strong)NSDictionary *dic;

@end


#define KDeviceRed [UIColor redColor]
#define KDeviceBlue KBlueColor

@implementation DeviceDetailHeaderView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"DeviceDetailHeaderView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
//    [self setupAnimation];
}

-(void)setModel:(TuyaSmartDeviceModel *)model{
    _model = model;
    
    self.dic = model.dps;
    
//    NSLog(@"---dps = %@",model.dps);
    
    switch ([CDHelper getDeviceCategoryWithModel:model]) {
        case DeviceCategroyCDYanGan://烟感
            [self yanGan];
            break;
        case DeviceCategroyCDMenChi://门磁
            [self menChi];
            break;
        case DeviceCategroyCDYaoKong://遥控
            [self yaoKong];
            break;
        case DeviceCategroyCDShuiJin://水浸
            [self shuiJin];
            break;
        case DeviceCategroyCDRenTi://人体
            [self renTi];
            break;
        case DeviceCategroyCDShengGuang://声光
            [self shengGuang];
            break;
        case DeviceCategroyCDSOS://sos
            [self sos];
            break;
        default:
            break;
    }
}

//烟感
-(void)yanGan{
    
    
    self.dianLab.text = self.dic[@"14"]; //电量
    self.otherLab.text = @"防拆报警";
    
    if ([self.dic[@"4"] intValue] == 0) {//防拆报警
        self.otherNumLab.text = @"正常";
    }else{
        self.otherNumLab.text = @"报警";
    }
    
    if ([self.dic[@"1"] isEqual:@"alarm"]) {//烟雾报警
        [self setupAnimationWithImage:@"jcyw" color:KDeviceRed];
        return;
    }
    
    if ([self.dic[@"14"] isEqual:@"low"]) {//低电量
        [self setupAnimationWithImage:@"lowDian" color:KDeviceRed];
        return;
    }
    
    [self setupAnimationWithImage:@"nomal" color:KDeviceBlue];
}

//门磁
-(void)menChi{
    self.otherH.constant = 0.0;
    self.dianLab.text = [NSString stringWithFormat:@"%@%%",self.dic[@"2"]];
    
    if ([self.dic[@"1"] intValue] == 1) {
        [self setupAnimationWithImage:@"mck" color:KDeviceRed];
        return;
    }
    
    if ([self.dic[@"2"] intValue] <= 10) {
        [self setupAnimationWithImage:@"lowDian" color:KDeviceRed];
        return;
    }
    [self setupAnimationWithImage:@"nomal" color:KDeviceBlue];
}

//遥控
-(void)yaoKong{
    
    NSLog(@"遥控----%@",self.dic);
    
    self.otherH.constant = 0.0;
    self.dianLab.text = [NSString stringWithFormat:@"%@%%",self.dic[@"3"]]; //电量
    
    if ([self.dic[@"29"] isEqual:@"sos"]) {//报警
        [self setupAnimationWithImage:@"baojing" color:KDeviceRed];
        return;
    }
    
    if ([self.dic[@"28"] isEqual:@"home"]) {//报警
        [self setupAnimationWithImage:@"athome" color:KDeviceBlue];
        return;
    }
    
    if ([self.dic[@"27"] isEqual:@"arm"]) {//在外布防
        [self setupAnimationWithImage:@"outside" color:KColorA(25, 175, 125, 1)];
        return;
    }
    
    if ([self.dic[@"26"] isEqual:@"disarmed"]) {//撤防
        [self setupAnimationWithImage:@"che" color:KColorA(219, 153, 55, 1)];
        return;
    }
    
    if ([self.dic[@"3"] intValue] <= 10 ) {//低电量
        [self setupAnimationWithImage:@"lowDian" color:KDeviceRed];
        return;
    }
    
    [self setupAnimationWithImage:@"nomal" color:KDeviceBlue];
}

//水浸
-(void)shuiJin{
    self.otherH.constant = 0.0;
    self.dianLab.text = [NSString stringWithFormat:@"%@%%",self.dic[@"4"]];
    
    if ([self.dic[@"1"] isEqual:@"alarm"]) {//水侵报警
        [self setupAnimationWithImage:@"qinru" color:KDeviceRed];
        return;
    }
    
    if ([self.dic[@"4"] intValue] <= 10) {//电量
        [self setupAnimationWithImage:@"lowDian" color:KDeviceRed];
        return;
    }
    [self setupAnimationWithImage:@"nomal" color:KDeviceBlue];
}

//人体
-(void)renTi{
    self.otherH.constant = 0.0;
    self.dianLab.text = [NSString stringWithFormat:@"%@%%",self.dic[@"4"]];
    
    if ([self.dic[@"1"] isEqual:@"pir"]) {//水侵报警
        [self setupAnimationWithImage:@"youren" color:KDeviceRed];
        return;
    }
    
    if ([self.dic[@"4"] intValue] <= 10) {//电量
        [self setupAnimationWithImage:@"lowDian" color:KDeviceRed];
        return;
    }
    [self setupAnimationWithImage:@"nomal" color:KDeviceBlue];
}

//声光
-(void)shengGuang{
    self.dianLab.text = [NSString stringWithFormat:@"%@%%",self.dic[@"14"]]; //电量
    self.otherLab.text = @"报警音量";
    self.otherNumLab.text = self.dic[@"5"];
    
    
    if ([self.dic[@"13"] intValue] == 1) {//报警
        [self setupAnimationWithImage:@"mingxiang" color:KDeviceRed];
        return;
    }
    
    if ([self.dic[@"14"] intValue] <= 20 ) {//低电量
        [self setupAnimationWithImage:@"lowDian" color:KDeviceRed];
        return;
    }
    
    [self setupAnimationWithImage:@"nomal" color:KDeviceBlue];
}

//sos
-(void)sos{
    
    NSLog(@"sos----%@",self.dic);
    
    self.otherH.constant = 0.0;
    self.dianLab.text = [NSString stringWithFormat:@"%@%%",self.dic[@"3"]];
    
    if ([self.dic[@"29"] isEqual:@"sos"]) {//水侵报警
        [self setupAnimationWithImage:@"baojing" color:KDeviceRed];
        return;
    }
    
    if ([self.dic[@"3"] intValue] <= 10) {//电量
        [self setupAnimationWithImage:@"lowDian" color:KDeviceRed];
        return;
    }
    [self setupAnimationWithImage:@"nomal" color:KDeviceBlue];
}



-(void)setupAnimationWithImage:(NSString *)imageName color:(UIColor *)color{
    
    for (UIView *view in self.topView.subviews) {
        [view removeFromSuperview];
    }
        UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 130, 130)];
        
        animationView.backgroundColor = color;
        animationView.layer.masksToBounds = YES;
        animationView.layer.cornerRadius = 65;
        [self.topView addSubview:animationView];

        UIImageView *voiceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 130, 130)];
        voiceImageView.image = [UIImage imageNamed:imageName];
        [self.topView addSubview:voiceImageView];

        /*慢慢消失的动画*/
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        //动画完成后保持原状
        animation1.fillMode = kCAFillModeForwards;
        animation1.removedOnCompletion = NO;
        //值
        animation1.fromValue = [NSNumber numberWithFloat:0.6];
        animation1.toValue = [NSNumber numberWithFloat:0.1];
        animation1.duration = 1.2;//动画时间


        /*变大动画*/
        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation2.fillMode = kCAFillModeForwards;
        animation2.removedOnCompletion = NO;
        //值
        animation2.fromValue = [NSNumber numberWithFloat:1.0];
        animation2.toValue = [NSNumber numberWithFloat:1.8];
        animation2.duration = 1.2;

        /*动画组，把上面两个动画组合起来*/
        CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
        groupAnnimation.duration = 1.2;
        groupAnnimation.repeatCount = MAXFLOAT;//无限循环
        groupAnnimation.animations = @[animation1, animation2];
        groupAnnimation.fillMode = kCAFillModeForwards;
        groupAnnimation.removedOnCompletion = NO;
        
        [animationView.layer removeAllAnimations];
        [animationView.layer addAnimation:groupAnnimation forKey:@"group"];
}

@end
