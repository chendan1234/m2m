//
//  DeviceDetailTopView.m
//  m2mSecurity
//
//  Created by chendan on 2021/8/27.
//

#import "DeviceDetailTopView.h"

@interface DeviceDetailTopView()

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation DeviceDetailTopView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"DeviceDetailTopView" owner:nil options:nil]lastObject];
}

-(void)setDay:(NSInteger)day{
    _day = day;
    
    switch (day) {
        case 1:
            self.timeLab.text = @"过去24小时";
            break;
        case 2:
            self.timeLab.text = @"过去48小时";
            break;
        case 7:
            self.timeLab.text = @"过去7天";
            break;
            
        default:
            break;
    }
}

@end
