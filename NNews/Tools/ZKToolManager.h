//
//  ZKToolManager.h
//  ZKSport
//
//  Created by Tom on 2017/11/24.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^clipBlock)(UIImage *);

@interface ZKToolManager : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController * pickerVC;
@property (nonatomic,   copy) clipBlock photoAlubmBlock;

+ (ZKToolManager *)shareManager;

+ (float)cacheSize;

+ (void)cleanCache:(void(^)(void))completeBlock;

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                         other:(NSString *)other
                        cancel:(NSString *)cancel
            rootViewController:(UIViewController *)rootVC
                    otherBlock:(void(^)(void))otherBlock
                   cancelBlock:(void(^)(void))cancelBlock;

- (void)clipPhotoalbumImage:(void(^)(UIImage *image))completeBlock;

@end

