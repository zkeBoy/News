//
//  UIImage+xxCategory.m
//  runtimeTest
//
//  Created by iobit on 09/02/2017.
//  Copyright © 2017 iobit. All rights reserved.
//

#import "UIImage+xxCategory.h"
#import <objc/runtime.h>

@implementation UIImage (xxCategory)

+ (UIImage *)xx_imageName:(NSString *)name{
    double num = [[UIDevice currentDevice].systemVersion doubleValue];
    if (num>8.0) {
        //NSLog(@"current system is %f",num);
    }
    return [UIImage xx_imageName:name];
}

//拦截系统方法
+ (void)load{
    Method m1 = class_getClassMethod([UIImage class], @selector(xx_imageName:));
    Method m2 = class_getClassMethod([UIImage class], @selector(imageNamed:));
    method_exchangeImplementations(m1, m2);
}

@end
