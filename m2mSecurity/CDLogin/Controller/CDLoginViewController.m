//
//  CDLoginViewController.m
//  security
//
//  Created by chendan on 2021/5/26.
//

#import "CDLoginViewController.h"
#import "CDRegisterViewController.h"
#import "CDFindPasswordViewController.h"

#import "CDModifyInfoViewController.h"
#import "CDChangePhoneOrEmailViewController.h"
#import "CDChangePwdViewController.h"
#import "TabBarViewController.h"


@interface CDLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *telOrEmailTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@property (nonatomic, strong)NSString *uid;
@property (nonatomic, strong)NSString *password;


@property (nonatomic, strong)id loginData;

@end

@implementation CDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = KLoginTitle;
    self.telOrEmailTF.autocorrectionType = UITextAutocorrectionTypeNo;//解决红点bug
    
}

//眼睛
- (IBAction)eyeBtnClick:(UIButton *)sender {
    if ([sender.imageView.image isEqual:[UIImage imageNamed:@"yincang"]]) {
        [sender setImage:[UIImage imageNamed:@"show"] forState:UIControlStateNormal];
        self.passwordTF.secureTextEntry = NO;
    }else{
        [sender setImage:[UIImage imageNamed:@"yincang"] forState:UIControlStateNormal];
        self.passwordTF.secureTextEntry = YES;
    }
}

//登录
- (IBAction)login:(id)sender {
    
    if (![CDHelper isValidatePassword:self.passwordTF.text]) {
        [self.view pv_warming:KPasswordError];
        return;
    }
    
    if ([CDHelper isValidateTel:self.telOrEmailTF.text] || [CDHelper isValidateEmail:self.telOrEmailTF.text]) {
        [self loginMe];
    }else{
        [self.view pv_warming:KTelOrEmailError];
    }
}

//注册
- (IBAction)registerBtnClick:(id)sender {
    CDRegisterViewController *registerVC = [[CDRegisterViewController alloc]init];
    [self.navigationController pushViewController:registerVC animated:YES];
}

//修改个人资料
- (IBAction)change:(id)sender {
    CDModifyInfoViewController *modifyVC = [[CDModifyInfoViewController alloc]init];
    [self.navigationController pushViewController:modifyVC animated:YES];
}

//找回密码
- (IBAction)findPasswordBtnClick:(id)sender {
    CDFindPasswordViewController *findPwdVC = [[CDFindPasswordViewController alloc]init];
    [self.navigationController pushViewController:findPwdVC animated:YES];
}

//修改手机号
- (IBAction)changePhone:(id)sender {
    CDChangePhoneOrEmailViewController *changeVC = [[CDChangePhoneOrEmailViewController alloc]init];
    [self.navigationController pushViewController:changeVC animated:YES];
}

//修改密码
- (IBAction)changePwd:(id)sender {
    CDChangePwdViewController *changePwdVC = [[CDChangePwdViewController alloc]init];
    [self.navigationController pushViewController:changePwdVC animated:YES];
}



//收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



//登录自己平台
-(void)loginMe{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"account"] = self.telOrEmailTF.text;
    parames[@"password"] = self.passwordTF.text;

    [self.view pv_showTextDialog:KLogining];
    [HttpRequest HR_LoginWithParams:parames success:^(id result) {
        if ([result[@"code"] intValue] == 200) {
            self.loginData = result;
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"Bearer %@",self.loginData[@"data"][@"tokenId"]] forKey:KToken];
            [self tuYaPassword];
            [self relationToPush];//关联设备去推送
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNetWorkError];
    }];
}

//关联设备推送
-(void)relationToPush{
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:KFcmToken];
    if (token.length) {
        NSMutableDictionary *parames = [NSMutableDictionary dictionary];
        parames[@"deviceId"] = token;
        parames[@"type"] = @"iOS";
        
        [HttpRequest sendPushDeviceId:parames success:^(id result) {
            NSLog(@"关联设备推送----%@",result);
        } failure:^(NSError *error) {
            NSLog(@"关联设备推送error----%@",error);
        }];
    }
    
}

//获取密码
-(void)tuYaPassword{
    [HttpRequest HR_TuYapasswordWithParams:@{} success:^(id result) {
        if ([result[@"code"] intValue] == 200) {
            self.password = result[@"data"];
            [self tuYaLogin];
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNetWorkError];
    }];
}

-(void)tuYaLogin{
    
    NSString *userId = [CDHelper getUidWith:self.loginData[@"data"][@"appUser"][@"userId"]];
    NSString *password = self.password;
    
    
    NSLog(@"userId-----%@",userId);
    
    [[TuyaSmartUser sharedInstance] loginOrRegisterWithCountryCode:@"1" uid:userId password:password createHome:YES success:^(id result) {
        self.uid = result[@"uid"];
        [self saveData];
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:@"登录失败, 请重新登录!"];
    }];
}



-(void)saveData{
    
    //保存数据
    CDAppUser *user = [CDAppUser mj_objectWithKeyValues:self.loginData[@"data"][@"appUser"]];
    user.tokenId = [NSString stringWithFormat:@"Bearer %@",self.loginData[@"data"][@"tokenId"]];
    user.userId = self.loginData[@"data"][@"appUser"][@"userId"];
    user.isLogin = YES;
    [CDAppUser setUser:user];
    
    //保存账号和token
    [[NSUserDefaults standardUserDefaults] setValue:self.loginData[@"data"][@"appUser"][@"userId"] forKey:KUserId];
    [[NSUserDefaults standardUserDefaults] setValue:self.telOrEmailTF.text forKey:KLoginAccount];
    
    //映射涂鸦
    [self mapTuYa];
    
    [self updataUserToTuYa];
    
    //创建家庭后, 绑定服务商
    [CDHelper bindDefaultChannel];
    
    //跳转首页
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc]init];
}

//映射涂鸦
-(void)mapTuYa{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"userId"] = self.loginData[@"data"][@"appUser"][@"userId"];
    parames[@"uid"] = self.uid;
    [HttpRequest HR_AppTuyaWithParams:parames success:^(id result) {
        NSLog(@"映射--%@",result);
    } failure:^(NSError *error) {
        NSLog(@"映射失败--%@",error);
    }];
}

-(void)updataUserToTuYa{
    CDAppUser *user = [CDAppUser getUser];
    
    NSString *accountName = @"";
    if (user.username) {
        accountName = user.username;
    }else if(user.mobile){
        accountName = user.mobile;
    }else if(user.email){
        accountName = user.email;
    }
    
    [[TuyaSmartUser sharedInstance] updateNickname:accountName success:^{
        NSLog(@"用户名更新成功");
    } failure:^(NSError *error) {
        NSLog(@"用户名更新失败");
    }];
    
    
    if (user.avatarUrl) {
        [[TuyaSmartUser sharedInstance] updateHeadIcon:[CDHelper getImageFromURL:user.avatarUrl] success:^{
            NSLog(@"头像更新成功");
        } failure:^(NSError *error) {
            NSLog(@"头像更新失败");
        }];
    }
   
}










@end
