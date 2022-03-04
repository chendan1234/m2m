//
//  AboutUsViewController.m
//  m2mSecurity
//
//  Created by chendan on 2022/3/3.
//

#import "AboutUsViewController.h"
#import "CDProtocolViewController.h"

@interface AboutUsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLab;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"关于我们";
    

    //此获取的版本号对应version，打印出来对应为1.2.3.4.5这样的字符串
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.versionLab.text = [NSString stringWithFormat:@"v%@",version];
}

//检查新版本
- (IBAction)xin:(id)sender {
//    [self.view pv_warming:@"上线了才能整这个!"];
}

//用户协议
- (IBAction)xie:(id)sender {
    CDProtocolViewController *proVC = [[CDProtocolViewController alloc]init];
    [self.navigationController pushViewController:proVC animated:YES];
}

@end
