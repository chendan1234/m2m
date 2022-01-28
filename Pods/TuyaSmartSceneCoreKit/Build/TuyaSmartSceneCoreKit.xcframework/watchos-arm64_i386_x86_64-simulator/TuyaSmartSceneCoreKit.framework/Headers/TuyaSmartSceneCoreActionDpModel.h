//
//  TuyaSmartSceneCoreActionDpModel.h
//  TuyaSmartSceneKit
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com)

#import <Foundation/Foundation.h>
#import <TuyaSmartDeviceCoreKit/TuyaSmartDeviceCoreKit.h>

/// The two types indicate the color of the light.
typedef NS_ENUM(NSUInteger, TuyaSmartSceneCoreColorType) {
    /// This type indicates the brightness value of the lamp.
    TuyaSmartSceneCoreColorBrightNess,
    /// This type indicates the cool and warm values of the lamp.
    TuyaSmartSceneCoreColorTempS
};

/// These step types indicate the adjustment of the data point, e.g. the lamp brightness value is turn on 20%, turn off 20%, fixed value 500.
typedef NS_ENUM(NSInteger, TuyaSmartSceneCoreActionDPStepType) {
    /// The Fixed value type.
    TuyaSmartSceneCoreActionDPStepRegularType = 0,
    /// The turn on type.
    TuyaSmartSceneCoreActionDPStepHighType,
    /// The turn off type.
    TuyaSmartSceneCoreActionDPStepLowType
};

/// This model represents all the information of the action data point, and the user can select the data point to control the device.
@interface TuyaSmartSceneCoreActionDpModel : NSObject

/// The scene id indicate the primary identifier.
@property (nonatomic, assign) NSInteger sceneDPId;
/// The value for current datapoint.
@property (nonatomic, copy) NSString *value;
/// The id for the device's datapoint.
@property (nonatomic, assign) NSInteger dpId;
/// Indicates the datapoint can be edited. The default is NO.
@property (nonatomic, assign) BOOL editable;
/// Indicates that the default value of data point cannot be edited.
@property (nonatomic, copy) NSString *defaultValue;
/// Description of warm and cool and brightness values, eg: bright, light_temp
@property (nonatomic, copy) NSString *valueType;
/// This code describes the general function of the data point, e.g. the brightness value
@property (nonatomic, copy) NSString *dpCode;
/// The model.
@property (nonatomic, copy) NSString *model;
/// The entity id, indicates the device id of the condition and action.
@property (nonatomic, copy) NSString *entityId;
/// The name of this data point
@property (nonatomic, copy) NSString *dpName;
/// The condition type.
@property (nonatomic, assign) NSInteger entityType;
/// The device's iconUrl.
@property (nonatomic, copy) NSString *iconUrl;
/// The device id.
@property (nonatomic, copy) NSString *devId;
/// Range of values for conditional DP or device DP e.g.: (("dry", "dry"), ("comfort", "comfort"), ("wet", "wet"))
@property (nonatomic, strong) NSArray *valueRangeJson;
/// The device property. eg: {"id":1, "desc":"", "name": "switch", "property":{"type": "bool"}, "attr":3, "code": "switch_on", "type": "obj", "mode": "rw"}
@property (nonatomic, strong) NSString *actDetail;
/// The scheme property model.
@property (nonatomic, strong) TuyaSmartSchemaPropertyModel *dpProperty;
/// DP point id of condition or device e.g. "humidity" or "1"
@property (nonatomic, copy) NSString *entitySubId;

#pragma mark - Biz Property

/// The current select index.
@property (nonatomic, assign) NSInteger selectedRow;

/// This method generates the action dp model from the device id and device properties.
/// @param entityId The device id.
/// @param actDic The device properties.eg:{"id":1, "desc":"", "name": "switch", "property":{"type": "bool"}, "attr":3, "code": "switch_on", "type": "obj", "mode": "rw"}
- (TuyaSmartSceneCoreActionDpModel *)modelWithEntityId:(NSString *)entityId
                                                actDic:(NSDictionary *)actDic;

/// This method is used to determine if the percentage data point.
- (BOOL)isPercentDisplayDP;

/// This method returns the light color type.
- (TuyaSmartSceneCoreColorType)colorType;

/// This method returns datapoint display style.
- (SceneDisplayType)displayType;

/// This method converts percentage values to specific values.
- (NSInteger)percentToValue;

/// This method converts specific values to percentage values.
- (NSInteger)valueToPercent;

/// This method returns a specific description of the selected data point value.
- (NSString *)SelectedValueDisplayStr;

/// This method returns the selected value of data point.
- (NSInteger)selectedValue;

/// This method returns the percentage of data point.
- (NSDictionary *)percentDp;

/// The array property contain options that can be turned up.
@property (nonatomic, copy) NSArray *stepHighDpProperty;

/// The array property contain options that can be turned down.
@property (nonatomic, copy) NSArray *stepLowDpProperty;

/// This property describes the type of stepping.
@property (nonatomic, assign) TuyaSmartSceneCoreActionDPStepType selectStepType;

@end

