//
//  ZKHelperView.m
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKHelperView.h"

@implementation ZKHelperView

+ (void)showWaitingView{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    //HUD.mode = MBProgressHUDModeCustomView;
    [HUD showAnimated:YES];
}

+ (void)hiddenWaitingView{
    MBProgressHUD *HUD = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    [HUD hideAnimated:YES];
}

+ (void)showTextMessage:(NSString *)message{
    [self showTextMessage:message inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showTextMessage:(NSString *)message inView:(UIView *)view{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.mode = MBProgressHUDModeText;
    HUD.detailsLabel.text = [message copy];
    [HUD hideAnimated:YES afterDelay:HUD_ANIMATION_DRURATION];
}

+ (void)showWaitingMessage:(NSString *)message {
    [ZKHelperView showTextMessage:message inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showWaitingMessage:(NSString *)message inView:(UIView *)view{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:YES];
    HUD.detailsLabel.text = [message copy];
    [HUD showAnimated:YES];
}

+ (void)showWaitingMessage:(NSString *)message inView:(UIView *)view inBlock:(dispatch_block_t)block{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    HUD.detailsLabel.text = [message copy];
    [HUD showAnimated:YES whileExecutingBlock:block completionBlock:^{
        [HUD removeFromSuperview];
    }];
}

+ (void)hideWaitingMessage:(NSString *)message{
    [ZKHelperView hideWaitingMessage:message inView:[UIApplication sharedApplication].keyWindow];
}

+ (void)hideWaitingMessage:(NSString *)message inView:(UIView *)view{
    MBProgressHUD *HUD = [MBProgressHUD HUDForView:view];
    if (message) {
        HUD.detailsLabel.text = [message copy];
        HUD.mode = MBProgressHUDModeText;
        [HUD hideAnimated:YES afterDelay:HUD_ANIMATION_DRURATION];
    }else {
        [HUD hideAnimated:YES];
    }
}

+ (void)hideWaitingMessageImmediatelyInView:(UIView *)view{
    MBProgressHUD *HUD = [MBProgressHUD HUDForView:view];
    [HUD hideAnimated:YES];
}

+ (void)hideWaitingMessageImmediately{
    MBProgressHUD *HUD = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    [HUD hideAnimated:YES];
}

+ (void)showAlertMessage:(NSString *)message{
    UIAlertView *av = [[UIAlertView alloc]
                       initWithTitle:@"提示"
                       message:message
                       delegate:nil
                       cancelButtonTitle:@"确定"
                       otherButtonTitles: nil];
    [av show];
}

@end
