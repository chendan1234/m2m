//
//  HelpViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/16.
//

#import "HelpViewController.h"
#import "HelpCell.h"
#import "HelpDetailViewController.h"


@interface HelpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@end

static NSString *cellID = @"cellId";
@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"帮助中心";
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"HelpCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 57;
    [self.myTableView addNoteViewWithpicName:@"noContent" noteText:@"" refreshBtnImg:nil orginY:120];
    
    [self getData];
}

-(void)getData{
    
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"page"] = @(1);
    parames[@"size"] = @(100);
    
    [self.view pv_showTextDialog:KLogining];
    [HttpRequest HR_AppAssistanceWithParams:parames success:^(id result) {
        if ([result[@"code"] intValue] == 200) {
            [self.view pv_hideMBHub];
            self.dataArr = [HelpModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"data"]];
            [self.myTableView reloadData];
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNetWorkError];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HelpDetailViewController *detailVC = [[HelpDetailViewController alloc]init];
    detailVC.model = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}



@end
