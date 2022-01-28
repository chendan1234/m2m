
//
//  NavigationViewController.m
//  zhenxuanyouping
//
//  Created by apple on 1/4/2019.
//  Copyright © 2019 华博金创. All rights reserved.
//

#import "NavigationViewController.h"

@interface NavigationViewController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@end

@implementation NavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加这一句代码,能保留系统滑动退回的效果
    self.interactivePopGestureRecognizer.delegate = nil;
    
    __weak NavigationViewController *weakSelf = self;
    
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
        
        self.delegate = weakSelf;
    }
}

+ (void)initialize
{
    //拿到全局的bar,统一设置
    UINavigationBar *bar = [UINavigationBar appearance];
    
//    bar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor darkGrayColor]};
    [bar setShadowImage:[[UIImage alloc]init]];
    bar.barTintColor = [UIColor whiteColor];
}

//拦截系统的push方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (self.childViewControllers.count > 0) {//如果push进来的不是第一个控制器,则放一个返回按钮,隐藏tabbar
        
        //放一个返回按钮
        UIButton *backBtn = [[UIButton alloc]init];
        
        [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
//        [backBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
//        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
//        backBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        backBtn.titleLabel.textColor = [UIColor redColor];
       
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        backBtn.size = CGSizeMake(70, 30);
        backBtn.adjustsImageWhenHighlighted = NO;
        [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
        
        //隐藏tabbar
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];
}

//返回
-(void)back
{
    [self popViewControllerAnimated:YES];
}



- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    if ( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] && animated == YES )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return  [super popToRootViewControllerAnimated:animated];
    
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if( [self respondsToSelector:@selector(interactivePopGestureRecognizer)] )
    {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
    
    return [super popToViewController:viewController animated:animated];
    
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animate
{
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}


-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    if ( gestureRecognizer == self.interactivePopGestureRecognizer )
    {
        if ( self.viewControllers.count < 2 || self.visibleViewController == [self.viewControllers objectAtIndex:0] )
        {
            return NO;
        }
    }
    
    return YES;
}




@end
