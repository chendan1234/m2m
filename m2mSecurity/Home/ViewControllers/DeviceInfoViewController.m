//
//  DeviceInfoViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import "DeviceInfoViewController.h"
#import "DeviceInfoView.h"
#import "DeviceWangGuanInfoView.h"
#import "DeviceShengGuangView.h"
#import "MenLingInfoView.h"

@interface DeviceInfoViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = self.deviceModel.name;
    [self setupContentView];
}

-(void)setupContentView{
    
    UIView *contentView = [[UIView alloc]init];
    
    switch (self.form) {
        case DeviceInfoFormDefault:
        {
            DeviceInfoView *infoView = [DeviceInfoView reload];
            infoView.frame = CGRectMake(0, 0, DEVICE_WIDRH, 425);
            infoView.deviceModel = self.deviceModel;
            contentView.frame = infoView.bounds;
            [contentView addSubview:infoView];
        }
            break;
        case DeviceInfoFormWangGuan:
        {
            DeviceWangGuanInfoView *infoView = [DeviceWangGuanInfoView reload];
            infoView.frame = CGRectMake(0, 0, DEVICE_WIDRH, 710);
            infoView.deviceModel = self.deviceModel;
            contentView.frame = infoView.bounds;
            [contentView addSubview:infoView];
        }
            break;
        case DeviceInfoFormShengGuang:
        {
            DeviceShengGuangView *infoView = [DeviceShengGuangView reload];
            infoView.frame = CGRectMake(0, 0, DEVICE_WIDRH, 640);
            infoView.deviceModel = self.deviceModel;
            contentView.frame = infoView.bounds;
            [contentView addSubview:infoView];
        }
            break;
        case DeviceInfoFormShiPing:
        {
            MenLingInfoView *infoView = [MenLingInfoView reload];
            infoView.frame = CGRectMake(0, 0, DEVICE_WIDRH, 1000);
            infoView.deviceModel = self.deviceModel;
            contentView.frame = infoView.bounds;
            [contentView addSubview:infoView];
        }
            break;
        
            
        default:
            break;
    }
    
    self.myTableView.tableHeaderView = contentView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}



@end
