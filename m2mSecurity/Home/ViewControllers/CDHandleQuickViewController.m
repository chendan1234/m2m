//
//  CDHandleQuickViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/17.
//

#import "CDHandleQuickViewController.h"
#import "HandleLeftCell.h"
#import "HandleRightCell.h"
#import "DeviceModel.h"
#import "AddDeviceNewViewController.h"
#import "AddDeviceAPViewController.h"
#import "AddDeviceZigbeeViewController.h"

#import "AddDeviceZigbeeViewController.h"
#import "AddDeviceWiredViewController.h"
#import "NetNBloTViewController.h"

@interface CDHandleQuickViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

@property (nonatomic, strong)NSArray *leftArr;
@property (nonatomic, strong)NSMutableArray *rightArr;
@property (nonatomic, assign)NSInteger selectIndex;


@end

static NSString *leftCellID = @"leftCellID";
static NSString *rightCellID = @"rightCellID";
@implementation CDHandleQuickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"手动添加";
    
    [self setupTableView];
    [self setupData];
}

-(void)setupData{
    self.leftArr = @[@"网关设备",@"家居安防",@"其他设备"];
    [self.leftTableView reloadData];
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    self.selectIndex = 0;
    
    self.rightArr = [[NSMutableArray alloc]init];
    [self.rightArr addObject:[self setupWangGuanData]];
    [self.rightArr addObject:[self setupDevices]];
    [self.rightArr addObject:[self setupOther]];
    
    [self.rightTableView reloadData];
    
}

-(NSArray *)setupWangGuanData{
    NSArray *images = @[@"wg",@"wg"];
    NSArray *titles = @[@"网关(Wi-Fi)",@"网关(AP)"];
    NSArray *contentTypes = @[@"2",@"3"];
    
    NSMutableArray *wangGuanArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<images.count ; i++) {
        DeviceModel *model = [CDHelper setDeviceModelWithImage:images[i] title:titles[i] contentType:[contentTypes[i] intValue]];
        model.isWangGuan = YES;
        [wangGuanArr addObject:model];
    }
    return wangGuanArr;
    
}
//1.二维码 2.快连 3.AP 4.子设备 5.有线
-(NSArray *)setupDevices{
    NSArray *images = @[@"ml",@"yg",@"an",@"rt",@"yk",@"mc",@"sg",@"sq"];
    NSArray *titles = @[@"智能门铃(QR)",@"烟雾报警(Wi-Fi)",@"紧急按钮(Zigbee)",@"人体感应(Zigbee)",@"遥控器(Zigbee)",@"门磁(Zigbee)",@"声光(Zigbee)",@"水浸(Zigbee)"];
    NSArray *contentTypes = @[@"1",@"2",@"4",@"4",@"4",@"4",@"4",@"4"];
    
    NSMutableArray *devices = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<images.count ; i++) {
        DeviceModel *model = [CDHelper setDeviceModelWithImage:images[i] title:titles[i] contentType:[contentTypes[i] intValue]];
        [devices addObject:model];
    }
    return devices;
}

-(NSArray *)setupOther{
    NSArray *images = @[@"otherDevice",@"otherDevice",@"otherDevice"];
    NSArray *titles = @[@"Wi-Fi快连设备(Wi-Fi)",@"热点链接设备(AP)",@"网关子设备(Zigbee)"];
    NSArray *contentTypes = @[@"2",@"3",@"4"];
    
    NSMutableArray *others = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i<images.count ; i++) {
        DeviceModel *model = [CDHelper setDeviceModelWithImage:images[i] title:titles[i] contentType:[contentTypes[i] intValue]];
        [others addObject:model];
    }
    return others;
}



