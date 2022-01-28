//
//  TYGroupHandleProtocol.h
//  TYGroupHandleModule
//
//  Created by 黄凯 on 2018/8/22.
//

#ifndef TYGroupHandleProtocol_h
#define TYGroupHandleProtocol_h

typedef enum {
  TYGroupHandleTypeSupport,
  TYGroupHandleTypeNotSupport,
  TYGroupHandleTypeInvalid,
} TYGroupHandleType;

/**
 zh^
 描述了各种方式进行群组页面的跳转
 zh$
 
 en^
 Describes various ways to jump to a group page
 en$
 */
@protocol TYGroupHandleProtocol

/**
 
 zh^
 跳转到蓝牙本地群组入口

 参数 isNav : `YES` 将会把 vc 装到 naviagtorVC 再进行 present, `NO` 直接present

 zh$
 
 en^
 Page jump to Bluetooth group
 
 param  isNav: `YES` the vc will be presented inside a naviagtorVC, `NO` present a normal view controller

 en$
 
 @param query zh^ 初始数据 zh$ en^ init data en$
 @param isNav zh^ 是否以 navigator 的方式进行present zh$ en^ if present by navigator en$ ，
 */
- (void)presentMeshLocalGroupWithQueryData:(NSDictionary *)query
                                     isNav:(BOOL)isNav ;

/**
 
 zh^
 创建wifi标准或普通群组
 zh$
 
 en^
 Create wifi standard or common group
 en$
 
 @param deviceId zh^ 设备ID zh$ en^ device ID en$
 @param completion zh^ 回调 zh$ en^ call back en$
 */
- (void)createWifiGroupWithDeviceId:(NSString *_Nonnull)deviceId completion:(void (^ _Nullable)(TYGroupHandleType type))completion;

/**
 
 zh^
 编辑WIFI标准或普通群组
 zh$
 
 en^
 Edit wifi standard or common group
 en$
 
 @param groupId zh^ 群组ID zh$ en^ group ID en$
 @param completion zh^ 回调 zh$ en^ call back en$
 */
- (void)editWifiGroupWithGroupId:(NSString *_Nonnull)groupId completion:(void (^ _Nullable)(TYGroupHandleType type))completion;

@end

#endif /* TYGroupHandleProtocol_h */
