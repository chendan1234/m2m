//
//  CDChangePwdViewController.m
//  security
//
//  Created by chendan on 2021/6/1.
//

#import "CDChangePwdViewController.h"
#import "UIView+ProgressView.h"
#import "CDHelper.h"
#import "CDLoginViewController.h"
#import "HttpRequest.h"



@interface CDChangePwdViewController ()


@property (weak, nonatomic) IBOutlet UITextField *oldPwdTF;//旧密码
@property (weak, nonatomic) IBOutlet UITextField *xinPwdTF;//新密码
@property (weak, nonatomic) IBOutlet UITextField *xinSurePwdTF;//确认新密码


@end

@implementation CDChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = KChangePwdTitle;
    
}
- (IBAction)change:(id)sender {
    
    if (self.oldPwdTF.text.length == 0) {
        [self.view pv_warming:KOldPasswordEmptyError];
        return;
    }
    
    if (self.xinPwdTF.text.length == 0 || self.xinSurePwdTF.text.length == 0) {
        [self.view pv_warming:KNewPasswordEmptyError];
        return;
    }
    
    if (![CDHelper isValidatePassword:self.oldPwdTF.text]) {
        [self.view pv_warming:KPasswordError];
        return;
    }
    
    if (![CDHelper isValidatePassword:self.xinPwdTF.text]) {
        [self.view pv_warming:KPasswordError];
        return;
    }
    
    if (![self.xinPwdTF.text isEqual:self.xinSurePwdTF.text]) {
        [self.view pv_warming:KSurePasswordError];
        return;
    }
    
    [self.view pv_showTextDialog:KChangePwding];
    
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"newPassword"] = self.xinPwdTF.text;
    parames[@"oldPassword"] = self.oldPwdTF.text;
    parames[@"id"] = [[NSUserDefaults standardUserDefaults] objectForKey:KUserId];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@",parames[@"id"],parames[@"newPassword"],parames[@"oldPassword"]];
    
    
    [HttpRequest HR_UpdatePasswordWithContent:url Params:parames success:^(id result) {
        if ([result[@"code"] intValue] == 200) {
            [self.view pv_successLoading:KChangePwdSuccess];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [CDHelper loginOut];
            });
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNetWorkError];
    }];
    
}

#pragma mark - funsdk 回调处理
-(void)changePasswordDelegateResult:(long)result
{
    if (result >= 0) {//修改成功
        [self.view pv_successLoading:KChangePwdSuccess];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CDHelper loginOut];
        });
    }else{//修改失败
        [CDHelper dealWithXiongMaiErrorWithCode:result vc:self];
    }
}

//收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
