//
//  ShareDeviceLlistViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/7.
//

#import "ShareDeviceLlistViewController.h"
#import "MyShareCell.h"

@interface ShareDeviceLlistViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong)NSArray *dataArr;

@property (nonatomic, strong)TuyaSmartHomeDeviceShare *deviceShare;

@property (nonatomic, assign)NSInteger memberId;

@end

static NSString *cellID = @"cellID";
@implementation ShareDeviceLlistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    if (self.type == 2) {
        self.title = [NSString stringWithFormat:@"共享给%@",self.model.nickName];
    }else{
        self.title = [NSString stringWithFormat:@"由%@共享给我",self.model.nickName];
    }
    
    self.deviceShare = [[TuyaSmartHomeDeviceShare alloc]init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteShare)];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyShareCell" bundle:nil] forCellReuseIdentifier:cellID];

    self.myTableView.rowHeight = 70;
    self.myTableView.contentInset = UIEdgeInsetsMake(4, 0, 0, 0);
    self.myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.myTableView addNoteViewWithpicName:@"noDevice" noteText:@"" refreshBtnImg:nil orginY:120];
    
    
    [self getData];
}

-(void)deleteShare{
    [CDHelper setupAlterWithVC:self title:@"确定删除该共享者" message:@"删除该共享者, 您与之的共享设备将全部移除!" sure:^{
        [self deleteUser];
    }];
}

-(void)deleteUser{
    [self.view pv_showTextDialog:@"正在删除..."];
    if (self.type == 2) {//我分享给别人, 删除收到共享者
        [self.deviceShare removeShareMemberWithMemberId:self.model.memberId success:^{
            [self deleteSuccess];
        } failure:^(NSError *error) {
            [self.view pv_failureLoading:@"共享者删除失败!"];
        }];
    }else{//别人分享给我, 删除主动共享者
        [self.deviceShare removeReceiveShareMemberWithMemberId:self.model.memberId success:^{
            [self deleteSuccess];
        } failure:^(NSError *error) {
            [self.view pv_failureLoading:@"共享者删除失败!"];
        }];
    }
}

-(void)deleteSuccess{
    [self.view pv_successLoading:@"已删除!"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.deleteBlock) {
            self.deleteBlock();
        }
        [self.navigationController popViewControllerAnimated:YES];
    });
}

-(void)getData{
    [self.view pv_showTextDialog:@"加载中..."];
    if (self.type == 2) {
        
        [self.deviceShare getShareMemberDetailWithMemberId:self.model.memberId success:^(TuyaSmartShareMemberDetailModel *model) {
            self.dataArr = model.devices;
            [self.myTableView reloadData];
            [self.view pv_hideMBHub];
        } failure:^(NSError *error) {
            [self getData];
        }];
        
    }else{
        
        [self.deviceShare getReceiveMemberDetailWithMemberId:self.model.memberId success:^(TuyaSmartReceiveMemberDetailModel *model) {
            self.dataArr = model.devices;
            [self.myTableView reloadData];
            [self.view pv_hideMBHub];
            
        } failure:^(NSError *error) {
            [self getData];
        }];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyShareCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.dataArr[indexPath.row];
    cell.memberId = self.model.memberId;
    [cell setReloadBlock:^{
        [self deleteDeviceWith:indexPath.row];
    }];
    return cell;
}

-(void)deleteDeviceWith:(NSInteger)row{
    TuyaSmartDeviceModel *model = self.dataArr[row];
    TuyaSmartHomeDeviceShare *deviceShare  = [[TuyaSmartHomeDeviceShare alloc] init];
    
    
    if (self.type == 2) {
        [deviceShare removeDeviceShareWithMemberId:self.model.memberId devId:model.devId success:^{
            [self getData];
        } failure:^(NSError *error) {
            [self.view pv_failureLoading:@"设备移除共享失败!"];
        }];
    }else{
        TuyaSmartDevice *device = [[TuyaSmartDevice alloc]initWithDeviceId:model.devId];
        [device removeReceiveDeviceShareWithSuccess:^{
            [self getData];
        } failure:^(NSError *error) {
            [self.view pv_failureLoading:@"设备移除共享失败!"];
        }];
    }
    
}




@end
