//
//  TuyaSmartSceneCoreFeatureModel.h
//  TuyaSmartSceneKit
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>
#import "TuyaSmartSceneCoreActionDpModel.h"

/// The two expression type in function. Provide single and group types.
typedef NS_ENUM(NSUInteger, TuyaSmartSceneCoreFunctionType) {
    /// The single type
    TuyaSmartSceneCoreFunctionSingleType = 0,
    /// The group type
    TuyaSmartSceneCoreFunctionGroupType,
};

/// This string means function code is "white_light"
static NSString *const TuyaSmartSceneCoreFunctionCodeWhite = @"white_light";
/// This string means function code is "color_light"
static NSString *const TuyaSmartSceneCoreFunctionCodeColor = @"color_light";

/// This model represents all information of Feature, including data points list.
@interface TuyaSmartSceneCoreFeatureModel : NSObject

/// The device Id
@property (nonatomic, strong) NSString *devId;
/// The hsv color values
@property (nonatomic, strong) NSArray *hsvColor;
/// The rgb color values
@property (nonatomic, strong) NSString *rgbColor;
/// The feature id
@property (nonatomic, strong) NSString *featureId;
/// The productId
@property (nonatomic, strong) NSString *productId;
/// The light color 
@property (nonatomic, strong) NSString *lightColor;
/// The function name
@property (nonatomic, strong) NSString *functionName;
/// The function code
@property (nonatomic, strong) NSString *functionCode;
/// The function type
@property (nonatomic, assign) TuyaSmartSceneCoreFunctionType functionType;
/// Data point list
@property (nonatomic, strong) NSArray<TuyaSmartSceneCoreActionDpModel *> *dataPoints;
/// The light data point
@property (nonatomic, strong) TuyaSmartSceneCoreActionDpModel *brightModel;

/// Set the value of hsv
///
/// @param h Hue. the value range 0-1
/// @param s Saturation. the value range 0-1
/// @param v Value. the value range 0-1
- (void)setH:(CGFloat)h s:(CGFloat)s v:(CGFloat)v;

/// Whether functionCode is "white_light" or "color_light"
- (BOOL)isColorSelectType;

/// Get the brightness data point model
///
/// @return TuyaSmartSceneCoreActionDpModel object.
- (TuyaSmartSceneCoreActionDpModel *)getBrightnessDpModel;

@end

