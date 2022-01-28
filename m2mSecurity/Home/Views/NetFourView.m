//
//  NetFourView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/30.
//

#import "NetFourView.h"

@interface NetFourView ()
@property (weak, nonatomic) IBOutlet UIImageView *tipImgV;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation NetFourView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"NetFourView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self rotateView:self.tipImgV];
    
}

- (void)rotateView:(UIImageView *)view

{
    [view.layer removeAllAnimations];
    
      CABasicAnimation *rotationAnimation;
      rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
      rotationAnimation.removedOnCompletion = NO;
      rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
      rotationAnimation.duration = 1.5;
      rotationAnimation.repeatCount = HUGE_VALF;
     [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}

-(dispatch_source_t)countTime
{
    
    __block NSInteger timeout = 120;//倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.timeLab.text = @"00:00";
                if (self.nextBlock) {
                    self.nextBlock();
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.timeLab.text = [NSString stringWithFormat:@"%@",[self getMMSSFromSS:timeout]];
                timeout--;
            });
            
        }
    });
    dispatch_resume(_timer);
    
    return _timer;
}

//传入 秒  得到 xx:xx:xx
-(NSString *)getMMSSFromSS:(NSInteger)seconds{
    //format of minute
    NSString *minute = [NSString stringWithFormat:@"%02ld",(seconds/60)];
    //format of second
    NSString *second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",minute,second];

    return format_time;

}

@end
