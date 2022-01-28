//
//  CDMailRegisterView.m
//  security
//
//  Created by chendan on 2021/5/25.
//

#import "CDMailRegisterView.h"
#import "CDHelper.h"
#import "UIView+ProgressView.h"
#import "HttpRequest.h"


@interface CDMailRegisterView ()
@property (weak, nonatomic) IBOutlet UITextField *telOrMailTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *surePasswordTF;
@property (weak, nonatomic) IBOutlet UILabel *sendCodeLab;



@end

@implementation CDMailRegisterView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"CDMailRegisterView" owner:nil options:nil]lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.sendCodeLab.userInteractionEnabled = YES;
    [self.sendCodeLab addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sendCodeLabClick)]];
    
}

- (void)setType:(NSInteger)type{
    _type = type;
    
    if (!type) {//0为手机号  1为邮箱
        self.telOrMailTF.placeholder = KEnterPhone;
    }
}

-(void)sendCodeLabClick{
    if ([self isValidateTelOrEmail]) {
        [self.codeTF becomeFirstResponder];
        [self sendCode];
    }
}

//发送验证码
-(void)sendCode{
    [[CDHelper viewControllerWithView:self].view pv_showTextDialog:KSendCode];
    if (self.type) {
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"mail"] = self.telOrMailTF.text;
        [HttpRequest HR_EmailSendWithParams:parames success:^(id result) {
            [[CDHelper viewControllerWithView:self].view  pv_hideMBHub];
            if ([result[@"code"] intValue] == 200) {
                [CDHelper countTime:self.sendCodeLab];
            }else{
                [CDHelper dealWithPingTaiErrorWithVC:[CDHelper viewControllerWithView:self] result:result];
            }
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:KNetWorkError];
        }];
    }else{
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"phone"] = self.telOrMailTF.text;
        [HttpRequest HR_SendSmSWithContent:self.telOrMailTF.text Params:parames success:^(id result) {
            [[CDHelper viewControllerWithView:self].view  pv_hideMBHub];
            if ([result[@"code"] intValue] == 200) {
                [CDHelper countTime:self.sendCodeLab];
            }else{
                [CDHelper dealWithPingTaiErrorWithVC:[CDHelper viewControllerWithView:self] result:result];
            }
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:KNetWorkError];
        }];
    }
}

- (void)goToRegister{
    
    if (![self isValidateTelOrEmail]) {
        return;
    }
    
    if (self.codeTF.text.length == 0) {
        [[CDHelper viewControllerWithView:self].view pv_warming:KCodeError];
        return;
    }
    
    if (![CDHelper isValidatePassword:self.passwordTF.text]) {//密码不符合
        [[CDHelper viewControllerWithView:self].view pv_warming:KPasswordError];
        return;
    }else{//符合
        if (![self.passwordTF.text isEqual:self.surePasswordTF.text]) {//不相同
            [[CDHelper viewControllerWithView:self].view pv_warming:KSurePasswordError];
            return;
        }
    }
    
    NSString *agree = [[NSUserDefaults standardUserDefaults] objectForKey:KAgree];
    if ([agree isEqual:@"0"]) {
        [[CDHelper viewControllerWithView:self].view pv_warming:KAgreeError];
        return;
    }
    
    [self toRegister];
    
}

//判断手机号或者邮箱是否有用
-(BOOL)isValidateTelOrEmail{
    if (self.type == 0) {//手机号
        if (self.telOrMailTF.text.length == 0) {
            [[CDHelper viewControllerWithView:self].view pv_warming:KTelEmptyError];
            return NO;
        }
        if (![CDHelper isValidateTel:self.telOrMailTF.text]) {
            [[CDHelper viewControllerWithView:self].view pv_warming:KTelError];
            return NO;
        }
    }else{//邮箱
        if (self.telOrMailTF.text.length == 0) {
            [[CDHelper viewControllerWithView:self].view pv_warming:KEmailEmptyError];
            return NO;
        }
        if (![CDHelper isValidateEmail:self.telOrMailTF.text]) {
            [[CDHelper viewControllerWithView:self].view pv_warming:KEmailError];
            return NO;
        }
    }
    return YES;
}

-(void)toRegister{
    [[CDHelper viewControllerWithView:self].view pv_showTextDialog:KRegistering];
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"code"] = self.codeTF.text;
    parames[@"password"] = self.passwordTF.text;
    
    if (self.type == 0) {
        parames[@"mobile"] = self.telOrMailTF.text;
    }else{
        parames[@"email"] = self.telOrMailTF.text;
    }
    
    [HttpRequest HR_RegisterAppWithParams:parames success:^(id result) {
        if ([result[@"code"] intValue] == 200) {
            [[CDHelper viewControllerWithView:self].view pv_successLoading:KRegisterSuccess];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[CDHelper viewControllerWithView:self].navigationController popViewControllerAnimated:YES];
            });
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:[CDHelper viewControllerWithView:self] result:result];
        }
        
    } failure:^(NSError *error) {
        [[CDHelper viewControllerWithView:self].view pv_failureLoading:KNetWorkError];
    }];
}




@end
