//
//  ArmInfoViewController.m
//  m2mSecurity
//
//  Created by chendan on 2022/1/19.
//

#import "ArmInfoViewController.h"
#import "ArmInfoCell.h"


@interface ArmInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@property (nonatomic, strong)NSMutableArray *dataArr;

@end

static NSString *cellID = @"cellID";
@implementation ArmInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [CDHelper getColor:@"F01120"];
    
    [self getArmInfo];
    
    [self setupUI];
    
    [self setupAnimationWithColor:[UIColor redColor]];
}

-(void)setupUI{
    [self.myTableView registerNib:[UINib nibWithNibName:@"ArmInfoCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = 92;
}

-(void)getArmInfo{
    self.dataArr = [[NSMutableArray alloc]init];
    [[TuyaSecurity new] getAlarmInfoWithHomeId:[CDHelper getHomeId] success:^(TuyaSecurityAlarmDetailModel * _Nonnull result) {
        self.statusLab.text = result.stateDescription;
        for (TuyaSecurityAlarmMessageModel *model in result.alarmMessages) {
            ArmInfoModel *infoModel = [[ArmInfoModel alloc]init];
            infoModel.createTime = model.gmtCreate;
            infoModel.des = model.typeDesc;
            infoModel.devId = [model.deviceIds firstObject];
            [self.dataArr addObject:infoModel];
        }
        [self.myTableView reloadData];
    } failure:^(NSError * _Nonnull error) {
        [self.view pv_failureLoading:error.description];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ArmInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)setupAnimationWithColor:(UIColor *)color{
    
        UIView *animationView = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDRH*0.5-65, DEVICE_HEIGHT*0.5-65, 130, 130)];
        
        animationView.backgroundColor = color;
        animationView.layer.masksToBounds = YES;
        animationView.layer.cornerRadius = 65;
        [self.view addSubview:animationView];

        /*慢慢消失的动画*/
        CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        //动画完成后保持原状
        animation1.fillMode = kCAFillModeForwards;
        animation1.removedOnCompletion = NO;
        //值
        animation1.fromValue = [NSNumber numberWithFloat:0.6];
        animation1.toValue = [NSNumber numberWithFloat:0.1];
        animation1.duration = 1.2;//动画时间


        /*变大动画*/
        CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation2.fillMode = kCAFillModeForwards;
        animation2.removedOnCompletion = NO;
        //值
        animation2.fromValue = [NSNumber numberWithFloat:1.0];
        animation2.toValue = [NSNumber numberWithFloat:2.5];
        animation2.duration = 1.2;

        /*动画组，把上面两个动画组合起来*/
        CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
        groupAnnimation.duration = 1.2;
        groupAnnimation.repeatCount = MAXFLOAT;//无限循环
        groupAnnimation.animations = @[animation1, animation2];
        groupAnnimation.fillMode = kCAFillModeForwards;
        groupAnnimation.removedOnCompletion = NO;
        
        [animationView.layer removeAllAnimations];
        [animationView.layer addAnimation:groupAnnimation forKey:@"group"];
}

//撤防并取消报警
- (IBAction)che:(id)sender {
    [[TuyaSecurity new] cancelAlarmWithHomeId:[CDHelper getHomeId] action:TYHSGatewayStateCancelAlarmAndDisarm success:^(BOOL result) {
        if (result) {
            [self over];
        }else{
            [self.view pv_failureLoading:@"取消报警失败!"];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view pv_failureLoading:error.description];
    }];
}

//取消报警
- (IBAction)cancel:(id)sender {
    [[TuyaSecurity new] cancelAlarmWithHomeId:[CDHelper getHomeId] action:TYHSGatewayStateCancelAlarm success:^(BOOL result) {
        if (result) {
            [self over];
        }else{
            [self.view pv_failureLoading:@"取消报警失败!"];
        }
    } failure:^(NSError * _Nonnull error) {
        [self.view pv_failureLoading:error.description];
    }];
}

-(void)over{
    if (self.overBlcok) {
        self.overBlcok();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
