//
//  ZKWeatherItem.h
//  Youliao
//
//  Created by Tom on 2017/11/30.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKWeatherModel.h"

@interface ZKWeatherItem : UIView

+ (ZKWeatherItem *)initWithWeatherModel:(ZKWeatherData *)model toView:(UIView *)view frame:(CGRect)frame;

@end
