//
//  CDOrderDetailView.m
//  Security
//
//  Created by chendan on 2021/8/4.
//

#import "CDOrderDetailView.h"

@implementation CDOrderDetailView

+(instancetype)reload
{
    return [[[NSBundle mainBundle]loadNibNamed:@"CDOrderDetailView" owner:nil options:nil]lastObject];
}

@end
