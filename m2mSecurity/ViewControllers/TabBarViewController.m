//
//  TabBarViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/16.
//

#import "TabBarViewController.h"
#import "NavigationViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "HelpViewController.h"
#import "CDMineViewController.h"

#import "UITabBar+CustomBadge.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加子控制器
    [self addChildVCs];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(haveNoti:) name:KHaveNoti object:nil];
    
}

-(void)haveNoti:(NSNotification *)noti{
    NSInteger num = [noti.object intValue];
    if (num) {
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNumber value:[noti.object intValue] atIndex:1];
    }else{
        [self.tabBar setBadgeStyle:kCustomBadgeStyleNone value:[noti.object intValue] atIndex:1];
    }
    
}

-(void)addChildVCs
{
    //2.设置item的字体
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];

    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    selectedAttrs[NSForegroundColorAttributeName] = KColorA(34,144,245,1);

    //设置统一样式
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];

    self.tabBar.tintColor = KColorA(120,120,120,1);
    
    //添加每一个子控制器
    [self addChildVC:[[HomeViewController alloc]init] title:@"首页" image:@"home" selectedImage:@"home_se"];
    [self addChildVC:[[MessageViewController alloc]init] title:@"消息" image:@"message" selectedImage:@"message_se"];
    [self addChildVC:[[HelpViewController alloc]init] title:@"帮助" image:@"help" selectedImage:@"help_se"];
    [self addChildVC:[[CDMineViewController alloc]init] title:@"我的" image:@"mine" selectedImage:@"mine_se"];
    
}

-(void)addChildVC:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    NavigationViewController *nav = [[NavigationViewController alloc]initWithRootViewController:vc];
    nav.tabBarItem.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:image];
    nav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    
    [self addChildViewController:nav];
}



@end
