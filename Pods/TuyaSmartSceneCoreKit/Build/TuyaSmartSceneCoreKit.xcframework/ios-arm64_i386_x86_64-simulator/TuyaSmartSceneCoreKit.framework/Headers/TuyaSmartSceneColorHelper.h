//
//  TuyaSmartSceneColorHelper.h
//  TuYaSmartSceneCoreKit
//
//  Created by Lucca on 2018/12/9.
//

#import <Foundation/Foundation.h>

/// This is a tool class to handle color-related conversions.
@interface TuyaSmartSceneColorHelper : NSObject

/// The method generate 14-bit RRGGBBHHHHSSVV protocol values base on RGB, hue, saturation and brightness.
/// @param r The red vaue, the value range 0-255.
/// @param g The green vaue, the value range 0-255.
/// @param b The vlue vaue, the value range 0-255.
/// @param hh The hue value.
/// @param hl The converted hue values.
/// @param ss The saturation value.
/// @param vv The brightness value.
///
/// @return The 14-bit RRGGBBHHHHSSVV protocol values.
+ (NSString *)rgbhlsvWithR:(NSInteger)r
                         g:(NSInteger)g
                         b:(NSInteger)b
                        hh:(NSInteger)hh
                        hl:(NSInteger)hl
                        ss:(NSInteger)ss
                        vv:(NSInteger)vv;

/// The method generate 12-bit HHHHSSSSSSVVVV protocol values base on hue, saturation and brightness.
/// @param h The Hue value, the value range 0-360.
/// @param s The Saturation value, the value range 0-100.
/// @param v The Brightness value, the value range 0-100.
///
/// @return The 12-bit HHHHSSSSSSVVVV protocol values.
+ (NSString *)encodeNewHsvWithH:(NSInteger)h s:(NSInteger)s v:(NSInteger)v;

/// This method converts the hexadecimal RGB color values into an array of HSV colors with the data hue, saturation, and value.
/// @param rgb The hexadecimal RGB value.
///
/// @return The HSV colors array with the data hue, saturation, and value. eg: @[@h, @s, @v].
+ (NSArray *)hsvWithRgb:(NSString *)rgb;

#pragma mark - Bright & Temp

/// This method converts the bright and temp values into hexadecimal RGB color values.
/// @param bright The bright value.
/// @param temp The temp value.
///
/// @return The hexadecimal RGB values.
+ (NSString *)rgbWithBright:(NSInteger)bright temp:(NSInteger)temp;

/// This method converts the brightness and warm and cold values into UIColor objects.
/// @param bright The bright value.
/// @param temp The temp value.
///
/// @return The UIColor object.
+ (UIColor *)hsvColorWithBright:(NSInteger)bright temp:(NSInteger)temp;

/// This method converts the bright and temp values into an HSV color array with the data hue, saturation, and value.
/// @param bright The bright value.
/// @param temp The temp vaue.
///
/// @return The HSV colors array with the data hue, saturation, and value. eg: @[@h, @s, @v].
+ (NSArray *)hsvWithBright:(NSInteger)bright temp:(NSInteger)temp;

#pragma mark - RGB Helper

/// This method converts the hexadecimal RGB color values to UIColor objects
/// @param color The hexadecimal RGB color values.
///
/// @return The UIColor object.
+ (UIColor *)colorWithHexString:(NSString *)color;

/// The method generate a hexadecimal color value of type string.
/// @param red The red value, the value range 0-255.
/// @param green The green value, the value range 0-255.
/// @param blue The blue value, the value range 0-255.
///
/// @return The hexadecimal RGB values.
+ (NSString *)rgbHexWithRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;

/// The method generate a hexadecimal color value of type string.
/// @param red The red value, the value range 0-255.
/// @param green The green value, the value range 0-255.
/// @param blue The blue value, the value range 0-255.
/// @param alpha The alpha value, the value range 0-1.
///
/// @return The hexadecimal RGB values.
+ (NSString *)rgbHexWithRed:(NSInteger)red
                      green:(NSInteger)green
                       blue:(NSInteger)blue
                      alpha:(NSInteger)alpha;

@end

