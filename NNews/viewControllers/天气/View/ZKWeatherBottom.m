//
//  ZKWeatherBottom.m
//  Youliao
//
//  Created by Tom on 2017/11/30.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKWeatherBottom.h"
#import "ZKWeatherItem.h"

#define I_W D_WIDTH/3

@implementation ZKWeatherBottom

- (void)setWeatherModel:(ZKWeatherModel *)weatherModel {
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    
    NSArray * items = [weatherModel.weather_data subarrayWithRange:NSMakeRange(1, weatherModel.weather_data.count-1)];
    NSInteger idx = 0;
    for (ZKWeatherData * data in items) {
        CGRect frame = CGRectMake(idx*I_W, 0, I_W, CGRectGetHeight(self.frame));
        ZKWeatherData * model = [ZKWeatherData mj_objectWithKeyValues:data];
        [ZKWeatherItem initWithWeatherModel:model toView:self frame:frame];
        idx++;
    }
}

- (void)dealloc {
    NSLog(@"ZKWeatherBottom dealloc !!!!!!");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
