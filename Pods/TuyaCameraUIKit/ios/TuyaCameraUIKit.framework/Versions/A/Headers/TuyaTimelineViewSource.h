//
//  TuyaTimelineViewSource.h
//
//  Created by 傅浪 on 2018/9/22.
//

#import <Foundation/Foundation.h>

@protocol TuyaTimelineViewSource <NSObject>

/// the time slice start time, seconds of the day
- (NSTimeInterval)startTimeIntervalSinceDate:(NSDate *)date;

/// the time slice end time, seconds of the day
- (NSTimeInterval)stopTimeIntervalSinceDate:(NSDate *)date;

@end
