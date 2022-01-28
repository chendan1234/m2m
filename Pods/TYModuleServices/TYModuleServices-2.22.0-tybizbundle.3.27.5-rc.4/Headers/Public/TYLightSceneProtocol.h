//
//  TYLightSceneProtocol.h
//  TYLightModuleServices
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TuyaLightSceneModel;

@protocol TYLightSceneProtocol <NSObject>

/// 添加新场景
- (void)createNewLightScene;

/// 编辑场景
/// @param scene 灯光场景模型
- (void)editLightScene:(TuyaLightSceneModel *)scene;

@end

NS_ASSUME_NONNULL_END
