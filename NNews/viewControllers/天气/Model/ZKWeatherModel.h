//
//  ZKWeatherModel.h
//  NNews
//
//  Created by Tom on 2017/11/11.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKDayModel.h"

@interface ZKWeatherModel : NSObject
@property (nonatomic, copy)   NSString * cityName;
@property (nonatomic, copy)   NSString * updateTime;
@property (nonatomic, strong) NSArray <ZKDayModel *>* dayArrays; //这几天的天气情况
@property (nonatomic, copy)   NSString * timeZone;
@end
