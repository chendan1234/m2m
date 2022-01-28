//
//  CDMineViewController.m
//  security
//
//  Created by chendan on 2021/6/21.
//

#import "CDMineViewController.h"
#import "CDMineCell.h"
#import "CDMineTopView.h"
#import "CDCommonDefine.h"
#import "CDModifyInfoViewController.h"
#import "CDLoginViewController.h"
#import "CDChangePwdViewController.h"

#import "CDDevicelistViewController.h"
#import "CDChangePhoneOrEmailViewController.h"
#import "CDOrderViewController.h"
#import "CDSubscribeViewController.h"
#import "ShareViewController.h"

#import "Home.h"


@interface CDMineViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NSMutableArray *dataArr;

@property (nonatomic, strong)CDMineTopView *topV;



@end

static NSString *cellID = @"cellID";
@implementation CDMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self setupUI];
    
    [self setupData];
    
    
}

-(void)setupData{
    
    NSArray *titles = [[NSArray alloc]initWithObjects:@"修改个人资料",@"修改密码",@"修改手机号码",@"修改邮箱地址",@"共享设备",@"订阅服务",@"我的订单",@"关于我们", nil];
    NSArray *images = [[NSArray alloc]initWithObjects:@"info",@"xiugaimima",@"change_phone",@"change_email",@"share",@"subscript",@"order",@"about", nil];
    
    self.dataArr = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < titles.count; i++) {
        CDMineModel *model = [[CDMineModel alloc]init];
        model.title = titles[i];
        model.icon = images[i];
        [self.dataArr addObject:model];
    }
    
    [self.myTableView reloadData];
}

-(void)setupUI{
    self.title = KMineTitle;
    self.myTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"CDMineCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = 50;
    
    CDMineTopView *topV = [CDMineTopView reload];
    topV.frame = CGRectMake(0, 0, DEVICE_WIDRH, 118);
    self.topV = topV;
    [topV setUpInfo];
    UIView *topHeaderV = [[UIView alloc]initWithFrame:topV.frame];
    [topHeaderV addSubview:topV];
    self.myTableView.tableHeaderView = topHeaderV;
    
    UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginOutBtn.frame = CGRectMake(24, 36, DEVICE_WIDRH - 48, 45);
    [loginOutBtn setTitle:@"退出账户" forState:UIControlStateNormal];
    loginOutBtn.backgroundColor = KBlueColor;
    loginOutBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    loginOutBtn.layer.masksToBounds = YES;
    loginOutBtn.layer.cornerRadius = 5.0;
    [loginOutBtn addTarget:self action:@selector(loginOutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDRH, 100)];
    [footerV addSubview:loginOutBtn];
    self.myTableView.tableFooterView = footerV;
}

-(void)loginOutBtnClick{
    [CDHelper loginOut];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDMineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0://修改个人资料
        {
            [self goToModifyInfoVC];
        }
            break;
        case 1://修改密码
        {
            CDChangePwdViewController *changePwdVC = [[CDChangePwdViewController alloc]init];
            [self.navigationController pushViewController:changePwdVC animated:YES];
        }
            break;
        case 2://修改手机号
        {
            [self goToPhoneOrEmailVCWithType:0];
        }
            break;
        case 3://修改邮箱
        {
            [self goToPhoneOrEmailVCWithType:1];
        }
            break;
        case 4://共享设备
        {
            ShareViewController *shareVC = [[ShareViewController alloc]init];
            [self.navigationController pushViewController:shareVC animated:YES];
        }
            break;
        case 5://订阅服务
        {
            [self goToSubscribeVC];
        }
            break;
        case 6://我的订单
        {
            CDOrderViewController *orderVC = [[CDOrderViewController alloc]init];
            [self.navigationController pushViewController:orderVC animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)goToPhoneOrEmailVCWithType:(NSInteger)type{
    
    
    if (type == 0) {//修改手机号
        if ([CDAppUser getUser].mobile.length == 0) {
            type = 2;//用邮箱来设置新手机号
        }
    }
    
    if (type == 1) {//修改邮箱
        if ([CDAppUser getUser].email.length == 0) {
            type = 3;//用手机来设置新邮箱
        }
    }
    
    CDChangePhoneOrEmailViewController *changePhoneVC = [[CDChangePhoneOrEmailViewController alloc]init];
    changePhoneVC.type = type;
    [self.navigationController pushViewController:changePhoneVC animated:YES];
}

//修改个人资料
-(void)goToModifyInfoVC{
    CDModifyInfoViewController *modifyVC = [[CDModifyInfoViewController alloc]init];
    [modifyVC setMyBlock:^{
        [self.topV setUpInfo];
    }];
    [self.navigationController pushViewController:modifyVC animated:YES];
}

//跳到订阅服务
-(void)goToSubscribeVC{
    
    if ([CDAppUser getUser].address.length == 0) {
        [CDHelper setupAlterWithVC:self title:@"请先设置您的家庭住址再重新订阅" message:@"" sure:^{
            [self goToModifyInfoVC];
        }];
        return;
    }
    
    if([CDAppUser getUser].mobile.length == 0){
        [CDHelper setupAlterWithVC:self title:@"请先设置您的手机号再重新订阅" message:@"" sure:^{
            [self goToPhoneOrEmailVCWithType:0];
        }];
        return;
    }
    
    CDSubscribeViewController *subscribeVC = [[CDSubscribeViewController alloc]init];
    [self.navigationController pushViewController:subscribeVC animated:YES];
}








@end
