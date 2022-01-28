//
//  MessageDetailViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/10/11.
//

#import "MessageDetailViewController.h"
#import "MessageDetailModel.h"
#import <WebKit/WebKit.h>
#import "CDSubscribeViewController.h"
#import "CDOrderDetailViewController.h"

@interface MessageDetailViewController ()<WKScriptMessageHandler>

@property (nonatomic, strong)MessageDetailModel *model;

@property (nonatomic, strong)WKWebView *webView;

@end

#define KCallbackHandler @"callbackHandler"

@implementation MessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setWebView];
    [self getData];
}

-(void)setWebView{
    self.title = @"消息详情";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
    WKPreferences *preference = [[WKPreferences alloc]init];
    preference.minimumFontSize = 0;
    preference.javaScriptEnabled = YES;
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    
    __weak typeof(self) weakSelf = self;
    WKUserContentController * wkUController = [[WKUserContentController alloc] init];
    [wkUController addScriptMessageHandler:weakSelf  name:KCallbackHandler];
    config.userContentController = wkUController;
    
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:KCallbackHandler];

    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    webView.frame = CGRectMake(0, 0, DEVICE_WIDRH, DEVICE_HEIGHT);
    self.webView = webView;
    [self.view addSubview:webView];
}



-(void)getData{
    [self.view pv_showTextDialog:KLogining];
    [HttpRequest HR_AppPushDetailWithContent:self.pushId Params:@{} success:^(id result) {
        if ([result[@"code"] intValue] == 200) {
            [self.view pv_hideMBHub];
            self.model = [MessageDetailModel mj_objectWithKeyValues:result[@"data"]];
            [CDHelper getNoReadMessageNum];//修改未读数量
            [self setHtml];
        }else{
            [CDHelper dealWithPingTaiErrorWithVC:self result:result];
        }
    } failure:^(NSError *error) {
        [self.view pv_failureLoading:KNetWorkError];
    }];
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
                       "</html>",self.model.title,[CDHelper time_timestampToString:self.model.createTime/1000],self.model.info];
    
    [self.webView loadHTMLString:htmls baseURL:nil];

}

-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"callbackHandler"]) {
        NSDictionary *dic = [CDHelper jsonToDic:message.body];
        if ([dic[@"type"] intValue] == 1) {//订单详情
            CDOrderDetailViewController *orderVC = [[CDOrderDetailViewController alloc]init];
            orderVC.orderId = dic[@"orderId"];
            [self.navigationController pushViewController:orderVC animated:YES];
        }else{//订阅服务
            CDSubscribeViewController *subscribeVC = [[CDSubscribeViewController alloc]init];
            [self.navigationController pushViewController:subscribeVC animated:YES];
        }
    }
}




@end
