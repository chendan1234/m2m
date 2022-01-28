//
//  SelectHomeView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/20.
//

#import "SelectHomeView.h"
#import "MyHomeListCell.h"

@interface SelectHomeView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end

static NSString *cellID = @"cellID";
@implementation SelectHomeView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SelectHomeView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.myTableView registerNib:[UINib nibWithNibName:@"MyHomeListCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.myTableView.rowHeight = 44;
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.myBlock) {
        self.myBlock();
    }
}

@end
