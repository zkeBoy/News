//
//  ZKWeatherViewController.m
//  NNews
//
//  Created by Tom on 2017/11/10.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKWeatherViewController.h"
#import "ZKWeatherView.h"
#import "ZKCityViewController.h"

@interface ZKWeatherViewController ()<ZKMapManagerDelegate, ZKWeatherViewDelegate, ZKCityViewControllerDelegate>
@property (nonatomic, strong) ZKMapManager   * mapManager;
@property (nonatomic, strong) ZKWeatherView  * weatherView;
@property (nonatomic, strong) UIImageView    * backgroundView;
@property (nonatomic, strong) NSURLSessionTask * sessionTask;

@end

@implementation ZKWeatherViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{ //返回直接支持的方向
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self setMap];
}

- (void)setMap {
    self.mapManager = [ZKMapManager shareManager];
    self.mapManager.delegate = self;
    if ([self.mapManager authorizationStatus]==(kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [self.mapManager updateLocation];
    }else{ //授权失败
        [self.mapManager requireAuthorization];
    }
}

#pragma mark - ZKMapManagerDelegate
- (void)mapManagerGetLastCLLocation:(CLLocation *)location city:(NSString *)city{
    NSLog(@"定位成功 - %@",city);
    [self startRequestWeatherCityName:city];
}

- (void)mapManagerFailureLocation:(NSError *)error {
    
}

- (void)mapManagerAuthorizationStatusChange:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.mapManager updateLocation];
    }
}

#pragma mark - ZKWeatherViewDelegate
- (void)didClickLoactionBtn{
    ZKCityViewController * cityVC = [[ZKCityViewController alloc] init];
    cityVC.delegate = self;
    [self.navigationController pushViewController:cityVC animated:YES];
}

#pragma mark - ZKCityViewControllerDelegate
- (void)didSelectCityName:(NSString *)cityName {
    [self startRequestWeatherCityName:cityName];
}

#pragma mark - setUI
- (void)setUI {
    [self.view addSubview:self.backgroundView];
    self.backgroundView.frame = self.view.bounds;
    
    [self.view addSubview:self.weatherView];
    [self.weatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    UIImage * image = [[UIImage imageNamed:@"show_image_back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton * back = [[UIButton alloc] init];
    back.frame = CGRectMake(StatusH, StatusH, 33, 33);
    [back setImage:image forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

#pragma mark - lazy init
- (UIImageView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_normal.jpg"]];
        _backgroundView.backgroundColor = [UIColor clearColor];
    }
    return _backgroundView;
}

- (ZKWeatherView *)weatherView {
    if (!_weatherView) {
        _weatherView = [[ZKWeatherView alloc] init];
        _weatherView.backgroundColor = [UIColor clearColor];
        _weatherView.delegate = self;
    }
    return _weatherView;
}


#pragma mark - Private Method
- (void)startRequestWeatherCityName:(NSString *)city{
    [self.sessionTask cancel];
    NSString * weatherLink = [NSString stringWithFormat:@"https://api.thinkpage.cn/v3/weather/daily.json?key=osoydf7ademn8ybv&location=%@&language=zh-Hans&start=0&days=3",city];
    weatherLink = [weatherLink stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    self.sessionTask = [[ZKNetWorkManager shareManager] requestWithType:requestTypeGet urlString:weatherLink andParameters:nil success:^(id responder) {
        if (responder) {
            NSArray * resultArray = responder[@"results"];
            NSDictionary * dic = resultArray[0];
            if (dic) {
                ZKWeatherModel * model = [[ZKWeatherModel alloc] init];
                model.cityName   = dic[@"location"][@"name"];
                model.updateTime = dic[@"last_update"];
                model.timeZone   = dic[@"location"][@"timezone"];
                model.dayArrays  = [ZKDayModel mj_objectArrayWithKeyValuesArray:dic[@"daily"]];
                [self updateWeather:model];
            }
        }
    } failure:^(NSError * error) {
        //[self showAlertViewController];
    }];
}

- (void)updateWeather:(ZKWeatherModel *)weatherModel{
    self.weatherView.model = weatherModel;
}

- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showAlertViewController{
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"location_fail", nil)
                                                                      message:@""
                                                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                     }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                       style:UIAlertActionStyleDestructive
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                     }];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"ZKWeatherViewController dealloc !!!!!!");
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
