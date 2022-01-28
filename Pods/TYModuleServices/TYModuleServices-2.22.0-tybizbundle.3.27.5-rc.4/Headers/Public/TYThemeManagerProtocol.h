//
//  TYThemeManagerProtocol.h
//  Pods
//
//  Created by Tuya on 2021/6/10.
//

#import <UIKit/UIKit.h>


#ifndef TYThemeManagerProtocol_h
#define TYThemeManagerProtocol_h

NS_ASSUME_NONNULL_BEGIN

@protocol TYThemeManagerProtocol <NSObject>

/**
 * Typically used as the background color for buttons
 * Default is #FF5A28
 * Can be customized
 */
- (UIColor *)themeColor;

/**
 * Typically used as the background color for warning UI components to strongly
   warn the user and attract the attention of the user
 * Default is #FF4444
 * Can be customized
 */
- (UIColor *)warningColor;

/**
 * Typically used as the background color for suggestive UI components to
   respond to user interactions
 * Default is #00CC99
 * Can be customized
 */
- (UIColor *)tipsColor;

/**
 * Typically used as the background color for guiding UI components to guide
   users how to use
 * Default is #1989FA
 * Can be customized
 */
- (UIColor *)guideColor;

/**
 * The tab bar item selected color
 * Default is #FF5A28
 * Can be customized
 */
- (UIColor *)tabBarSelectedColor;

/**
 * App background color
 * Default is #F8F8F8
 * Can be customized
 */
- (UIColor *)backgroundColor;

/**
 * The background color of navigation bar
 * Default is #FFFFFF
 * Can be customized
 * The value is as it is if customized
 * Otherwise it will be affected while the backgroundColor is configured.
   #FFFFFF if the backgroundColor is light mode，else backgroundColor blend
   with color (#FFFFFF 10% alpha)
 */
- (UIColor *)navigationBarColor;

/**
 * The background color of tab bar
 * Default is #FFFFFF
 * It will be affected while the backgroundColor is configured.
   #FFFFFF if the backgroundColor is light mode，else backgroundColor blend
   with color (#FFFFFF 10% alpha)
 */
- (UIColor *)bottomTabBarBgColor;

/**
 * The background color of card
 * Default is #FFFFFF
 * It will be affected while the backgroundColor is configured.
   #FFFFFF if the backgroundColor is light mode，else backgroundColor blend
   with color (#FFFFFF 10% alpha)
 */
- (UIColor *)cardBgColor;

/**
 * The background color of the content of popup window
 * Default is #FFFFFF
 * It will be affected while the backgroundColor is configured.
   #FFFFFF if the backgroundColor is light mode，else backgroundColor blend
   with color (#FFFFFF 10% alpha)
 */
- (UIColor *)alertBgColor;

/**
 * The background color of the mask for popup window
 * Default is #000000 40%
 * If the alertMaskAlpha is customized, the value equal to
   #000000 alpha=alertMaskAlpha
 * Otherwise, #000000 40% if backgroundColor is light mode else #000000 70%
 */
- (UIColor *)alertMaskColor;

/**
 * The background color of list cell
 * Default is #FFFFFF
 * It will be affected while the backgroundColor is configured.
   #FFFFFF if the backgroundColor is light mode，else backgroundColor blend
   with color (#FFFFFF 10% alpha)
 */
- (UIColor *)listCellBgColor;

/**
 * The color of headLine text
 * Default is #000000
 * The value is #000000 if backgroundColor is light mode
 * Otherwise, the value is #FFFFFF if backgroundColor is same with any one of
   themeColor, warningColor, tipsColor, guideColor, tabBarSelectedColor, else
   #FFFFFF 90%
 */
- (UIColor *)headLineColor;

/**
 * The color of subhead text
 * Default is #000000
 * The value is #000000 if backgroundColor is light mode
 * Otherwise, the value is #FFFFFF if backgroundColor is same with any one of
   themeColor, warningColor, tipsColor, guideColor, tabBarSelectedColor, else
   #FFFFFF 70%
 */
- (UIColor *)subheadColor;

/**
 * The color of auxiLiary text
 * Default is #000000
 * The value is #000000 if backgroundColor is light mode
 * Otherwise, the value is #FFFFFF if backgroundColor is same with any one of
   themeColor, warningColor, tipsColor, guideColor, tabBarSelectedColor, else
   #FFFFFF 50%
 */
- (UIColor *)auxiLiaryColor;

/**
 * The color of disable text
 * Default is #000000
 * The value is #000000 if backgroundColor is light mode
 * Otherwise, the value is #FFFFFF if backgroundColor is same with any one of
   themeColor, warningColor, tipsColor, guideColor, tabBarSelectedColor, else
   #FFFFFF 30%
 */
- (UIColor *)disableColor;

/**
 * The color of text which with themeColor as background color
 * Default is #FFFFFF
 * #000000 if themeColor is light mode else #FFFFFF
 */
- (UIColor *)themeTextColor;

/**
 * The color of text which with warningColor as background color
 * Default is #FFFFFF
 * #000000 if warningColor is light mode else #FFFFFF
 */
- (UIColor *)warningTextColor;

/**
 * The color of text which with tipsColor as background color
 * Default is #FFFFFF
 * #000000 if tipsColor is light mode else #FFFFFF
 */
- (UIColor *)tipsTextColor;

/**
 * The color of text which with guideColor as background color
 * Default is #FFFFFF
 * #000000 if guideColor is light mode else #FFFFFF
 */
- (UIColor *)guideTextColor;

/**
 * The text color of navigationBar
 * Default is #000000
 * The value is #000000 if navigationBarColor is light mode
 * Otherwise, the value is #FFFFFF if navigationBarColor is same with
   any one of themeColor, warningColor, tipsColor, guideColor,
   tabBarSelectedColor, else #FFFFFF 90%
 */
- (UIColor *)navigationBarTextColor;

/**
 * @brief Used to config the themeColor, backgroundColor, warningColor, tipsColor, guideColor, navigationBarColor, tabBarSelectedColor, alertMaskAlpha
 * @param themeColor If nil, the default value won't be changed
 * @param backgroundColor If nil, the default value won't be changed
 * @param warningColor If nil, the default value won't be changed
 * @param tipsColor If nil, the default value won't be changed
 * @param guideColor If nil, the default value won't be changed
 * @param navigationBarColor If nil, the default value won't be changed
 * @param tabBarSelectedColor If nil, the default value won't be changed
 * @param alertMaskAlpha Value range from 0 to 1, include 0 and 1. If nil,
   it will be decided by the themeColor
 * @warning Calling this function as early as possible after set up the Tuya SDK, and before any Tuya SDK UI building Api calling.
 */
- (void)configNormalModuleWithThemeColor:(nullable UIColor *)themeColor backgroundColor:(nullable UIColor *)backgroundColor warningColor:(nullable UIColor *)warningColor tipsColor:(nullable UIColor *)tipsColor guideColor:(nullable UIColor *)guideColor navigationBarColor:(nullable UIColor *)navigationBarColor tabBarSelectedColor:(nullable UIColor *)tabBarSelectedColor alertMaskAlpha:(nullable NSNumber *)alertMaskAlpha NS_SWIFT_NAME(configNormalModule(withThemeColor:backgroundColor:warningColor:tipsColor:guideColor:navigationBarColor:tabBarSelectedColor:alertMaskAlpha:));

@end

NS_ASSUME_NONNULL_END

#endif /* TYThemeManagerProtocol_h */

