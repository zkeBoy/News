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
    unKnow //未知
} DayType;

#import "ZKWeatherView.h"

@interface ZKWeatherView ()
@property (nonatomic, strong) UIImageView * backgroundView;   //天气背景图
@property (nonatomic, strong) UILabel     * cityNameLabel;
@property (nonatomic, strong) UIButton    * locationBtn;      //定位
@property (nonatomic, assign) DayType       dayType;          //
@property (nonatomic, strong) UIButton    * changeSwitch;     //白天黑夜开关

//今天
@property (nonatomic, strong) UIImageView * weatherImage;     //天气图标
@property (nonatomic, strong) UILabel     * temperatureLabel; //温度

//明天
@property (nonatomic, strong) UILabel     * dayLabel2;         //明天
@property (nonatomic, strong) UIImageView * weatherImage2;     //天气图标
@property (nonatomic, strong) UILabel     * temperatureLabel2; //温度

//后天
@property (nonatomic, strong) UILabel     * dayLabel3;         //后天
@property (nonatomic, strong) UIImageView * weatherImage3;     //天气图标
@property (nonatomic, strong) UILabel     * temperatureLabel3; //温度

@end

@implementation ZKWeatherView

- (void)layoutSubviews {
    [self setUI];
}

- (void)setModel:(ZKWeatherModel *)model {
    ZKDayModel * today = model.dayArrays[0];
    [self today:today];
    ZKDayModel * twoDay = model.dayArrays[1];
    [self twoday:twoDay];
    ZKDayModel * threeDay = model.dayArrays[2];
    [self threeday:threeDay];
    _model = model;
    
    _cityNameLabel.text = model.cityName;
    NSString * currentTime = [self getNowTimeTimeZone:model.timeZone];
    [self compareTimeDayType:currentTime];
    [self compareDayType];
    
    self.dayLabel2.text = @"明天";
    self.dayLabel3.text = @"后天";
}

- (void)today:(ZKDayModel *)day{
    _temperatureLabel.text = [NSString stringWithTemperatureString:day.high low:day.low];
}

- (void)twoday:(ZKDayModel *)day{
    _temperatureLabel2.text = [NSString stringWithTemperatureString:day.high low:day.low];
}

- (void)threeday:(ZKDayModel *)day{
    _temperatureLabel3.text = [NSString stringWithTemperatureString:day.high low:day.low];
}

- (void)compareDayType{
    ZKDayModel * today = _model.dayArrays[0];
    ZKDayModel * twoday = _model.dayArrays[1];
    ZKDayModel * threeday = _model.dayArrays[2];
    if (_dayType == day) { //白天
        NSString * codeDay = today.codeDay;
        NSInteger type = codeDay.integerValue;
        [self exchangeBackgroundViewWithType:type];
        
        UIImage * wImage = [UIImage imageNamed:codeDay];
        [self.weatherImage addCATransitionAnimationWithType:ZKfade duration:1 directionSubtype:ZKmiddle];
        self.weatherImage.image = wImage;
        
        NSString * codeDay2 = twoday.codeDay;
        UIImage * wImage2 = [UIImage imageNamed:codeDay2];
        [self.weatherImage2 addCATransitionAnimationWithType:ZKfade duration:1 directionSubtype:ZKmiddle];
        self.weatherImage2.image = wImage2;
        
        NSString * codeDay3 = threeday.codeDay;
        UIImage * wImage3 = [UIImage imageNamed:codeDay3];
        [self.weatherImage3 addCATransitionAnimationWithType:ZKfade duration:1 directionSubtype:ZKmiddle];
        self.weatherImage3.image = wImage3;
        
        [self.changeSwitch setImage:[UIImage imageNamed:@"weather_sun_icon"] forState:UIControlStateNormal];
    }else if (_dayType == night) { //晚上
        NSString * codeNight = today.codeNight;
        NSInteger type = codeNight.integerValue;
        [self exchangeBackgroundViewWithType:type];
        
        UIImage * wImage = [UIImage imageNamed:codeNight];
        [self.weatherImage addCATransitionAnimationWithType:ZKfade duration:1 directionSubtype:ZKmiddle];
        self.weatherImage.image = wImage;
        
        NSString * codeNight2 = twoday.codeNight;
        UIImage * wImage2 = [UIImage imageNamed:codeNight2];
        [self.weatherImage2 addCATransitionAnimationWithType:ZKfade duration:1 directionSubtype:ZKmiddle];
        self.weatherImage2.image = wImage2;
        
        NSString * codeNight3 = threeday.codeNight;
        UIImage * wImage3 = [UIImage imageNamed:codeNight3];
        [self.weatherImage3 addCATransitionAnimationWithType:ZKfade duration:1 directionSubtype:ZKmiddle];
        self.weatherImage3.image = wImage3;
        
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
    
    [self addSubview:self.temperatureLabel];
    [self.temperatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.height.equalTo(self.temperatureLabel);
        make.top.equalTo(self.weatherImage.mas_bottom).offset(StatusH);
    }];
    
    
    [self addSubview:self.weatherImage2];
    [self.weatherImage2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(Scale(StatusH*2));
        make.width.height.mas_equalTo(Scale(90));
        make.top.equalTo(self.temperatureLabel.mas_bottom).offset(Scale(200));
    }];
    
    [self addSubview:self.dayLabel2];
    [self.dayLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.weatherImage2.mas_centerX);
        make.bottom.equalTo(self.weatherImage2.mas_top).offset(-Scale(StatusH));
        make.width.height.equalTo(self.dayLabel2);
    }];
    
    [self addSubview:self.temperatureLabel2];
    [self.temperatureLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.weatherImage2.mas_centerX);
        make.width.height.equalTo(self.temperatureLabel2);
        make.top.equalTo(self.weatherImage2.mas_bottom).offset(Scale(StatusH));
    }];
    
    [self addSubview:self.weatherImage3];
    [self.weatherImage3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weatherImage2);
        make.width.height.mas_offset(Scale(90));
        make.right.equalTo(self).offset(-Scale(StatusH*2));
    }];
    
    [self addSubview:self.dayLabel3];
    [self.dayLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.weatherImage3.mas_centerX);
        make.bottom.equalTo(self.weatherImage3.mas_top).offset(-Scale(StatusH));
        make.width.height.equalTo(self.dayLabel3);
    }];
    
    [self addSubview:self.temperatureLabel3];
    [self.temperatureLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.weatherImage3.mas_bottom).offset(Scale(StatusH));
        make.centerX.equalTo(self.weatherImage3);
        make.width.height.equalTo(self.temperatureLabel3);
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

