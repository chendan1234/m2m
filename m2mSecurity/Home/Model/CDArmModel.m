//
//  CDArmModel.m
//  m2mSecurity
//
//  Created by chendan on 2022/1/18.
//

#import "CDArmModel.h"
#import <TYFoundationKit/TYFoundationKit.h>

@interface CDArmModel ()

@property (nonatomic, strong) TuyaSecurity *homeSecurity;

@end

@implementation CDArmModel

- (TuyaSecurity *)homeSecurity {
    if (!_homeSecurity) {
        _homeSecurity = [[TuyaSecurity alloc] init];
    }
    return _homeSecurity;
}

-(void)saveDevice{
    [self getDevicesInRuleWithMode:TuyaSecurityModeTypeModeStay];
}

#pragma mark --- 获取撤布防设备, 并设置 ---
- (void)getDevicesInRuleWithMode:(TuyaSecurityModeType)mode {
    ty_weakify(self);
    [self.homeSecurity getDevicesInRuleByModeWithHomeId:[CDHelper getHomeId] mode:mode success:^(TuyaSecurityModeSettingDeviceModel * _Nonnull result) {
        ty_strongify(self);
        [self dealDevicesInRule:result typeMode:mode];
    } failure:^(NSError * _Nonnull error) {
        if (self.failBlock) {
            self.failBlock(error.localizedDescription);
        }
    }];
}

- (void)dealDevicesInRule:(TuyaSecurityModeSettingDeviceModel *)model typeMode:(TuyaSecurityModeType)typeMode{
    
    NSMutableArray<TuyaSecurityDeviceRuleModel *> *params = [NSMutableArray new];
    //安防网关设备
    for (TuyaSecurityModeSettingItemModel *itemModel in model.securityGateway) {
        TuyaSecurityDeviceRuleModel *ruleModel = [[TuyaSecurityDeviceRuleModel alloc] init];
        NSMutableArray *deviceIds = [[NSMutableArray alloc] init];
        for (TuyaSecurityModeSettingItemModel *subDeviceModel in itemModel.subDevices) {
            if (subDeviceModel.allowSelect) {
                [deviceIds addObject:subDeviceModel.deviceId];
            }
        }
        ruleModel.deviceIds = deviceIds.copy;
        ruleModel.gatewayId = itemModel.deviceId;
        ruleModel.type = 1;
        [params addObject:ruleModel];
    }
    //虚拟网关设备
    for (TuyaSecurityModeSettingItemModel *itemModel in model.virtualGateway) {
        TuyaSecurityDeviceRuleModel *ruleModel = [[TuyaSecurityDeviceRuleModel alloc] init];
        NSMutableArray *deviceIds = [[NSMutableArray alloc] init];
        for (TuyaSecurityModeSettingItemModel *subDeviceModel in itemModel.subDevices) {
            if (subDeviceModel.allowSelect) {
                [deviceIds addObject:subDeviceModel.deviceId];
            }
        }
        ruleModel.deviceIds = deviceIds.copy;
        ruleModel.gatewayId = itemModel.deviceId;
        ruleModel.type = 2;
        [params addObject:ruleModel];
    }
    //摄像头设备
    for (TuyaSecurityModeSettingItemModel *itemModel in model.ipcDevices) {
        TuyaSecurityDeviceRuleModel *ruleModel = [[TuyaSecurityDeviceRuleModel alloc] init];
        ruleModel.gatewayId = itemModel.deviceId;
        ruleModel.deviceIds = @[];
        ruleModel.type = 3;
        [params addObject:ruleModel];
    }
    
    ty_weakify(self);
    [self.homeSecurity saveDevicesByModeWithHomeId:[CDHelper getHomeId] mode:typeMode data:params success:^(BOOL result) {
        ty_strongify(self);
        if (result) {
            if (typeMode == TuyaSecurityModeTypeModeStay) {
                [self getDevicesInRuleWithMode:TuyaSecurityModeTypeModeAway];
            }else{
                if (self.overBlock) {
                    self.overBlock();
                }
            }
        }
    } failure:^(NSError * _Nonnull error) {
        if (self.failBlock) {
            self.failBlock(error.localizedDescription);
        }
    }];
}

@end
