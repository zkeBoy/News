//
//  ZKDayModel.h
//  NNews
//
//  Created by Tom on 2017/11/11.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 "code_day" = 0;
 "code_night" = 1;
 date = "2017-11-11";
 high = 18;
 low = 7;
 precip = "";
 "text_day" = "\U6674";
 "text_night" = "\U6674";
 "wind_direction" = "\U65e0\U6301\U7eed\U98ce\U5411";
 "wind_direction_degree" = "";
 "wind_scale" = 2;
 "wind_speed" = 10;
 */

@interface ZKDayModel : NSObject
@property (nonatomic, copy) NSString * codeDay;
@property (nonatomic, copy) NSString * codeNight;
@property (nonatomic, copy) NSString * date;
@property (nonatomic, copy) NSString * high;
@property (nonatomic, copy) NSString * low;
@property (nonatomic, copy) NSString * precip;
@property (nonatomic, copy) NSString * text_day;
@property (nonatomic, copy) NSString * text_night;
@property (nonatomic, copy) NSString * wind_direction;
@property (nonatomic, copy) NSString * wind_direction_degree;
@property (nonatomic, copy) NSString * wind_scale;
@property (nonatomic, copy) NSString * wind_speed;
@end