-(void)setupTableView{
    [self.leftTableView registerNib:[UINib nibWithNibName:@"HandleLeftCell" bundle:nil] forCellReuseIdentifier:leftCellID];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"HandleRightCell" bundle:nil] forCellReuseIdentifier:rightCellID];
    [self.rightTableView addNoteViewWithpicName:@"noDevice" noteText:@"" refreshBtnImg:nil orginY:120];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.leftArr.count;
    }else{
        NSArray *rightArr = self.rightArr[self.selectIndex];
        return rightArr.count;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.leftTableView) {
        HandleLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellID];
        cell.titleLab.text = self.leftArr[indexPath.row];
        return cell;
    }else{
        HandleRightCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCellID];
        NSArray *rightArr = self.rightArr[self.selectIndex];
        cell.model = rightArr[indexPath.row];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        self.selectIndex = indexPath.row;
        [self.rightTableView reloadData];
    }else{
        NSArray *rightArr = self.rightArr[self.selectIndex];
        DeviceModel *model = rightArr[indexPath.row];
        
        if (self.selectIndex == 0) {
            if ([CDHelper isHaveWangGuan]) {
                [CDHelper setupOneBtnAlterWithVC:self title:@"已有网关设备, 请勿重复添加" message:@"一个家庭只允许添加一个网关设备, 可删除之前的网关设备, 再做添加..." sure:^{}];
                return;
            }
        }
        
        switch (model.contentType) {
            case 1:
            {
                AddDeviceNewViewController *netVC = [[AddDeviceNewViewController alloc]init];
                netVC.type = model.contentType;
                netVC.isWangGuan = model.isWangGuan;
                [self.navigationController pushViewController:netVC animated:YES];
            }
                break;
            case 2:
            {
                AddDeviceNewViewController *netVC = [[AddDeviceNewViewController alloc]init];
                netVC.type = model.contentType;
                netVC.isWangGuan = model.isWangGuan;
                [self.navigationController pushViewController:netVC animated:YES];
            }
                break;
            case 3:
            {
                AddDeviceAPViewController *netVC = [[AddDeviceAPViewController alloc]init];
                netVC.isWangGuan = model.isWangGuan;
                [self.navigationController pushViewController:netVC animated:YES];
            }
                break;
            case 4:
            {
                
                TuyaSmartDeviceModel *wangGuanModel = [CDHelper getWangGuanModel];
                if (wangGuanModel) {
                    AddDeviceZigbeeViewController *netVC = [[AddDeviceZigbeeViewController alloc]init];
                    netVC.wangGuanModel = wangGuanModel;
                    netVC.isWangGuan = model.isWangGuan;
                    [self.navigationController pushViewController:netVC animated:YES];
                }else{
                    [CDHelper setupOneBtnAlterWithVC:self title:@"请先添加网关设备" message:@"您还未添加网关设备, 请先添加网关设备, 再添加子设备" sure:^{}];
                }
                
            }
                break;
            case 5:
            {
                AddDeviceWiredViewController *netVC = [[AddDeviceWiredViewController alloc]init];
//                netVC.isWangGuan = model.isWangGuan;
                [self.navigationController pushViewController:netVC animated:YES];
            }
                break;
            case 6:
            {
                NetNBloTViewController *NBVC = [[NetNBloTViewController alloc]init];
//                netVC.isWangGuan = model.isWangGuan;
                [self.navigationController pushViewController:NBVC animated:YES];
            }

                
            default:
                break;
        }
        
        
        
//        if (model.contentType) {//二维码配网
//            AddDeviceNewViewController *netVC = [[AddDeviceNewViewController alloc]init];
//            netVC.type = 1;
//            [self.navigationController pushViewController:netVC animated:YES];
//        }else{//EZ配网
//            AddDeviceNewViewController *netVC = [[AddDeviceNewViewController alloc]init];
//            netVC.type = 2;
//            [self.navigationController pushViewController:netVC animated:YES];
//        }
        
//        AddDeviceZigbeeViewController *zigbeeVC = [[AddDeviceZigbeeViewController alloc]init];
//        [self.navigationController pushViewController:zigbeeVC animated:YES];
        
        
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        return 50;
    }else{
        return 67;
    }
}


@end
