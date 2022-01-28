//
//  CDFindPasswordViewController.m
//  security
//
//  Created by chendan on 2021/5/27.
//

#import "CDFindPasswordViewController.h"
#import "CDVerifyView.h"
#import "UIView+DSExtension.h"
#import "UIView+ProgressView.h"
#import "CDHelper.h"

@interface CDFindPasswordViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong)NSMutableArray *contentViewArr;

@property (weak, nonatomic) IBOutlet UILabel *verifyTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *pwdTitleLab;

@end

@implementation CDFindPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = KFindPwdTitle;
    self.view.clipsToBounds = YES;
    
    [self setContentView];
}

#pragma mark 界面搭建
//设置内容
-(void)setContentView{
    for (NSInteger i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*DEVICE_WIDRH, 0, DEVICE_WIDRH, 208)];
        CDVerifyView *contentV = [CDVerifyView reload];
        contentV.frame = view.bounds;
        contentV.type = i;
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
    self.verifyTitleLab.textColor = [CDHelper getColor:@"777777"];
    self.pwdTitleLab.textColor = KBlueColor;
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
    [self.navigationController popViewControllerAnimated:YES];
}

//收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
}



@end
