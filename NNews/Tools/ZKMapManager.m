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
        [self.locationManager requestWhenInUseAuthorization];
    }
}

#pragma mark - CLLocationManagerDelegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
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
