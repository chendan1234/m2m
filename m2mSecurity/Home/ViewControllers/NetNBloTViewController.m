//
//  NetNBloTViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/9/4.
//

#import "NetNBloTViewController.h"
#import "ScanViewController.h"

@interface NetNBloTViewController ()

@end

@implementation NetNBloTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"设备配网";
}

- (IBAction)inputBianHao:(id)sender {
    [CDHelper setupTFAlertWithVC:self title:@"请输入设备编号" placeHolder:@"请输入设备编号" sure:^(NSString * _Nonnull tf) {
        
    }];
}

- (IBAction)scan:(id)sender {
    ScanViewController *scanVC = [[ScanViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
}

@end
