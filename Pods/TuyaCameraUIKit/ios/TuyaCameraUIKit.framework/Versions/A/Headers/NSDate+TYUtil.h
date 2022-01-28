//
//  NSDate+TYUtil.h
//
//  Created by 傅浪 on 2018/9/22.
//

#import <Foundation/Foundation.h>

@interface NSDate (TYUtil)

/// time string format @"HH:mm:ss" or @"hh:mm:ss a"
+ (NSString *)tysdk_timeStringWithTimeInterval:(NSTimeInterval)timeInterval timeZone:(NSTimeZone *)timeZone;

/// Is the current device in 24-hour format
+ (BOOL)tysdk_is24HourClock;

/// Date at zero o'clock of the day
- (NSDate *)tysdk_dateAtZeroWithTimeZone:(NSTimeZone *)timeZone;

@end
