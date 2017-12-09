//
//  ZKWeatherController.m
//  Youliao
//
//  Created by Tom on 2017/11/30.
//  Copyright © 2017年 Tom. All rights reserved.
//

#define BaiduKey @"Q0qFFiynCewS75iBPQ9TkChH"

#import "ZKWeatherController.h"
#import "ZKCityViewController.h"
#import "ZKWeatherBottom.h"
#import "ZKWeatherHeader.h"

@interface ZKWeatherController ()<ZKCityViewControllerDelegate>
@property (nonatomic, strong) UIImageView     * backgroundView;
@property (nonatomic, strong) ZKWeatherHeader * headerView;
@property (nonatomic, strong) ZKWeatherBottom * bottomView;
@property (nonatomic, strong) ZKWeatherModel  * weatherModel;
@end

@implementation ZKWeatherController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"tab_weather", nil);
    [self setBackgroundView];
    [self setHeaderView];
    [self setBottomView];
    [self setBarItems];
    [self requestWeatherDataWithCity:@"成都"];
}

- (void)requestWeatherDataWithCity:(NSString *)city{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"location"] = city;
    params[@"ak"] = BaiduKey;
    params[@"output"] = @"json";
    NSString * linkString = @"http://api.map.baidu.com/telematics/v3/weather?";
    
    [ZKBaseNetWork GET:linkString para:params progress:nil completionHandler:^(NSDictionary * responsderObj, NSError *error) {
        NSArray * array = [ZKWeatherModel mj_objectArrayWithKeyValuesArray:responsderObj[@"results"]];
        self.weatherModel = array[0];
        [self updateWeather];
    }];
}

- (void)updateWeather {
    self.headerView.weatherModel = self.weatherModel;
    self.bottomView.weatherModel = self.weatherModel;
}

#pragma mark - set Views
- (void)setBackgroundView {
    self.backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundView.image = [UIImage imageNamed:@"bg_normal.jpg"];
    [self.view addSubview:self.backgroundView];
}

- (void)setHeaderView {
    self.headerView = [[ZKWeatherHeader alloc] init];
    self.headerView.frame = CGRectMake(0, 0, D_WIDTH, D_HEIGHT*0.6);
    self.headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.headerView];
}

- (void)setBottomView {
    self.bottomView = [[ZKWeatherBottom alloc] init];
    self.bottomView.frame = CGRectMake(0, D_HEIGHT*0.6, D_WIDTH, D_HEIGHT*0.4);
    self.bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.view addSubview:self.bottomView];
}

- (void)setBarItems {
    UIButton * backBtn = [[UIButton alloc] init];
    backBtn.backgroundColor = [UIColor clearColor];
    backBtn.frame = CGRectMake(Margin, StatusH, 33, 33);
    [backBtn setImage:[UIImage imageNamed:@"show_image_back_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(dismissMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    {
        UIButton * cityBtn = [[UIButton alloc] init];
        cityBtn.backgroundColor = [UIColor clearColor];
        cityBtn.frame = CGRectMake(D_WIDTH-33-Margin, StatusH, 33, 33);
        [cityBtn setImage:[UIImage imageNamed:@"location_hardware"] forState:UIControlStateNormal];
        [cityBtn addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:cityBtn];
    }
}

- (void)dismissMethod {
    if (self.presentationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)selectCity {
    ZKCityViewController * cityVC = [[ZKCityViewController alloc] init];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}

#pragma mark - ZKCityViewControllerDelegate
- (void)didSelectCityName:(NSString *)cityName{
    [self requestWeatherDataWithCity:cityName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
