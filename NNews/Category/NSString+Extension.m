//
//  NSString+Extension.m
//  NNews
//
//  Created by Tom on 2017/11/3.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
+ (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration{
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    dMin = dMin<0?0:dMin;
    dSec = dSec<0?0:dSec;
    cMin = cMin<0?0:cMin;
    cSec = cSec<0?0:cSec;
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", (long)dMin, (long)dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", (long)cMin, (long)cSec];
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

+ (NSString *)stringWithTemperatureString:(NSString *)high low:(NSString *)low{
    return [NSString stringWithFormat:@"%@℃/%@℃",high,low];
}

@end
