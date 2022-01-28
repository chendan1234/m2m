//
//  HomeDeleteViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/17.
//

#import "HomeDeleteViewController.h"

@interface HomeDeleteViewController ()
@property (weak, nonatomic) IBOutlet UIView *changeNameBgV;
@property (weak, nonatomic) IBOutlet UILabel *homeNameLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@property (nonatomic, strong)TuyaSmartHome *home;

@end

@implementation HomeDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"家庭管理";
    self.homeNameLab.text = self.model.name;
    self.home = [TuyaSmartHome homeWithHomeId:self.model.homeId];
    [self getDeviceList];
    
    [self.changeNameBgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeNameBgVClick)]];
}

-(void)changeNameBgVClick{
    [CDHelper setupTFAlertWithVC:self title:@"家庭名称" placeHolder:@"请输入家庭名称" sure:^(NSString * _Nonnull tf) {
        [self updateHomeInfoWith:tf];
    }];
}

- (void)updateHomeInfoWith:(NSString *)homeName {
    __weak typeof(self) weakSelf = self;
    [self.view pv_showTextDialog:@"正在修改家庭名称..."];
    [self.home updateHomeInfoWithName:homeName geoName:self.model.geoName latitude:self.model.latitude longitude:self.model.longitude success:^{
        weakSelf.homeNameLab.text = homeName;
        if (self.deleteBlock) {
            self.deleteBlock(self.model);
        }
        [weakSelf.view pv_hideMBHub];
    } failure:^(NSError *error) {
        [weakSelf.view pv_failureLoading:@"update home info failure"];
    }];
}

-(void)getDeviceList{
    __weak typeof(self) weakSelf = self;
    [self.home getHomeDetailWithSuccess:^(TuyaSmartHomeModel *homeModel) {
        self.numLab.text = [NSString stringWithFormat:@"%ld个",self.home.deviceList.count];
    } failure:^(NSError *error) {
        [weakSelf.view pv_failureLoading:@"get device info failure"];
    }];
}



- (IBAction)deleteHome:(id)sender {
    
    NSString *title = [NSString stringWithFormat:@"确认删除%@",self.model.name];
    NSString *content = @"删除该家庭后，该家庭中的所有设备都将被解绑重置，是否删除?";
    
    if ([CDHelper getHomeId] == self.model.homeId) {
        content = @"该家庭为您的选中家庭, 删除该家庭后其所有设备都将被解绑重置, 您可在首页重新选择家庭添加设备, 是否删除?";
    }
    
    [CDHelper setupAlterWithVC:self title:title message:content sure:^{
        [self sureDelete];
    }];
}

-(void)sureDelete{
    __weak typeof(self) weakSelf = self;
    [self.view pv_showTextDialog:@"正在删除该家庭..."];
    [self.home dismissHomeWithSuccess:^() {
        [weakSelf.view pv_successLoading:@"删除成功!"];
        if (self.deleteBlock) {
            self.deleteBlock(self.model);
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        [weakSelf.view pv_failureLoading:@"删除失败!"];
    }];
}


@end
