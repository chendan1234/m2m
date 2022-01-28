//
//  HelpDetailViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/10/13.
//

#import "HelpDetailViewController.h"
#import <WebKit/WebKit.h>

@interface HelpDetailViewController ()

@property (nonatomic, strong)WKWebView *webView;

@end

@implementation HelpDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setWebview];
}

-(void)setWebview{
    
    self.title = @"帮助中心";
    
    WKWebView *webView = [[WKWebView alloc]init];
    webView.frame = CGRectMake(0, 0, DEVICE_WIDRH, DEVICE_HEIGHT);
    self.webView = webView;
    [self.view addSubview:webView];
    
    [self setHtml];
}


-(void)setHtml{
    NSString *htmls = [NSString stringWithFormat:@"<html> \n"
                       "<head> \n"
                       "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\">\n"
                       "<style type=\"text/css\"> \n"
                       "body {font-size:16px;color: #333;text-align:justify;text-justify:inter-ideograph;margin-left:15px;margin-right:15px;}\n"
                       "</style> \n"
                       "</head> \n"
                       "<body>"
                       "<script type='text/javascript'>"
                       "window.onload = function(){\n"
                       "var $img = document.getElementsByTagName('img');\n"
                       "for(var p in  $img){\n"
                       " $img[p].style.width = '100%%';\n"
                       "$img[p].style.height ='auto'\n"
                       "}\n"
                       "}"
                       "</script>\n"
                       "<div style=\"text-align: center; color: #000;font-size: 21px;font-weight: 500;margin-bottom: 6px;\">%@</div>"
                       "<div style=\"text-align: center; color: #666;font-size: 15px;margin-bottom: 10px;\">%@</div>"
                       "<div>%@<div/>"
                       "</body>"
                       "</html>",self.model.title,[CDHelper time_timestampToString:self.model.createTime/1000],self.model.content];
    
    [self.webView loadHTMLString:htmls baseURL:nil];

}

@end
