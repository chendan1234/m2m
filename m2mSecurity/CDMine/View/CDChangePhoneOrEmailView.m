//
//  CDChangePhoneOrEmailView.m
//  security
//
//  Created by chendan on 2021/6/1.
//

#import "CDChangePhoneOrEmailView.h"
#import "CDCommonDefine.h"
#import "CDHelper.h"
#import "UIView+ProgressView.h"
#import "HttpRequest.h"

@interface CDChangePhoneOrEmailView ()
@property (weak, nonatomic) IBOutlet UITextField *phoneOrEmialTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UILabel *sendCodeLab;
@property (weak, nonatomic) IBOutlet UIButton *nextOrOverBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;

@end

@implementation CDChangePhoneOrEmailView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"CDChangePhoneOrEmailView" owner:nil options:nil]lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.sendCodeLab.userInteractionEnabled = YES;
    [self.sendCodeLab addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(codeLabClick)]];
}

//第一步或第二步
-(void)setType:(NSInteger)type{
    _type = type;
    
    if (type) {
        [self.nextOrOverBtn setTitle:KOver forState:UIControlStateNormal];
        self.phoneOrEmialTF.userInteractionEnabled = YES;
    }else{
        self.phoneOrEmialTF.userInteractionEnabled = NO;
        
        
        
        
        
//        NSString *account = [[NSUserDefaults standardUserDefaults]objectForKey:KLoginAccount];
        
        NSString *phone = [CDAppUser getUser].mobile;
        NSString *email = [CDAppUser getUser].email;
        
        if (self.from == 0 || self.from == 3) { //手机号
            self.phoneOrEmialTF.text = phone;
        }
        
        if (self.from == 1 || self.from == 2) {
            self.phoneOrEmialTF.text = email;
        }
        
    }
}

//手机号或邮箱
-(void)setFrom:(NSInteger)from{
    _from = from;
    if (from == 1 || from == 3) {
        self.iconImgV.image = [UIImage imageNamed:@"email"];
        self.phoneOrEmialTF.placeholder = @"请输入邮箱地址";
        self.codeTF.placeholder = @"请输入邮箱验证码";
    }
}

//验证码
-(void)codeLabClick{
    if ([self isValidateTelOrEmail]) {//手机号合法
        [self.codeTF becomeFirstResponder];
        [self sendCode];
    }
}

//发送验证码
-(void)sendCode{
    [[CDHelper viewControllerWithView:self].view pv_showTextDialog:KSendCode];
    if (self.from == 1 || (self.from == 3 && self.type == 1) || (self.from == 2 && self.type == 0)) {//邮箱
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"mail"] = self.phoneOrEmialTF.text;
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
    }else if(self.from == 0 || (self.from == 3 && self.type == 0) || (self.from == 2 && self.type == 1)){//手机号
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"phone"] = self.phoneOrEmialTF.text;
        [HttpRequest HR_SendSmSWithContent:self.phoneOrEmialTF.text Params:parames success:^(id result) {
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

//点击下一步或完成
- (IBAction)nextOrOverBtnClick:(UIButton *)sender {
    [self checkCode];
}

#pragma mark - 检查验证码的合法性
-(void)checkCode{
    if (![self isValidateTelOrEmail]) {//校验手机号或邮箱是否正确
        return;
    }
    
    if (self.codeTF.text.length == 0) {//校验手机号是否正确
        [[CDHelper viewControllerWithView:self].view pv_warming:KCodeError];
        return;
    }
    
    
    //校验验证码
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"code"] = self.codeTF.text;
    parames[@"text"] = self.phoneOrEmialTF.text;
    
    [[CDHelper viewControllerWithView:self].view pv_showTextDialog:KChecking];
    [HttpRequest HR_VerificationSmsOrEmailWithParams:parames success:^(id result) {
        [[CDHelper viewControllerWithView:self].view pv_hideMBHub];
        if ([result[@"code"] intValue] == 200) {
            [self nextOrOver];
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:[CDHelper viewControllerWithView:self] result:result];
        }
    } failure:^(NSError *error) {
        [[CDHelper viewControllerWithView:self].view pv_failureLoading:KNetWorkError];
    }];
    
}

//下一步或完成的操作
-(void)nextOrOver{
    if (self.type) {//完成
        [self over];
    }else{//下一步
        if (self.nextBlock) {
            self.nextBlock();
        }
    }
}

//完成需要调用接口
-(void)over{
    if (self.from == 1 || self.from == 3) {//邮箱
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"id"] = [[NSUserDefaults standardUserDefaults] objectForKey:KUserId];
        parames[@"newMail"] = self.phoneOrEmialTF.text;
        [[CDHelper viewControllerWithView:self].view pv_showTextDialog:@"正在修改邮箱地址..."];
        [HttpRequest HR_ModifyMailboxWithParams:parames success:^(id result) {
            if ([result[@"code"] intValue] == 200) {
                [[CDHelper viewControllerWithView:self].view pv_hideMBHub];
                [CDAppUser getUser].email = self.phoneOrEmialTF.text;
                if (self.overBlock) {
                    self.overBlock();
                }
            }else{
                [CDHelper dealWithPingTaiErrorWithVC:[CDHelper viewControllerWithView:self] result:result];
            }
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:KNetWorkError];
        }];
    }else{//手机号
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"id"] = [[NSUserDefaults standardUserDefaults] objectForKey:KUserId];
        parames[@"newMobile"] = self.phoneOrEmialTF.text;
        NSString *url = [NSString stringWithFormat:@"%@/%@",parames[@"id"],parames[@"newMobile"]];
        
        [[CDHelper viewControllerWithView:self].view pv_showTextDialog:@"正在修改手机号码..."];
        [HttpRequest HR_ModifyMobilePhoneNumberWithContent:url Params:parames success:^(id result) {
            if ([result[@"code"] intValue] == 200) {
                [[CDHelper viewControllerWithView:self].view pv_hideMBHub];
                [CDAppUser getUser].mobile = self.phoneOrEmialTF.text;
                if (self.overBlock) {
                    self.overBlock();
                }
            }else{
                [CDHelper dealWithPingTaiErrorWithVC:[CDHelper viewControllerWithView:self] result:result];
            }
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:KNetWorkError];
        }];
        
    }
}


//判断手机号或者邮箱是否有用
-(BOOL)isValidateTelOrEmail{
    if (self.from == 0 || (self.from == 3 && self.type == 0) || (self.from == 2 && self.type == 1)) {//验证手机号
        if (self.phoneOrEmialTF.text.length == 0) {
            [[CDHelper viewControllerWithView:self].view pv_warming:KTelEmptyError];
            return NO;
        }
        if (![CDHelper isValidateTel:self.phoneOrEmialTF.text]) {
            [[CDHelper viewControllerWithView:self].view pv_warming:KTelError];
            return NO;
        }
    }else if(self.from == 1 || (self.from == 3 && self.type == 1) || (self.from == 2 && self.type == 0)){//验证邮箱
        if (self.phoneOrEmialTF.text.length == 0) {
            [[CDHelper viewControllerWithView:self].view pv_warming:KEmailEmptyError];
            return NO;
        }
        if (![CDHelper isValidateEmail:self.phoneOrEmialTF.text]) {
            [[CDHelper viewControllerWithView:self].view pv_warming:KEmailError];
            return NO;
        }
    }
    return YES;
}


@end
