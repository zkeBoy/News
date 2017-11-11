//
//  ZKWeatherView.m
//  NNews
//
//  Created by Tom on 2017/11/11.
//  Copyright © 2017年 Tom. All rights reserved.
//

typedef enum{
    night, //晚上
    day,   //白天
    unKonw //未知
} DayType;

#import "ZKWeatherView.h"

@interface ZKWeatherView ()
@property (nonatomic, strong) UIImageView * backgroundView;   //天气背景图
@property (nonatomic, strong) UILabel     * cityNameLabel;
@property (nonatomic, strong) UIButton    * locationBtn;      //定位

@property (nonatomic, strong) UIImageView * weatherImage;     //天气图标
@property (nonatomic, strong) UILabel     * temperatureLabel; //温度
@property (nonatomic, assign) DayType       dayType;          //
@property (nonatomic, strong) UIButton    * changeSwitch;     //白天黑夜开关



@end

@implementation ZKWeatherView

- (void)layoutSubviews {
    [self setUI];
}

- (void)setModel:(ZKWeatherModel *)model {
    _model = model;
    _cityNameLabel.text = model.cityName;
    
    NSString * currentTime = [self getNowTimeTimeZone:model.timeZone];
    [self compareTimeDayType:currentTime];
    [self compareDayType];
}

- (void)compareDayType{
    ZKDayModel * today = _model.dayArrays[0];
    if (_dayType == day) { //白天
        NSString * codeDay = today.codeDay;
        NSInteger type = codeDay.integerValue;
        [self exchangeBackgroundViewWithType:type];
        
        UIImage * wImage = [UIImage imageNamed:codeDay];
        [self.weatherImage addCATransitionAnimationWithType:ZKfade duration:1 directionSubtype:ZKmiddle];
        self.weatherImage.image = wImage;
        [self.changeSwitch setImage:[UIImage imageNamed:@"weather_sun_icon"] forState:UIControlStateNormal];
    }else if (_dayType == night) { //晚上
        NSString * codeNight = today.codeNight;
        NSInteger type = codeNight.integerValue;
        [self exchangeBackgroundViewWithType:type];
        
        UIImage * wImage = [UIImage imageNamed:codeNight];
        [self.weatherImage addCATransitionAnimationWithType:ZKfade duration:1 directionSubtype:ZKmiddle];
        self.weatherImage.image = wImage;
        [self.changeSwitch setImage:[UIImage imageNamed:@"weather_moon_icon"] forState:UIControlStateNormal];
    }
    [self.changeSwitch addCATransitionAnimationWithType:ZKfade duration:1 directionSubtype:ZKmiddle];
}


- (void)exchangeBackgroundViewWithType:(NSInteger)type{
    if (0<=type&&type<4) {       //晴天
        [self addAnimationSetImage:@"bg_sunny_day.jpg"];
    }else if (4<=type&&type<10){ //多云
        [self addAnimationSetImage:@"bg_normal.jpg"];
    }else if (10<=type&&type<20){//雨
        [self addAnimationSetImage:@"bg_sunny_day.jpg"];
    }else if (20<=type&&type<26){//雪
        [self addAnimationSetImage:@"bg_snow_night.jpg"];
    }else if (26<=type&&type<30){//沙尘暴
        [self addAnimationSetImage:@"bg_haze.jpg"];
    }else if (30<=type&&type<32){//雾霾
        [self addAnimationSetImage:@"bg_haze.jpg"];
    }else if (32<=type&&type<37){//风
        [self addAnimationSetImage:@"bg_sunny_day.jpg"];
    }else if (type==37){         //冷
        [self addAnimationSetImage:@"bg_fog_day.jpg"];
    }else if (type==38){         //热
        [self addAnimationSetImage:@"bg_sunny_day.jpg"];
    }else if (type==99){         //未知
        
    }
}

- (void)addAnimationSetImage:(NSString *)imageName{
    UIImage * image = [UIImage imageNamed:imageName];
    [self.backgroundView setImage:image];
    [self.backgroundView addCATransitionAnimationWithType:ZKrippleEffect duration:3.0f directionSubtype:ZKmiddle];
}

#pragma mark - Private Method
- (void)clickLocationAction{
    [self.delegate didClickLoactionBtn];
}

- (void)changeSwitchAction{
    if (_dayType==day) {
        _dayType = night;
    }else{
        _dayType = day;
    }
    [self compareDayType];
}


#pragma mark - setUI
- (void)setUI {
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self addSubview:self.locationBtn];
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(StatusH);
        make.right.equalTo(self).offset(-StatusH);
        make.width.height.mas_equalTo(33);
    }];
    
    [self addSubview:self.cityNameLabel];
    [self.cityNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.equalTo(self.cityNameLabel);
        make.centerY.equalTo(self.locationBtn.mas_centerY);
    }];
    
    [self addSubview:self.weatherImage];
    [self.weatherImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.cityNameLabel.mas_bottom).offset(StatusH);
        make.width.height.mas_equalTo(Scale(90));
    }];
    
    [self addSubview:self.changeSwitch];
    [self.changeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(Scale(40));
        make.centerY.equalTo(self.weatherImage.mas_centerY);
        make.right.equalTo(self.locationBtn.mas_right);
    }];
}

#pragma mark - lazy init
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_normal.jpg"]];
    }
    return _backgroundView;
}

- (UILabel *)cityNameLabel {
    if (!_cityNameLabel) {
        _cityNameLabel = [[UILabel alloc] init];
        _cityNameLabel.textColor = [UIColor whiteColor];
        _cityNameLabel.textAlignment = NSTextAlignmentCenter;
        _cityNameLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _cityNameLabel;
}

- (UIButton *)locationBtn {
    if (!_locationBtn) {
        _locationBtn = [[UIButton alloc] init];
        _locationBtn.backgroundColor = [UIColor clearColor];
        [_locationBtn addTarget:self action:@selector(clickLocationAction) forControlEvents:UIControlEventTouchUpInside];
        [_locationBtn setImage:[UIImage imageNamed:@"location_hardware"] forState:UIControlStateNormal];
    }
    return _locationBtn;
}

- (UIImageView *)weatherImage {
    if (!_weatherImage) {
        _weatherImage = [[UIImageView alloc] init];
        _weatherImage.backgroundColor = [UIColor clearColor];
    }
    return _weatherImage;
}

- (UIButton *)changeSwitch {
    if (!_changeSwitch) {
        _changeSwitch = [[UIButton alloc] init];
        [_changeSwitch addTarget:self action:@selector(changeSwitchAction) forControlEvents:UIControlEventTouchUpInside];
        _changeSwitch.backgroundColor = [UIColor clearColor];
    }
    return _changeSwitch;
}

#pragma mark - Tools
- (NSString *)getNowTimeTimeZone:(NSString *)tZone{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"HH:mm:ss"]; // ----YYYY-MM-dd HH:mm:ss------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:tZone];
    [formatter setTimeZone:timeZone];
    NSDate *dateNow = [NSDate date]; //现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [formatter stringFromDate:dateNow];
    return timeSp;
}

- (void)compareTimeDayType:(NSString *)time{
    NSArray * array = [time componentsSeparatedByString:@":"];
    if (array.count) {
        NSString * p1 = array[0];
        if (18<=p1.integerValue&&p1.integerValue<=24) {
            _dayType = night;
        }else if (1<=p1.integerValue&&p1.integerValue<=6){
            _dayType = night;
        }else {
            _dayType = day;
        }
    }
}

- (void)dealloc {
    NSLog(@"ZKWeatherView dealloc !!!");
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
