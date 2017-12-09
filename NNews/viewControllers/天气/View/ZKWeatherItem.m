//
//  ZKWeatherItem.m
//  Youliao
//
//  Created by Tom on 2017/11/30.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKWeatherItem.h"

@interface ZKWeatherItem ()
@property (nonatomic, strong) UILabel * date;
@property (nonatomic, strong) UIImageView * weatherIcon;
@property (nonatomic, strong) UILabel * tempture;
@property (nonatomic, strong) UILabel * weatherStatus;
@property (nonatomic, strong) UILabel * wind;
@property (nonatomic, strong) ZKWeatherData * model;
@end

@implementation ZKWeatherItem

+ (ZKWeatherItem *)initWithWeatherModel:(ZKWeatherData *)model toView:(UIView *)view frame:(CGRect)frame{
    ZKWeatherItem * item = [[ZKWeatherItem alloc] init];
    item.frame = frame;
    [item setUI];
    item.model = model;
    [view addSubview:item];
    return item;
}

- (void)setModel:(ZKWeatherData *)model {
    _model = model;
    
    self.date.text = model.date;
    self.tempture.text = model.temperature;
    self.weatherStatus.text = model.weather;
    self.wind.text = model.wind;
    
    [self setWeatherImgWithWeather:model.weather];
}

- (void)setUI {
    [self addSubview:self.date];
    [self addSubview:self.weatherIcon];
    [self addSubview:self.tempture];
    [self addSubview:self.weatherStatus];
    [self addSubview:self.wind];
}

- (void)layoutSubviews {
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(Margin+10);
        make.width.height.equalTo(self.date);
    }];
    
    [self.weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(50);
        make.top.equalTo(self.date.mas_bottom).offset(Margin);
    }];
    
    [self.tempture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.equalTo(self.tempture);
        make.top.equalTo(self.weatherIcon.mas_bottom).offset(Margin*2);
    }];
    
    [self.weatherStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(self.weatherStatus);
        make.top.equalTo(self.tempture.mas_bottom).offset(Margin);
    }];
    
    [self.wind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(self.wind);
        make.top.equalTo(self.weatherStatus.mas_bottom).offset(Margin);
    }];
}

- (void)setWeatherImgWithWeather:(NSString *)weather {
    NSString * weaName = [NSString getWeatherTypeWithWeather:weather];
    UIImage * image = [UIImage imageNamed:weaName];
    self.weatherIcon.image = image;
}


#pragma mark - lazy init
- (UILabel *)date {
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.backgroundColor =[UIColor clearColor];
        _date.textColor = [UIColor whiteColor];
        _date.textAlignment = NSTextAlignmentCenter;
        _date.font = [UIFont systemFontOfSize:14];
    }
    return _date;
}

- (UIImageView *)weatherIcon {
    if (!_weatherIcon) {
        _weatherIcon = [[UIImageView alloc] init];
        _weatherIcon.backgroundColor = [UIColor clearColor];
    }
    return _weatherIcon;
}

- (UILabel *)tempture {
    if (!_tempture) {
        _tempture = [[UILabel alloc] init];
        _tempture.backgroundColor =[UIColor clearColor];
        _tempture.textColor = [UIColor whiteColor];
        _tempture.textAlignment = NSTextAlignmentCenter;
        _tempture.font = [UIFont boldSystemFontOfSize:20];
    }
    return _tempture;
}

- (UILabel *)weatherStatus {
    if (!_weatherStatus) {
        _weatherStatus = [[UILabel alloc] init];
        _weatherStatus.backgroundColor =[UIColor clearColor];
        _weatherStatus.textColor = [UIColor whiteColor];
        _weatherStatus.textAlignment = NSTextAlignmentCenter;
        _weatherStatus.font = [UIFont systemFontOfSize:14];
    }
    return _weatherStatus;
}

- (UILabel *)wind {
    if (!_wind) {
        _wind = [[UILabel alloc] init];
        _wind = [[UILabel alloc] init];
        _wind.backgroundColor =[UIColor clearColor];
        _wind.textColor = [UIColor whiteColor];
        _wind.textAlignment = NSTextAlignmentCenter;
        _wind.font = [UIFont systemFontOfSize:14];
    }
    return _wind;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
