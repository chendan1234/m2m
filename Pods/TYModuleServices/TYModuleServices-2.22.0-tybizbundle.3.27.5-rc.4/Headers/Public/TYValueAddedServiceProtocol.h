//
//  TYValueAddedServiceProtocol.h
//  TYModuleServices
//
//  Created by TuyaInc on 2019/5/28.
//

#ifndef TYValueAddedServiceProtocol_h
#define TYValueAddedServiceProtocol_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TYValueAddedServiceProtocol <NSObject>

@optional

typedef void (^failureBlock)(NSError *error);

typedef void (^successBoolBlock)(BOOL result);

/**
 * jump to Amazon link home page
 * @params success callback
 * @params failure callback
 */
- (void)goToAmazonAlexaLinkViewControllerSuccess:(successBoolBlock)success
                                         failure:(failureBlock)failure;

/**
 * jump to Google link home page
 * @params success callback
 * @params failure callback
 */
- (void)goToGoogleAssitantLinkViewControllerSuccess:(successBoolBlock)success
                                            failure:(failureBlock)failure;

/// Call it inside method application:continueUserActivity:restorationHandler: in Appdelegate.m
- (BOOL)ty_application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^ __nonnull)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler API_AVAILABLE(ios(8.0));

@end


#endif /* TYValueAddedServiceProtocol_h */
