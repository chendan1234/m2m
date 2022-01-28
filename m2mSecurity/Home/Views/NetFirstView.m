//
//  NetFirstView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/30.
//

#import "NetFirstView.h"

@interface NetFirstView ()
@property (weak, nonatomic) IBOutlet UIImageView *tipImgV;

@property (nonatomic, assign)BOOL isSelect;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@end

@implementation NetFirstView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"NetFirstView" owner:nil options:nil]lastObject];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    
}

-(void)setIsWangGuan:(BOOL)isWangGuan{
    _isWangGuan = isWangGuan;
    
    if (isWangGuan) {
        self.tipLab.text = @"接通电源, 请确认红灯快闪, 蓝灯常亮";
        NSArray *images=[NSArray arrayWithObjects:[UIImage imageNamed:@"wg_r"],[UIImage imageNamed:@"wg_h"], nil];
        [self imageAnimationWithImages:images];
    }else{
        NSArray *images=[NSArray arrayWithObjects:[UIImage imageNamed:@"san"],[UIImage imageNamed:@"noSan"], nil];
        [self imageAnimationWithImages:images];
    }
    
    
}

-(void)imageAnimationWithImages:(NSArray *)images{
    self.tipImgV.image = [UIImage imageNamed:@"noSan"];
    //imageView的动画图片是数组images
    self.tipImgV.animationImages = images;
    //切换动作的时间3秒，来控制图像显示的速度有多快，
    self.tipImgV.animationDuration = 0.5;
    //动画的重复次数，想让它无限循环就赋成0
    self.tipImgV.animationRepeatCount = 0;
    
    [self.tipImgV startAnimating];
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
    
    [self.tipImgV stopAnimating];
}

@end
