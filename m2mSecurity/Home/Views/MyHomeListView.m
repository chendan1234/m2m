//
//  MyHomeListView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/17.
//

#import "MyHomeListView.h"
#import "MyHomeListCell.h"

@interface MyHomeListView()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property(strong, nonatomic) TuyaSmartHomeManager *homeManager;

@property (nonatomic, strong)NSArray *homeList;

@end

static NSString *cellID = @"cellID";
@implementation MyHomeListView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MyHomeListView" owner:nil options:nil]lastObject];
}

- (TuyaSmartHomeManager *)homeManager {
    if (!_homeManager) {
        _homeManager = [[TuyaSmartHomeManager alloc] init];
    }
    return _homeManager;
}

- (void)getHomeList {
    __weak typeof(self) weakSelf = self;
    
    [self.homeManager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        // homes 家庭列表
        weakSelf.homeList = homes;
//        [weakSelf pv_hideMBHub];
        [weakSelf.myTableView reloadData];
    } failure:^(NSError *error) {
    }];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyHomeListCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = 44;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    
    [self.myTableView addNoteViewWithpicName:@"noHomeSmall" noteText:@"" refreshBtnImg:nil orginY:21];
    [self getHomeList];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.homeList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.model = self.homeList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myBlock) {
        self.myBlock(0,self.homeList[indexPath.row]);
    }
}

- (IBAction)homeManageBtnClick:(id)sender {
    if (self.myBlock) {
        self.myBlock(1,[[TuyaSmartHomeModel alloc]init]);
    }
}

@end
