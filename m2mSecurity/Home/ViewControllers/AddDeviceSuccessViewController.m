//
//  AddDeviceSuccessViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/31.
//

#import "AddDeviceSuccessViewController.h"
#import "CDArmModel.h"


@interface AddDeviceSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@end

@implementation AddDeviceSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(overClick)];
    
    self.nameLab.text = self.deviceModel.name;
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:self.deviceModel.iconUrl] placeholderImage:[UIImage imageNamed:@"scanBg"]];
    
    [CDHelper judgeIsHavedWangGuanWithVc:self deviceModel:self.deviceModel];
    
    [self saveDevice];
}

//保存设备到布防(在家布防, 离家布防)
-(void)saveDevice{
    CDArmModel *armModel = [[CDArmModel alloc]init];
    [armModel saveDevice];
    
    [armModel setOverBlock:^{//保存成功
        NSLog(@"设备保存成功");
    }];
    
    [armModel setFailBlock:^(NSString * _Nonnull reason) {
        NSLog(@"设备保存失败 --- %@",reason);
    }];
}


-(void)leftClick{
    
}

-(void)overClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)edit:(id)sender {
    [CDHelper setupTFAlertWithVC:self title:@"修改设备名称" placeHolder:@"请输入设备名称" sure:^(NSString * _Nonnull tf) {
        
        [self.view pv_showTextDialog:@"正在修改设备名称..."];
        TuyaSmartDevice *device = [TuyaSmartDevice deviceWithDeviceId:self.deviceModel.devId];
        [device updateName:tf success:^{
            [self.view pv_successLoading:@"设备名称修改成功!"];
            self.nameLab.text = tf;
        } failure:^(NSError *error) {
            [self.view pv_failureLoading:@"设备名称修改失败!"];
        }];
    }];
    
    
}

@end
