//
//  ShuXingView.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/17.
//

#import "ShuXingView.h"
#import "ShuXingCell.h"

@interface ShuXingView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

static NSString *cellId = @"cellId";
@implementation ShuXingView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"ShuXingView" owner:nil options:nil]lastObject];
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"ShuXingCell" bundle:nil] forCellReuseIdentifier:cellId];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.rowHeight = 55;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab.text = title;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShuXingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.title = self.dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectBlock) {
        self.selectBlock(self.dataArr[indexPath.row]);
    }
}

- (IBAction)cancel:(id)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
