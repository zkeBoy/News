//
//  ZKMapManager.m
//  NNews
//
//  Created by Tom on 2017/11/10.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKMapManager.h"
@interface ZKMapManager ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager * locationManager;

@end

@implementation ZKMapManager

+ (ZKMapManager *)shareManager {
    static ZKMapManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZKMapManager alloc] init];
    });
    return manager;
}

- (void)requireAuthorization { //要求授权
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization]; //使用期间定位
        //[self.locationManager requestAlwaysAuthorization];    //一直使用定位
    }
}

#pragma mark - CLLocationManagerDelegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    
    CLLocation *location = [locations lastObject];
    NSTimeInterval locationTime = -[location.timestamp timeIntervalSinceNow];
    if (locationTime>5) {
        return;
    }
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            NSString *cityName = placemarks.lastObject.addressDictionary[@"City"];
            NSString *city = [cityName substringToIndex:cityName.length -1];
            [self.delegate mapManagerGetLastCLLocation:location city:city];
        }
    }];
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

//定位授权发生改变时
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"用户还未决定授权");
            break;
        }
        case kCLAuthorizationStatusRestricted:{
            NSLog(@"访问受限");
            [self.delegate mapManagerAuthorizationStatusChange:kCLAuthorizationStatusRestricted];
            break;
        }
        case kCLAuthorizationStatusDenied:{
            // 类方法，判断是否开启定位服务
            if ([CLLocationManager locationServicesEnabled]) {
                NSLog(@"定位服务开启，被拒绝");
            } else {
                NSLog(@"定位服务关闭，不可用");
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:{
            
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            [self.delegate mapManagerAuthorizationStatusChange:kCLAuthorizationStatusAuthorizedWhenInUse];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Out Action
- (void)updateLocation{
    [self.locationManager startUpdatingLocation];
}

- (CLAuthorizationStatus)authorizationStatus {
    return [CLLocationManager authorizationStatus];
}

#pragma mark - lazy init
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

@end
