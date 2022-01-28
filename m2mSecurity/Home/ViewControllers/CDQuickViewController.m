//
//  CDQuickViewController.m
//  Security
//
//  Created by chendan on 2021/7/6.
//

#import "CDQuickViewController.h"
#import "UIView+ProgressView.h"
#import "CDQuickCell.h"
#import "CDHelper.h"

#import "CDHandleQuickViewController.h"
#import "ScanViewController.h"
#import "CDArmModel.h"


@interface CDQuickViewController ()<UITableViewDelegate,UITableViewDataSource,TuyaSmartActivatorDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UILabel *tipLab;

@property (nonatomic, strong)NSMutableArray *dataArr;
@property (weak, nonatomic) IBOutlet UIImageView *searchView;
@property (weak, nonatomic) IBOutlet UIView *bgV;

@end

#define ARC4RANDOM_MAX      0x100000000
static NSString *cellID = @"cellID";
@implementation CDQuickViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopConfigWifi];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startConfiguration];
}

- (void)stopConfigWifi {
    if ([CDHelper getWangGuanModel]) {
        [TuyaSmartActivator sharedInstance].delegate = nil;
        [[TuyaSmartActivator sharedInstance] stopActiveSubDeviceWithGwId:[CDHelper getWangGuanModel].devId];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"自动发现";
    
//    [self setupTableView];
    
    [CDHelper getWangGuanModel];
    
    self.navigationItem.rightBarButtonItem  = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"scan"] style:UIBarButtonItemStylePlain target:self action:@selector(scan)];
    
    [self rotateView:self.searchView];
    
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startConfiguration) name:KHavedWangGuan object:nil];
    
}

- (void)startConfiguration {
    if ([CDHelper getWangGuanModel]) {
        self.tipLab.text = @"正在搜索...";
        self.dataArr = [[NSMutableArray alloc]init];
        [TuyaSmartActivator sharedInstance].delegate = self;
        [[TuyaSmartActivator sharedInstance] activeSubDeviceWithGwId:[CDHelper getWangGuanModel].devId timeout:100];
    }else{
        self.tipLab.text = @"请先手动添加网关...";
    }
}


- (void)rotateView:(UIImageView *)view
{
    [view.layer removeAllAnimations];
      CABasicAnimation *rotationAnimation;
      rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
      rotationAnimation.removedOnCompletion = NO;
      rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*2.0];
      rotationAnimation.duration = 1.5;
      rotationAnimation.repeatCount = HUGE_VALF;
     [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];

}

-(void)scan{
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
}

-(void)setupTableView{
    [self.myTableView registerNib:[UINib nibWithNibName:@"CDQuickCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = 76;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CDQuickCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}



- (IBAction)handAdd:(id)sender {
    CDHandleQuickViewController *handleVC = [[CDHandleQuickViewController alloc]init];
    [self.navigationController pushViewController:handleVC animated:YES];
}


#pragma mark - TuyaSmartActivatorDelegate
-(void)activator:(TuyaSmartActivator *)activator didReceiveDevice:(TuyaSmartDeviceModel *)deviceModel error:(NSError *)error {
    if (deviceModel && error == nil) {
//        [self.dataArr addObject:deviceModel];
//        [self.myTableView reloadData];
        
        [self addIconWith:deviceModel];
        [self saveDevice];
    }
    if (error) {
        [self.view pv_failureLoading:error.localizedDescription];
    }
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

-(void)addIconWith:(TuyaSmartDeviceModel *)deviceModel{
    
    self.tipLab.text = @"以下设备已添加成功~~~";
    
    CGFloat arrange = 300.00;
    double valW = ((double)arc4random() / ARC4RANDOM_MAX);
    double valH = ((double)arc4random() / ARC4RANDOM_MAX);
    
    CGRect rect = CGRectMake(arrange * valW, arrange * valH, 70, 70);
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:rect];
    imageV.image = [UIImage imageNamed:[CDHelper getDeviceImageModel:deviceModel]];
    imageV.contentMode = UIViewContentModeCenter;
    
    imageV.backgroundColor = [UIColor whiteColor];
    imageV.layer.cornerRadius = 25;
    imageV.layer.masksToBounds = YES;
    imageV.layer.borderColor = KColorA(0, 122, 255, 0.5).CGColor;
    imageV.layer.borderWidth = 3.0;
    
    [self.bgV addSubview:imageV];
}


@end
