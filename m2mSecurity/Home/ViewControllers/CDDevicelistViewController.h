//
//  CDDevicelistViewController.h
//  Security
//
//  Created by chendan on 2021/7/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CDDevicelistViewController : UIViewController

@property (nonatomic, assign)NSInteger type;//1.全部设备 2.共享设备

-(void)exchangeLayout:(BOOL)isTableView;

-(void)setupHomeDevice;

@property (nonatomic, copy) void(^stateBlock)(void);


@end

NS_ASSUME_NONNULL_END
