//
//  MessageViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/16.
//

#import "MessageViewController.h"
#import "UITabBar+CustomBadge.h"
#import "MessageCell.h"
#import "MessageDetailViewController.h"


@interface MessageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, assign)NSInteger page;

@end

static NSString *cellID = @"cellID";
@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"消息中心";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"全部已读" style:UIBarButtonItemStylePlain target:self action:@selector(allRead)];
    [self setupTableView];
}

-(void)allRead{
    
    [HttpRequest HR_AppPushHaveReadWithContent:[[NSUserDefaults standardUserDefaults] objectForKey:KUserId] Params:@{} success:^(id result) {
        if ([result[@"code"] intValue] == 200) {
            [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            [self.myTableView.mj_header beginRefreshing];
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNetWorkError];
    }];
}

-(void)setupTableView{
    [self.myTableView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = 215;
    [self.myTableView addNoteViewWithpicName:@"noNoti" noteText:@"" refreshBtnImg:nil orginY:120];
    
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self getData];
        [CDHelper getNoReadMessageNum];
    }];
    
    self.myTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self getData];
    }];
    
    [self.myTableView.mj_header beginRefreshing];
}

-(void)getData{
    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    parames[@"page"] = @(self.page);
    parames[@"size"] = @(10);
    parames[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:KUserId];
    
    [HttpRequest HR_AppPushListWithParams:parames success:^(id result) {
        if ([result[@"code"] intValue] == 200) {
            if (self.page == 1) {
                self.dataArr = [MessageModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"data"]];
            }else{
                NSArray *arr = [MessageModel mj_objectArrayWithKeyValuesArray:result[@"data"][@"data"]];
                [self.dataArr addObjectsFromArray:arr];
            }
            [self.myTableView reloadData];
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
        
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
        
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNewFeature];
        [self.myTableView.mj_header endRefreshing];
        [self.myTableView.mj_footer endRefreshing];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModel *model = self.dataArr[indexPath.row];
    model.isRead = YES;
    
    NSIndexPath *index=[NSIndexPath indexPathForRow:indexPath.row inSection:0];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationNone];
    
    MessageDetailViewController *detailVC = [[MessageDetailViewController alloc] init];
    detailVC.pushId = model.pushId;
    [self.navigationController pushViewController:detailVC animated:YES];
}







@end
