//
//  ZKHelperView.h
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HUD_ANIMATION_DRURATION (0.8f)

@interface ZKHelperView : NSObject
// show hud
+ (void)showWaitingView;

// hidden hud
+ (void)hiddenWaitingView;

// show hud message
+ (void)showTextMessage:(NSString *)message;
+ (void)showTextMessage:(NSString *)message inView:(UIView *)view;
+ (void)showWaitingMessage:(NSString *)message;
+ (void)showWaitingMessage:(NSString *)message inView:(UIView *)view;
+ (void)showWaitingMessage:(NSString *)message inView:(UIView *)view inBlock:(dispatch_block_t)block;

// hide hud message
+ (void)hideWaitingMessage:(NSString *)message;
+ (void)hideWaitingMessage:(NSString *)message inView:(UIView *)view;
+ (void)hideWaitingMessageImmediately;
+ (void)hideWaitingMessageImmediatelyInView:(UIView *)view;

// show alert text
+ (void)showAlertMessage:(NSString *)message;
@end
