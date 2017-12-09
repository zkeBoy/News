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

+ (NSString *)getWeatherTypeWithWeather:(NSString *)weather{
    NSString * type;
    if ([weather isEqualToString:@"晴"]){
        type = @"clear";
    }else if ([weather isEqualToString:@"晴转多云"]){
        type = @"clear_to_overcast";
    }else if ([weather isEqualToString:@"晴转阴"]){
        type = @"clear_to_overcast";
    }else if ([weather isEqualToString:@"多云"]){
        type = @"cloudy";
    }else if ([weather isEqualToString:@"多云转晴"]){
        type = @"cloudy_becoming_fine";
    }else if ([weather isEqualToString:@"多云转阴"]){
        type = @"cloudy_to_overcast";
    }else if ([weather isEqualToString:@"阴"]) {
        type = @"shadey";
    }else if ([weather isEqualToString:@"阴转多云"]){
        type = @"cloudy_to_overcast";
    }else if ([weather isEqualToString:@"阴转小雨"]){
        type = @"cloudy_to_rain";
    }else if ([weather isEqualToString:@"阴转小雪"]){
        type = @"little_snow";
    }else if ([weather isEqualToString:@"阴转晴"]){
        type = @"overcast_to_clear";
    }else if ([weather isEqualToString:@"阵雨转小雨"]){
        type = @"cloudy_to_rain";
    }else if ([weather isEqualToString:@"阵雨转晴"]){
        type = @"clear";
    }else if ([weather isEqualToString:@"小雨"]){
        type = @"rain_litter";
    }else if ([weather isEqualToString:@"小雨转阴"]){
        type = @"cloudy_to_rain";
    }
    return type;
}

@end
