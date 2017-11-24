//
//  ZKToolManager.m
//  ZKSport
//
//  Created by Tom on 2017/11/24.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKToolManager.h"

@implementation ZKToolManager

//缓存的大小
+ (float)cacheSize {
    float tmpSize = [[SDImageCache sharedImageCache] getSize] / 1024 /1024;
    return tmpSize;
}

+ (void)cleanCache:(void(^)(void))completeBlock;{
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        if (completeBlock) {
            completeBlock();
        }
    }];
}

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message other:(NSString *)other cancel:(NSString *)cancel rootViewController:(UIViewController *)rootVC otherBlock:(void(^)(void))otherBlock cancelBlock:(void(^)(void))cancelBlock {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:other style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (otherBlock) {
            otherBlock ();
        }
    }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (cancelBlock) {
            cancelBlock ();
        }
    }];
    [alertVC addAction:sure];
    [alertVC addAction:cancelAction];
    [rootVC presentViewController:alertVC animated:YES completion:nil];
}

@end
