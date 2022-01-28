//
//  CDRegisterViewController.m
//  security
//
//  Created by chendan on 2021/5/25.
//

#import "CDRegisterViewController.h"
#import "CDMailRegisterView.h"
#import "CDProtocolViewController.h"




@interface CDRegisterViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleBgV; // 标题背景View
@property(nonatomic,weak)UIView *lineView; //标题下的蓝线
@property(nonatomic,weak)UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong)UIScrollView *scrollV;

@property (nonatomic, strong)NSMutableArray *contentViewArr;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;

@end

@implementation CDRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"注册新用户";
    
    [self setTopView]; //设置顶部标题
    
    [self setContentView]; //设置内容
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:KAgree];
}

#pragma mark 界面操作
//同意按钮点击事件
- (IBAction)agreenBtnClick:(UIButton *)sender {
    if ([sender.imageView.image isEqual:[UIImage imageNamed:@"agree"]]) {
        [sender setImage:[UIImage imageNamed:@"agree_selected"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:KAgree];
    }else{
        [sender setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:KAgree];
    }
}

//用户协议
- (IBAction)protocolBtnClick:(id)sender {
//    ProtocolController *protocolVC = [[ProtocolController alloc]init];
//    [self.navigationController pushViewController:protocolVC animated:YES];
    
    CDProtocolViewController *protocalVC = [[CDProtocolViewController alloc]init];
    [self.navigationController pushViewController:protocalVC animated:YES];
}

//注册
- (IBAction)registerBtnClick:(id)sender {
    CDMailRegisterView *phoneOrEmailV = self.contentViewArr[self.selectedBtn.tag - 100];
    [phoneOrEmailV goToRegister];
}

//已有账号, 立即登录
- (IBAction)goToLoginBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 界面搭建
//设置内容
-(void)setContentView{
    UIScrollView *bgScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDRH - 32, 232)];
    bgScrollV.pagingEnabled = YES;
    bgScrollV.showsHorizontalScrollIndicator = NO;
    bgScrollV.delegate = self;
    self.scrollV = bgScrollV;
    [self.contentView addSubview:bgScrollV];
    
    
    self.contentViewArr = [[NSMutableArray alloc]init];
    CDMailRegisterView *telView = [CDMailRegisterView reload];
    CDMailRegisterView *mailView = [CDMailRegisterView reload];
    [self.contentViewArr addObject:telView];
    [self.contentViewArr addObject:mailView];
    
    for (NSInteger i = 0; i < 2; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*bgScrollV.width, 0, bgScrollV.width, bgScrollV.height)];
        CDMailRegisterView *contentV = self.contentViewArr[i];
        contentV.frame = view.bounds;
        contentV.type = i;
        [view addSubview:contentV];
        [bgScrollV addSubview:view];
    }
    
    bgScrollV.contentSize = CGSizeMake(bgScrollV.width * 2, 0);
}

//设置顶部标题
-(void)setTopView{
    
    UIView *lineView = [[UIView alloc]init];
    lineView.height = 2;
    lineView.y = self.titleBgV.height - lineView.height;
    self.lineView = lineView;
    lineView.backgroundColor = KBlueColor;
    [self.titleBgV addSubview:lineView];
    
    NSArray *titleArr = @[@"手机注册",@"邮箱注册"];
    NSInteger count = titleArr.count;
    CGFloat btnW = (DEVICE_WIDRH - 74) / titleArr.count;
    CGFloat btnH = self.titleBgV.height;
    CGFloat btnY = 0;
    
    
    
    for (int i = 0 ; i < count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * btnW, btnY, btnW, btnH);
        btn.tag = 100 + i;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setTitleColor:KBlueColor forState:UIControlStateDisabled];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [btn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleBgV addSubview:btn];
        
        
        if (i == 0) {
            btn.enabled = NO;
            self.selectedBtn = btn;
            [btn.titleLabel sizeToFit];
            self.lineView.width = 120;
            self.lineView.centerX= btn.centerX;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self navBtnClick:btn];
            });
            
        }
        
    }
}

//标题点击事件
-(void)navBtnClick:(UIButton *)sender{
    
    self.selectedBtn.enabled = YES;
    sender.enabled = NO;
    self.selectedBtn = sender;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.lineView.centerX= sender.centerX;
    }];
    
    CGPoint point = self.scrollV.contentOffset;
    point.x = (sender.tag - 100) * self.scrollV.width;
    [self.scrollV setContentOffset:point animated:YES];
}

//手动滚动scrollview
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self navBtnClick:(UIButton *)[self.titleBgV viewWithTag:index + 100]];
}




//收键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
