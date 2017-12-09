//
//  ZKWeatherModel.m
//  Youliao
//
//  Created by Tom on 2017/11/30.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKWeatherModel.h"

@implementation ZKWeatherModel
- (NSDictionary *)objectClassInArray{
    return @{@"index": [ZKWeatherDetail class],
             @"weather_data": [ZKWeatherData class]};
}

@end


@implementation ZKWeatherDetail

@end

@implementation ZKWeatherData

@end
