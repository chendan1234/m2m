//
//  CDChangePhoneOrEmailViewController.m
//  security
//
//  Created by chendan on 2021/6/1.
//

#import "CDChangePhoneOrEmailViewController.h"
#import "CDChangePhoneOrEmailView.h"
#import "UIView+DSExtension.h"
#import "UIView+ProgressView.h"
#import "CDHelper.h"


@interface CDChangePhoneOrEmailViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *oldLab;
@property (weak, nonatomic) IBOutlet UILabel *xinLab;





@end

@implementation CDChangePhoneOrEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"修改手机号码";
    self.view.clipsToBounds = YES;
    
    [self setContentView];
    [self setLab];
    
    
    NSLog(@"type-----%ld",self.type);
}

-(void)setLab{
    
    switch (self.type) {
        case 1:
        {
            self.oldLab.text = @"验证旧邮箱";
            self.xinLab.text = @"设置新邮箱";
            self.title = @"修改邮箱地址";
        }
            break;
        case 2:
        {
            self.oldLab.text = @"验证邮箱地址";
            self.xinLab.text = @"设置新手机";
            self.title = @"修改手机号码";
        }
            break;
        case 3:
        {
            self.oldLab.text = @"验证手机号码";
            self.xinLab.text = @"设置新邮箱";
            self.title = @"修改邮箱地址";
        }
            break;
        default:
            break;
    }
    
    
}

#pragma mark 界面搭建
//设置内容
-(void)setContentView{
    for (NSInteger i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*DEVICE_WIDRH, 0, DEVICE_WIDRH, 208)];
        CDChangePhoneOrEmailView *contentV = [CDChangePhoneOrEmailView reload];
        contentV.frame = view.bounds;
        contentV.from = self.type; //判断是手机号还是邮箱
        contentV.type = i;//判断是第一步,还是第二步
        
        [view addSubview:contentV];
        [self.contentView addSubview:view];
        
        [contentV setNextBlock:^{//下一步
            [self next];
        }];

        [contentV setOverBlock:^{//完成
            [self over];
        }];
    }
}

//下一步
- (void)next{
    self.oldLab.textColor = [CDHelper getColor:@"777777"];
    self.xinLab.textColor = KBlueColor;
    [UIView animateWithDuration:0.35 animations:^{
        for (NSInteger i = 0; i < self.contentView.subviews.count; i++) {
            UIView *view = self.contentView.subviews[i];
            view.x = (i-1)*DEVICE_WIDRH;
        }
    }];
    [self.view endEditing:YES];
}

//完成
-(void)over{
    
    if (self.type == 0 || self.type == 1) {
        NSString *msg = @"手机号修改成功, 请重新登录!";
        if (self.type) {
            msg = @"邮箱地址修改成功, 请重新登录!";
        }
        [self.view pv_successLoading:msg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CDHelper loginOut];
        });
    }else{
        NSString *msg = @"手机号设置成功!";
        if (self.type == 3) {//手机号设置邮箱
            msg = @"邮箱地址设置成功!";
        }
        [self.view pv_successLoading:msg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
}

//收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



@end
