//
//  CDOrderViewController.m
//  Security
//
//  Created by chendan on 2021/7/28.
//

#import "CDOrderViewController.h"
#import "CDCommonDefine.h"
#import "CDOrderSubViewController.h"
#import "UIView+DSExtension.h"



@interface CDOrderViewController ()<UIScrollViewDelegate>

@property(nonatomic,weak)UIView *lineView;

@property(nonatomic,weak)UIView *topView;

@property(nonatomic,weak)UIScrollView *scrollV;

@property(nonatomic,weak)UIButton *selectedBtn;


@end

@implementation CDOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"我的订单";
    
    [self setTopView];
    [self setChildrenVC];
    [self setContentView];
}

-(void)setTopView{
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, DEVICE_WIDRH, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    self.topView = topView;
    [self.view addSubview:topView];
    
    UIView *bgV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDRH, topView.height)];
    bgV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [topView addSubview:bgV];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.height = 2;
    lineView.y = bgV.height - lineView.height;
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor blackColor];
    [bgV addSubview:lineView];
    
    
    NSArray *titleArr = @[@"全部",@"待付款",@"服务中",@"已过期",@"其他"];
    NSInteger count = titleArr.count;
    CGFloat btnW = bgV.width / count;
    CGFloat btnH = bgV.height;
    CGFloat btnY = 0;
    for (int i = 0 ; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnW, btnY, btnW, btnH);
        btn.tag = 100 + i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgV addSubview:btn];
        
        if (i == 0) {
            btn.enabled = NO;
            self.selectedBtn = btn;
            [btn.titleLabel sizeToFit];
            self.lineView.width = btn.titleLabel.width;
            self.lineView.centerX= btn.centerX;
        }
    }
}

-(void)navBtnClick:(UIButton *)sender{
    
    self.selectedBtn.enabled = YES;
    sender.enabled = NO;
    self.selectedBtn = sender;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.width = sender.titleLabel.width;
        self.lineView.centerX= sender.centerX;
    }];
    
    CGPoint point = self.scrollV.contentOffset;
    point.x = (sender.tag - 100) * self.scrollV.width;
    [self.scrollV setContentOffset:point animated:YES];
}


-(void)setContentView{
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDRH, 0)];
    scrollV.y = CGRectGetMaxY(self.topView.frame)+1;
    scrollV.height = DEVICE_HEIGHT - scrollV.y;
    scrollV.contentSize = CGSizeMake(self.childViewControllers.count * scrollV.width, 0);
    scrollV.pagingEnabled = YES;
    scrollV.bounces = NO;
    scrollV.delegate = self;
    scrollV.showsHorizontalScrollIndicator = NO;
    self.scrollV = scrollV;
    
    [self.view addSubview:scrollV];
    [self scrollViewDidEndScrollingAnimation:self.scrollV];
    [self.scrollV.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

-(void)setChildrenVC{
    
    CDOrderSubViewController *allVC = [[CDOrderSubViewController alloc]init];
    allVC.type = 0;
    
    CDOrderSubViewController *noPayVC = [[CDOrderSubViewController alloc]init];
    noPayVC.type = 1;
    
    CDOrderSubViewController *ingVC = [[CDOrderSubViewController alloc]init];
    ingVC.type = 2;
    
    CDOrderSubViewController *overVC = [[CDOrderSubViewController alloc]init];
    overVC.type = 5;
    
    CDOrderSubViewController *otherVC = [[CDOrderSubViewController alloc]init];
    otherVC.type = 8;
    
    
    
    [self addChildViewController:allVC];
    [self addChildViewController:noPayVC];
    [self addChildViewController:ingVC];
    [self addChildViewController:overVC];
    [self addChildViewController:otherVC];
    
    
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = index * scrollView.width;
    vc.view.width = scrollView.width;
    vc.view.height = scrollView.height;
    [self.scrollV addSubview:vc.view];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self navBtnClick:(UIButton *)[self.topView viewWithTag:index + 100]];
}




@end
