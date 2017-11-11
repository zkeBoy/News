//
//  ZKWeatherView.h
//  NNews
//
//  Created by Tom on 2017/11/11.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKWeatherModel.h"
@protocol ZKWeatherViewDelegate;

@interface ZKWeatherView : UIView
@property (nonatomic, strong) ZKWeatherModel * model;
@property (nonatomic,   weak) id <ZKWeatherViewDelegate> delegate;
@end

@protocol ZKWeatherViewDelegate
@optional
- (void)didClickLoactionBtn;

@end
