//
//  SelectUserShareViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import "SelectUserShareViewController.h"

@interface SelectUserShareViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (weak, nonatomic) IBOutlet UITextField *userTF;

@property (nonatomic, strong)TuyaSmartHomeDeviceShare *deviceShare;

@property (nonatomic, strong)NSString *account;

@end

@implementation SelectUserShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"选择共享用户";
    [self.segControl addTarget:self action:@selector(segChaneg) forControlEvents:UIControlEventValueChanged];
}



//点击事件
-(void)segChaneg {
    if (self.segControl.selectedSegmentIndex) {
        self.userTF.placeholder = @"请输入邮箱地址";
    }else{
        self.userTF.placeholder = @"请输入手机号码";
    }
}
 
//提交
- (IBAction)submit:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.segControl.selectedSegmentIndex) {//邮箱
        if (self.userTF.text.length == 0) {
            [self.view pv_warming:@"请输入邮箱地址"];
            return;
        }
    }else{
        if (self.userTF.text.length == 0) {
            [self.view pv_warming:@"请输入手机号码"];
            return;
        }
    }
    
    [self shareDevices];
}

-(void)shareDevices{
    
    [self.view pv_showTextDialog:@"共享中..."];
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"account"] = self.userTF.text;
    
    [HttpRequest HR_AppInfoByEmailOrMobileWithParams:parames success:^(id result) {
        NSLog(@"----%@",result);
        if ([result[@"code"] intValue] == 200) {
            self.account = [CDHelper getUidWith:result[@"data"][@"userId"]];
            [self sureSubmit];
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:@"网络连接失败!"];
    }];
    
}



-(void)sureSubmit{
    self.deviceShare  = [[TuyaSmartHomeDeviceShare alloc] init];
    
    NSMutableArray *devIds = [[NSMutableArray alloc]init];
    for (TuyaSmartDeviceModel *deviceModel in self.deviceArr) {
        [devIds addObject:deviceModel.devId];
    }
    
    TuyaSmartDeviceShareRequestModel *shareModel = [[TuyaSmartDeviceShareRequestModel alloc]init];
    shareModel.countryCode = @"1";
    shareModel.devIds = devIds;
    shareModel.homeID = [CDHelper getHomeId];
    shareModel.userAccount = self.account;
    
    __weak typeof(self) weakSelf = self;
    [self.deviceShare addDeviceShareWithRequestModel:shareModel success:^(TuyaSmartShareMemberModel *model) {
        [weakSelf.view pv_successLoading:@"共享成功!"];
    } failure:^(NSError *error) {
        [weakSelf.view pv_failureLoading:error.localizedDescription];
    }];
}





@end
