//
//  ZKMapManager.h
//  NNews
//
//  Created by Tom on 2017/11/10.
//  Copyright © 2017年 Tom. All rights reserved.
//  定位工具

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@protocol ZKMapManagerDelegate;

@interface ZKMapManager : NSObject
@property (nonatomic, weak) id <ZKMapManagerDelegate> delegate;
@property (nonatomic, readonly) CLAuthorizationStatus authorizationStatus;

+ (ZKMapManager *)shareManager;
- (void)requireAuthorization;
- (void)updateLocation;
@end

@protocol ZKMapManagerDelegate <NSObject>
@optional
- (void)mapManagerGetLastCLLocation:(CLLocation *)location city:(NSString *)city;
- (void)mapManagerFailureLocation:(NSError *)error;
- (void)mapManagerAuthorizationStatusChange:(CLAuthorizationStatus)status;
@end
