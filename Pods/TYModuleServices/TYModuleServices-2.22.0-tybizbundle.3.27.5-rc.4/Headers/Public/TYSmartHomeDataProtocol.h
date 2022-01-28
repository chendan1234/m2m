//
//  TYSmartHomeDataProtocol.h
//  TYModuleServices
//
//  Created by Lucca on 2019/2/26.
//

#import <Foundation/Foundation.h>

@class TuyaSmartHome;

@protocol TYSmartHomeDataProtocol <NSObject>

/**
 get current home; return nil if there is no home
 
 @return TuyaSmartHome
 */
- (TuyaSmartHome *)getCurrentHome DEPRECATED_MSG_ATTRIBUTE("TYSmartHomeDataProtocol is deprecated, use `currentFamilyId` in `TYFamilyProtocol` instead");

@end

