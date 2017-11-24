//
//  ZKToolManager.h
//  ZKSport
//
//  Created by Tom on 2017/11/24.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKToolManager : NSObject
+ (float)cacheSize;

+ (void)cleanCache:(void(^)(void))completeBlock;

+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
                         other:(NSString *)other
                        cancel:(NSString *)cancel
            rootViewController:(UIViewController *)rootVC
                    otherBlock:(void(^)(void))otherBlock
                   cancelBlock:(void(^)(void))cancelBlock;
@end
