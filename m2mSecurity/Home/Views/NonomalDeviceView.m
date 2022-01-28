//
//  NonomalDeviceView.m
//  m2mSecurity
//
//  Created by chendan on 2021/12/16.
//

#import "NonomalDeviceView.h"
#import "NonomalDeviceSubCell.h"

@interface NonomalDeviceView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *deviceTableView;

@end


static NSString *cellID = @"cellID";

@implementation NonomalDeviceView

+(instancetype)reload{
    return [[[NSBundle mainBundle]loadNibNamed:@"NonomalDeviceView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.deviceTableView registerNib:[UINib nibWithNibName:@"NonomalDeviceSubCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.deviceTableView.rowHeight = 30;
    self.deviceTableView.dataSource = self;
    self.deviceTableView.showsVerticalScrollIndicator = NO;
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.deviceTableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NonomalDeviceSubCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell;
}


//取消
- (IBAction)cancel:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

//继续布防
- (IBAction)sure:(id)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
}

@end
