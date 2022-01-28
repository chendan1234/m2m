//
//  CDPayView.m
//  Security
//
//  Created by chendan on 2021/8/2.
//

#import "CDPayView.h"
#import "CDCommonDefine.h"
#import "UIView+ProgressView.h"
#import "CDHelper.h"
#import <PGDatePicker/PGDatePickManager.h>


@interface CDPayView ()
@property (weak, nonatomic) IBOutlet UIView *bgV;
@property (weak, nonatomic) IBOutlet UIButton *ovalBtn;
@property (weak, nonatomic) IBOutlet UIButton *wsdBtn;
@property (weak, nonatomic) IBOutlet UIButton *visaBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleMainLab;
@property (weak, nonatomic) IBOutlet UILabel *titleTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UITextField *expTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *cvcTF;
@property (weak, nonatomic) IBOutlet UITextField *postalTF;

@property (weak, nonatomic) IBOutlet UIView *timeBgV;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, strong) UIDatePicker *datePicker;

@end

@implementation CDPayView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"CDPayView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.timeBgV addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(timeBgVClick)]];
}


-(void)timeBgVClick{
    [self endEditing:YES];
    
    PGDatePickManager *datePickManager = [[PGDatePickManager alloc]init];
    PGDatePicker *datePicker = datePickManager.datePicker;
    datePickManager.cancelButtonTextColor = [UIColor lightGrayColor];
    datePickManager.confirmButtonTextColor = [UIColor systemBlueColor];
    datePicker.textColorOfSelectedRow = [UIColor blackColor];
    datePicker.lineBackgroundColor = [UIColor lightGrayColor];
    datePicker.datePickerMode = PGDatePickerModeYearAndMonth;
    datePickManager.isShadeBackground = YES;
    
    datePicker.minimumDate = [NSDate new];
    
    datePicker.selectedDate = ^(NSDateComponents *dateComponents) {
        self.timeLab.textColor = [UIColor blackColor];
        self.timeLab.text = [NSString stringWithFormat:@"%ld年%ld月",dateComponents.year,dateComponents.month];
        self.model.expYear = [[[NSString stringWithFormat:@"%ld",dateComponents.year] substringFromIndex:2] intValue];
        self.model.expMonth = dateComponents.month;
        
    };
    
    [[CDHelper viewControllerWithView:self] presentViewController:datePickManager animated:false completion:nil];
}


- (IBAction)visaBtnClick:(id)sender {
    [self.visaBtn setImage:[UIImage imageNamed:@"visa_selected"] forState:UIControlStateNormal];
    [self.wsdBtn setImage:[UIImage imageNamed:@"wansida"] forState:UIControlStateNormal];
    [self.ovalBtn setImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
}

- (IBAction)wsdBtnClick:(id)sender {
    [self.visaBtn setImage:[UIImage imageNamed:@"visa"] forState:UIControlStateNormal];
    [self.wsdBtn setImage:[UIImage imageNamed:@"wansida_selected"] forState:UIControlStateNormal];
    [self.ovalBtn setImage:[UIImage imageNamed:@"Oval"] forState:UIControlStateNormal];
    
}

- (IBAction)ovalBtnClick:(id)sender {
    [self.visaBtn setImage:[UIImage imageNamed:@"visa"] forState:UIControlStateNormal];
    [self.wsdBtn setImage:[UIImage imageNamed:@"wansida"] forState:UIControlStateNormal];
    [self.ovalBtn setImage:[UIImage imageNamed:@"Oval_selected"] forState:UIControlStateNormal];
}

-(void)setModel:(CDSubscribeModel *)model{
    _model = model;
    self.titleMainLab.text = [NSString stringWithFormat:@"%@*",model.serviceName];
    self.titleTimeLab.text = model.timeStr;
    self.moneyLab.text = [NSString stringWithFormat:@"%ld",model.money/100];
}

- (IBAction)pay:(id)sender {
    
    if (self.numTF.text.length == 0) {
        [[CDHelper viewControllerWithView:self].view pv_warming:@"请输入您的银行卡号!"];
        return;
    }
    
    if (!self.model.expYear) {
        [[CDHelper viewControllerWithView:self].view pv_warming:@"请选择您的银行卡过期时间!"];
        return;
    }
    
    if (self.cvcTF.text.length == 0) {
        [[CDHelper viewControllerWithView:self].view pv_warming:@"请输入CVC码!"];
        return;
    }
    
    if (self.postalTF.text.length == 0) {
        [[CDHelper viewControllerWithView:self].view pv_warming:@"请输入账单地址对应的邮编!"];
        return;
    }
    
    self.model.num = self.numTF.text;
    self.model.cvc = self.cvcTF.text;
    
    
    if (self.payBlock) {
        self.payBlock(self.model);
    }
}









@end
