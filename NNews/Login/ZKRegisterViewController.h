//
//  ZKRegisterViewController.h
//  NNews
//
//  Created by Tom on 2017/11/28.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ZKRegisterDelegate;
@interface ZKRegisterViewController : UIViewController
@property (nonatomic, weak) id <ZKRegisterDelegate> delegate;

@end


@protocol ZKRegisterDelegate <NSObject>
@optional
- (void)registerSuccess;

@end
