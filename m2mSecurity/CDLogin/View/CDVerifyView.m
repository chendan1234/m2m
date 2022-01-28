//
//  CDVerifyView.m
//  security
//
//  Created by chendan on 2021/5/27.
//

#import "CDVerifyView.h"
#import "CDHelper.h"
#import "UIView+ProgressView.h"
#import "HttpRequest.h"

@interface CDVerifyView ()

@property (weak, nonatomic) IBOutlet UIImageView *iconOneImgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconTowImgW;
@property (weak, nonatomic) IBOutlet UITextField *OneTF;
@property (weak, nonatomic) IBOutlet UITextField *TowTF;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *maginW;


@end

@implementation CDVerifyView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"CDVerifyView" owner:nil options:nil]lastObject];
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.codeLab.userInteractionEnabled = YES;
    [self.codeLab addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(codeLabClick)]];
    
}

//倒计时
-(void)codeLabClick{
    if ([self isValidateTelOrEmail]) {
        [self.TowTF becomeFirstResponder];
        [self sendCode];
    }
}

//发送验证码
-(void)sendCode{
    [[CDHelper viewControllerWithView:self].view pv_showTextDialog:KSendCode];
    if ([self.OneTF.text containsString:@"@"]) {//邮箱
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"mail"] = self.OneTF.text;
        [HttpRequest HR_EmailSendWithParams:parames success:^(id result) {
            [[CDHelper viewControllerWithView:self].view  pv_hideMBHub];
            if ([result[@"code"] intValue] == 200) {
                [CDHelper countTime:self.codeLab];
            }else{
                [CDHelper dealWithPingTaiErrorWithVC:[CDHelper viewControllerWithView:self] result:result];
            }
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:KNetWorkError];
        }];
    }else{//手机号
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"phone"] = self.OneTF.text;
        [HttpRequest HR_SendSmSWithContent:self.OneTF.text Params:parames success:^(id result) {
            [[CDHelper viewControllerWithView:self].view  pv_hideMBHub];
            if ([result[@"code"] intValue] == 200) {
                [CDHelper countTime:self.codeLab];
            }else{
                [CDHelper dealWithPingTaiErrorWithVC:[CDHelper viewControllerWithView:self] result:result];
            }
        } failure:^(NSError *error) {
            [[CDHelper viewControllerWithView:self].view pv_failureLoading:KNetWorkError];
        }];
    }
}

-(void)setType:(NSInteger)type{
    _type = type;
    
    if (type) {
        self.codeLab.hidden = YES;
        [self.nextBtn setTitle:KOver forState:UIControlStateNormal];
    }else{
        self.iconOneImgV.image = [UIImage imageNamed:@"phone"];
        self.iconTowImgW.constant = 0.0;
        self.maginW.constant = 0.0;
        self.OneTF.placeholder = KEnterPhoneOrEmail;
        self.TowTF.placeholder = KEnterCode;
        
        self.OneTF.secureTextEntry = NO;
        self.TowTF.secureTextEntry = NO;
    }
}


//点击下一步或者完成
- (IBAction)nextOrOverBtnClick:(UIButton *)sender {
    
    if ([sender.titleLabel.text isEqual:KNext]) {//下一步
        [self checkCode];
    }else{//完成
        [self resetPassword];
    }
}

#pragma mark - 检查验证码的合法性
-(void)checkCode{
    if (![self isValidateTelOrEmail]) {//校验手机号或邮箱是否正确
        return;
    }
    
    if (self.TowTF.text.length == 0) {//校验手机号是否正确
        [[CDHelper viewControllerWithView:self].view pv_warming:KCodeError];
        return;
    }
    
    
    //校验验证码
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"code"] = self.TowTF.text;
    parames[@"text"] = self.OneTF.text;
    
    [[CDHelper viewControllerWithView:self].view pv_showTextDialog:KChecking];
    [HttpRequest HR_VerificationSmsOrEmailWithParams:parames success:^(id result) {
        
        [[CDHelper viewControllerWithView:self].view pv_hideMBHub];
        if ([result[@"code"] intValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:self.OneTF.text forKey:KMobile];
            if (self.nextBlock) {
                self.nextBlock();
            }
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:[CDHelper viewControllerWithView:self] result:result];
        }
    } failure:^(NSError *error) {
        [[CDHelper viewControllerWithView:self].view pv_failureLoading:KNetWorkError];
    }];
    
}

#pragma mark - 重置密码
-(void)resetPassword{
    
    if (self.OneTF.text.length == 0) {
        [[CDHelper viewControllerWithView:self].view pv_warming:KPasswordEmptyError];
        return;
    }
    
    if (![CDHelper isValidatePassword:self.OneTF.text]) {//密码不符合
        [[CDHelper viewControllerWithView:self].view pv_warming:KPasswordError];
        return;
    }else{//符合
        if (![self.OneTF.text isEqual:self.TowTF.text]) {//不相同
            [[CDHelper viewControllerWithView:self].view pv_warming:KSurePasswordError];
            return;
        }
    }
    
    //重置密码
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"account"] = [[NSUserDefaults standardUserDefaults] objectForKey:KMobile];
    parames[@"newPassword"] = self.OneTF.text;
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",parames[@"account"],parames[@"newPassword"]];
    
    [[CDHelper viewControllerWithView:self].view pv_showTextDialog:KChangePwding];
    [HttpRequest HR_RetrievePasswordWithContent:url Params:parames success:^(id result) {
        [[CDHelper viewControllerWithView:self].view pv_hideMBHub];
        if ([result[@"code"] intValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:self.OneTF.text forKey:KMobile];
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


//判断手机号或者邮箱是否有用
-(BOOL)isValidateTelOrEmail{
    if (self.OneTF.text.length == 0) {
        [[CDHelper viewControllerWithView:self].view pv_warming:KTelOrEmailEmptyError];
        return NO;
    }
    
    if ([CDHelper isValidateTel:self.OneTF.text] || [CDHelper isValidateEmail:self.OneTF.text]) {
        return YES;
    }else{
        [[CDHelper viewControllerWithView:self].view pv_warming:KTelOrEmailError];
        return NO;
    }
}







@end