- (UILabel *)temperatureLabel {
    if (!_temperatureLabel) {
        _temperatureLabel = [[UILabel alloc] init];
        _temperatureLabel.backgroundColor = [UIColor clearColor];
        _temperatureLabel.textColor = [UIColor whiteColor];
        _temperatureLabel.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _temperatureLabel;
}

- (UILabel *)dayLabel2 {
    if (!_dayLabel2) {
        _dayLabel2 = [[UILabel alloc] init];
        _dayLabel2.textColor = [UIColor whiteColor];
        _dayLabel2.textAlignment = NSTextAlignmentCenter;
        _dayLabel2.font = [UIFont boldSystemFontOfSize:16];
        _dayLabel2.backgroundColor = [UIColor clearColor];
    }
    return _dayLabel2;
}

- (UIImageView *)weatherImage2 {
    if (!_weatherImage2) {
        _weatherImage2 = [[UIImageView alloc] init];
        _weatherImage2.backgroundColor = [UIColor clearColor];
    }
    return _weatherImage2;
}

- (UILabel *)temperatureLabel2 {
    if (!_temperatureLabel2) {
        _temperatureLabel2 = [[UILabel alloc] init];
        _temperatureLabel2.backgroundColor = [UIColor clearColor];
        _temperatureLabel2.textColor = [UIColor whiteColor];
        _temperatureLabel2.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel2.font = [UIFont boldSystemFontOfSize:16];
    }
    return _temperatureLabel2;
}

- (UILabel *)dayLabel3 {
    if (!_dayLabel3) {
        _dayLabel3 = [[UILabel alloc] init];
        _dayLabel3.backgroundColor = [UIColor clearColor];
        _dayLabel3.textAlignment = NSTextAlignmentCenter;
        _dayLabel3.textColor = [UIColor whiteColor];
        _dayLabel3.font = [UIFont boldSystemFontOfSize:16];
    }
    return _dayLabel3;
}

- (UIImageView *)weatherImage3 {
    if (!_weatherImage3) {
        _weatherImage3 = [[UIImageView alloc] init];
        _weatherImage3.backgroundColor = [UIColor clearColor];
    }
    return _weatherImage3;
}

- (UILabel *)temperatureLabel3 {
    if (!_temperatureLabel3) {
        _temperatureLabel3 = [[UILabel alloc] init];
        _temperatureLabel3.backgroundColor = [UIColor clearColor];
        _temperatureLabel3.textColor = [UIColor whiteColor];
        _temperatureLabel3.textAlignment = NSTextAlignmentCenter;
        _temperatureLabel3.font = [UIFont boldSystemFontOfSize:16];
    }
    return _temperatureLabel3;
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
