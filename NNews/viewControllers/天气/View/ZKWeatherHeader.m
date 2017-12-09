//
//  ZKWeatherHeader.m
//  Youliao
//
//  Created by Tom on 2017/11/30.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKWeatherHeader.h"

@interface ZKWeatherHeader()
@property (nonatomic, strong) UILabel * city; //所在城市
@property (nonatomic, strong) UILabel * date; //日期
@property (nonatomic, strong) UIImageView * weatherIcon;
@property (nonatomic, strong) UILabel * tempture; //温度
@property (nonatomic, strong) UILabel * weatherStatus;
@property (nonatomic, strong) UILabel * wind; //风力
@property (nonatomic, strong) UILabel * suggest; //建议

@end

@implementation ZKWeatherHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self addSubview:self.city];
    [self addSubview:self.date];
    [self addSubview:self.weatherIcon];
    [self addSubview:self.tempture];
    [self addSubview:self.weatherStatus];
    [self addSubview:self.wind];
    [self addSubview:self.suggest];
}

- (void)setWeatherModel:(ZKWeatherModel *)weatherModel {
    _weatherModel = weatherModel;
    
    NSString * cityName = weatherModel.currentCity;
    self.city.text = cityName;
    
    ZKWeatherData * data = [ZKWeatherData mj_objectWithKeyValues:weatherModel.weather_data[0]];
    self.date.text = data.date; 
    self.tempture.text = data.temperature;
    self.weatherStatus.text = data.weather;
    self.wind.text = data.wind;
    
    ZKWeatherDetail * detail = [ZKWeatherDetail mj_objectWithKeyValues:weatherModel.index[0]];
    self.suggest.text = detail.des;
    
    [self setWeatherImgWithWeather:data.weather];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.city mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(Margin*2+8);
        make.width.height.equalTo(self.city);
    }];
    
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.city.mas_bottom).offset(Margin);
        make.width.height.equalTo(self.date);
    }];
    
    [self.weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(140);
        make.left.equalTo(self).offset(50);
        make.width.height.mas_equalTo(50);
    }];
    
    [self.weatherStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.weatherIcon.mas_centerY);
        make.left.equalTo(self.weatherIcon.mas_right).offset(50);
        make.width.height.equalTo(self.weatherStatus);
    }];
    
    [self.tempture mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.weatherStatus.mas_left);
        make.bottom.equalTo(self.weatherStatus.mas_top).offset(-StatusH);
        make.width.height.equalTo(self.tempture);
    }];
    
    
    [self.wind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tempture.mas_left);
        make.width.height.equalTo(self.wind);
        make.top.equalTo(self.weatherStatus.mas_bottom).offset(StatusH);
    }];
    
    [self.suggest mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wind.mas_bottom).offset(StatusH);
        make.left.equalTo(self).offset(50);
        make.right.equalTo(self).offset(-50);
        make.width.height.equalTo(self.suggest);
    }];
}

- (void)setWeatherImgWithWeather:(NSString *)weather {
    NSString * weaName = [NSString getWeatherTypeWithWeather:weather];
    UIImage * image = [UIImage imageNamed:weaName];
    self.weatherIcon.image = image;
}

#pragma mark - lazy init
- (UILabel *)city {
    if (!_city) {
        _city = [[UILabel alloc] init];
        _city.textColor = [UIColor whiteColor];
        _city.textAlignment = NSTextAlignmentCenter;
        _city.font = [UIFont systemFontOfSize:18];
        _city.backgroundColor = [UIColor clearColor];
    }
    return _city;
}

- (UILabel *)date {
    if (!_date) {
        _date = [[UILabel alloc] init];
        _date.textColor = [UIColor whiteColor];
        _date.textAlignment = NSTextAlignmentCenter;
        _date.font = [UIFont systemFontOfSize:14];
        _date.backgroundColor = [UIColor clearColor];
    }
    return _date;
}

- (UIImageView *)weatherIcon {
    if (!_weatherIcon) {
        _weatherIcon = [[UIImageView alloc] init];
        _weatherIcon.backgroundColor = [UIColor clearColor];
        _weatherIcon.contentMode = UIViewContentModeScaleToFill;
    }
    return _weatherIcon;
}

- (UILabel *)tempture {
    if (!_tempture) {
        _tempture = [[UILabel alloc] init];
        _tempture.textColor = [UIColor whiteColor];
        _tempture.textAlignment = NSTextAlignmentLeft;
        _tempture.font = [UIFont boldSystemFontOfSize:20];
        _tempture.backgroundColor = [UIColor clearColor];
    }
    return _tempture;
}

- (UILabel *)weatherStatus {
    if (!_weatherStatus) {
        _weatherStatus = [[UILabel alloc] init];
        _weatherStatus.textColor = [UIColor whiteColor];
        _weatherStatus.textAlignment = NSTextAlignmentLeft;
        _weatherStatus.font = [UIFont systemFontOfSize:14];
        _weatherStatus.backgroundColor = [UIColor clearColor];
    }
    return _weatherStatus;
}

- (UILabel *)wind {
    if (!_wind) {
        _wind = [[UILabel alloc] init];
        _wind.textColor = [UIColor whiteColor];
        _wind.textAlignment = NSTextAlignmentLeft;
        _wind.font = [UIFont systemFontOfSize:14];
        _wind.backgroundColor = [UIColor clearColor];
    }
    return _wind;
}

- (UILabel *)suggest {
    if (!_suggest) {
        _suggest = [[UILabel alloc] init];
        _suggest.backgroundColor = [UIColor clearColor];
        _suggest.textColor = [UIColor whiteColor];
        _suggest.textAlignment = NSTextAlignmentLeft;
        _suggest.font = [UIFont systemFontOfSize:14];
        _suggest.numberOfLines = 0;
    }
    return _suggest;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
