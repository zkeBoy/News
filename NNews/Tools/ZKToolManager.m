//
//  ZKToolManager.m
//  ZKSport
//
//  Created by Tom on 2017/11/24.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKToolManager.h"

@implementation ZKToolManager
+ (ZKToolManager *)shareManager{
    static ZKToolManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZKToolManager alloc] init];
    });
    return manager;
}

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
    NSError * error = nil;
    NSString * path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
}

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message other:(NSString *)other cancel:(NSString *)cancel rootViewController:(UIViewController *)rootVC otherBlock:(void(^)(void))otherBlock cancelBlock:(void(^)(void))cancelBlock {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sure = [UIAlertAction actionWithTitle:other style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
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

- (void)clipPhotoalbumImage:(void(^)(UIImage *image))completeBlock{
    UIImagePickerController * pickerVC = [[UIImagePickerController alloc] init];
    pickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerVC.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
    pickerVC.delegate = self;
    pickerVC.allowsEditing = YES;
    self.pickerVC = pickerVC;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:self.pickerVC animated:YES completion:nil];
    self.photoAlubmBlock = ^(UIImage * image) {
        if (completeBlock) {
            completeBlock (image);
        }
    };
}

// 选择图片成功调用此方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    if (self.photoAlubmBlock) {
        self.photoAlubmBlock(image);
    }
    [self.pickerVC dismissViewControllerAnimated:YES completion:nil];
}


// 取消图片选择调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.pickerVC dismissViewControllerAnimated:YES completion:nil];
}

- (UIViewController *)currentViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    while (vc.presentedViewController) {
        vc = vc.presentedViewController;
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = [(UINavigationController *)vc visibleViewController];
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = [(UITabBarController *)vc selectedViewController];
        }
    }
    return vc;
}

@end

