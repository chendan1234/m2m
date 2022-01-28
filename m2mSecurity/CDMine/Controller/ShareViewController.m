//
//  ShareViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/19.
//

#import "ShareViewController.h"
#import "ShareSubViewController.h"
#import "SelectShareViewController.h"


@interface ShareViewController ()<UIScrollViewDelegate>
@property(nonatomic,weak)UIView *topView;
@property(nonatomic,weak)UIView *lineView;
@property(nonatomic,weak)UIScrollView *scrollV;
@property(nonatomic,weak)UIButton *selectedBtn;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"设备共享";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selecteDevice)];
    
    [self setTopView];
    
    [self setChildrenVC];
    
    [self setContentView];
}

-(void)selecteDevice{
    SelectShareViewController *shareVC = [[SelectShareViewController alloc]init];
    [self.navigationController pushViewController:shareVC animated:YES];
}

-(void)setTopView{
    UIView *bgV = [[UIView alloc]initWithFrame:CGRectMake(0, getRectNavAndStatusHight, DEVICE_WIDRH, 45)];
    self.topView = bgV;
    [self.view addSubview:bgV];
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.height = 3;
    lineView.y = 42;
    self.lineView = lineView;
    lineView.backgroundColor = KColorA(72, 144, 223, 1);
    [bgV addSubview:lineView];
    
    
    NSArray *titleArr = @[@"我的设备",@"我的共享",@"共享消息"];
    NSInteger count = titleArr.count;
    CGFloat btnW = (DEVICE_WIDRH / titleArr.count);
    CGFloat btnH = bgV.height;
    CGFloat btnY = 0;
    for (int i = 0 ; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnW, btnY, btnW, btnH);
        btn.tag = 100 + i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:KColorA(72, 144, 223, 1) forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
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
    CGFloat Y = getRectNavAndStatusHight + 45;
    CGFloat H = DEVICE_HEIGHT - Y;
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, Y, DEVICE_WIDRH, H)];
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
    
    ShareSubViewController *myDeviceVC = [[ShareSubViewController alloc]init];
    myDeviceVC.type = 1;
    
    ShareSubViewController *myShareVC = [[ShareSubViewController alloc]init];
    myShareVC.type = 2;
    
    ShareSubViewController *shareNotiVC = [[ShareSubViewController alloc]init];
    shareNotiVC.type = 3;
    
    [self addChildViewController:myDeviceVC];
    [self addChildViewController:myShareVC];
    [self addChildViewController:shareNotiVC];
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
