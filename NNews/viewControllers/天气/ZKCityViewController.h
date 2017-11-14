//
//  ZKCityViewController.h
//  NNews
//
//  Created by Tom on 2017/11/14.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKCityModel.h"
@protocol ZKCityViewControllerDelegate;
@interface ZKCityViewController : UITableViewController
@property (nonatomic, weak) id <ZKCityViewControllerDelegate> delegate;
@end

@protocol ZKCityViewControllerDelegate <NSObject>
@optional
- (void)didSelectCityName:(NSString *)cityName;

@end
