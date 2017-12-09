//
//  ZKWeatherModel.h
//  Youliao
//
//  Created by Tom on 2017/11/30.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZKWeatherDetail;
@class ZKWeatherData;

@interface ZKWeatherModel : NSObject
@property (nonatomic, copy) NSString *currentCity; // 当前城市
@property (nonatomic, copy) NSString *date; // 当前日期
@property (nonatomic, copy) NSString *pm25; // pm25
@property (nonatomic, strong) NSArray *index; // 细节信息
@property (nonatomic, strong) NSArray *weather_data; // 天气详情

@end

// 细节信息
@interface ZKWeatherDetail : NSObject
@property (nonatomic, copy) NSString *title; //标题
@property (nonatomic, copy) NSString *zs;    // 内容
@property (nonatomic, copy) NSString *tipt;  // 指数
@property (nonatomic, copy) NSString *des;   // 细节

@end

// 天气详情
@interface ZKWeatherData : NSObject
@property (nonatomic, copy) NSString *date; // 日期
@property (nonatomic, copy) NSString *weather; // 天气
@property (nonatomic, copy) NSString *wind; // 风力
@property (nonatomic, copy) NSString *temperature; // 温度
@property (nonatomic, copy) NSString *dayPictureUrl;
@property (nonatomic, copy) NSString *nightPictureUrl;
@end
