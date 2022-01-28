//
//  NewFeatureViewController.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/20.
//

#import "NewFeatureViewController.h"
#import "CDLoginViewController.h"
#import "NewFeatureView.h"
#import "NewFeatureModel.h"

@interface NewFeatureViewController ()

@property (nonatomic, strong)NSMutableArray *dataArr;

@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self setupContentView];
    
    
    [self getData];
}

-(void)getData{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [HttpRequest HR_AppNewestAppSettingWithParams:dic success:^(id result) {
        NSLog(@"---%@",result);
        if ([result[@"code"] intValue] == 200) {
            self.dataArr = [NewFeatureModel mj_objectArrayWithKeyValuesArray:[CDHelper jsonToDic:result[@"data"][@"content"]]];
            [self setupScrollV];
            
        }
        [CDHelper jsonToDic:result[@"data"][@"content"]];
    } failure:^(NSError *error) {
        [self goToLogin];
    }];
}

-(void)setupContentView{
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDRH, DEVICE_HEIGHT)];
    NSArray *images = @[@"guide01",@"guide02",@"guide03"];
    
    for (NSInteger i = 0; i < images.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i*DEVICE_WIDRH, 0, DEVICE_WIDRH, DEVICE_HEIGHT)];
        imageV.image = [UIImage imageNamed:images[i]];
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [scrollV addSubview:imageV];
        
        if (i == images.count - 1) {
            UIButton *useBtn = [[UIButton alloc]initWithFrame:CGRectMake(i * DEVICE_WIDRH + 40, DEVICE_HEIGHT*0.85, DEVICE_WIDRH - 80, 50)];
            useBtn.backgroundColor = [CDHelper getColor:@"007AFF"];
            [useBtn setTitle:@"立即体验" forState:UIControlStateNormal];
            [useBtn addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
            useBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [scrollV addSubview:useBtn];
        }
    }
    scrollV.contentSize = CGSizeMake(images.count * DEVICE_WIDRH, 0);
    scrollV.pagingEnabled = YES;
    scrollV.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollV];
}

-(void)setupScrollV{
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDRH, DEVICE_HEIGHT)];
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        NewFeatureView *featureV = [NewFeatureView reload];
        featureV.frame = CGRectMake(i*DEVICE_WIDRH, 0, DEVICE_WIDRH, DEVICE_HEIGHT);
        featureV.model = self.dataArr[i];
        [scrollV addSubview:featureV];
        if (i == self.dataArr.count - 1) {
            featureV.tiYanBtn.hidden = NO;
            [featureV.tiYanBtn addTarget:self action:@selector(goToLogin) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    scrollV.contentSize = CGSizeMake(self.dataArr.count * DEVICE_WIDRH, 0);
    scrollV.pagingEnabled = YES;
    scrollV.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollV];
}

-(void)goToLogin{
    [[NSUserDefaults standardUserDefaults] setObject:@"noFirst" forKey:KNewFeature];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[CDLoginViewController alloc]init]];
}


@end
