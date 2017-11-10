//
//  ZKWeatherViewController.m
//  NNews
//
//  Created by Tom on 2017/11/10.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKWeatherViewController.h"

@interface ZKWeatherViewController ()<ZKMapManagerDelegate>
@property (nonatomic, strong) ZKMapManager * mapManager;
@end

@implementation ZKWeatherViewController

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{ //返回直接支持的方向
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation { //返回最优先显示的屏幕方向
    return UIInterfaceOrientationPortrait;
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"天气";
    [self setBasicMessage];
}

- (void)setBasicMessage {
    UIImage * image = [[UIImage imageNamed:@"show_image_back_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIButton * back = [[UIButton alloc] init];
    back.frame = CGRectMake(StatusH, StatusH, 35, 35);
    [back setImage:image forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    self.mapManager = [ZKMapManager shareManager];
    [self.mapManager requireAuthorization];
    self.mapManager.delegate = self;
    if ([self.mapManager authorizationStatus]==(kCLAuthorizationStatusAuthorizedWhenInUse)) {
        [self.mapManager updateLocation];
    }else{ //授权失败
        
    }
}

#pragma mark - ZKMapManagerDelegate
- (void)mapManagerGetLastCLLocation:(CLLocation *)location city:(NSString *)city{
    NSLog(@"定位成功 - %@",city);
}

- (void)mapManagerFailureLocation:(NSError *)error {
    
}

- (void)mapManagerAuthorizationStatusChange:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.mapManager updateLocation];
    }
}

#pragma mark - setUI

#pragma mark - lazy init

#pragma mark - Private Method
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
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
