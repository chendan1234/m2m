//
//  CDSubscribeModel.m
//  Security
//
//  Created by chendan on 2021/8/2.
//

#import "CDSubscribeModel.h"

@implementation CDSubscribeModel

-(void)setServiceDay:(NSInteger)serviceDay{
    
    _serviceDay = serviceDay;
    
    NSInteger year = serviceDay / 365;
    NSInteger last = serviceDay % 365;
    NSInteger month = last / 30;
    
    NSString *yearStr = @"";
    if (year) {
        yearStr = [NSString stringWithFormat:@"%ld年",year];
    }
    
    NSString *monthStr = @"";
    if (month) {
        monthStr = [NSString stringWithFormat:@"%ld个月",month];
    }
    
    self.timeStr = [NSString stringWithFormat:@"%@%@",yearStr,monthStr];
}


@end
