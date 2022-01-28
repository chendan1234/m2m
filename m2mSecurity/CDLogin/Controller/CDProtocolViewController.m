//
//  CDProtocolViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/10/25.
//

#import "CDProtocolViewController.h"
#import <WebKit/WebKit.h>

@interface CDProtocolViewController ()

@end

@implementation CDProtocolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"用户协议";
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"protocol" withExtension:@"rtf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    WKWebView *webView = [[WKWebView alloc]init];
    webView.frame = CGRectMake(0, 0, DEVICE_WIDRH, DEVICE_HEIGHT);
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    [self.view pv_showTextDialog:KLogining];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view pv_hideMBHub];
    });
    
}


@end
