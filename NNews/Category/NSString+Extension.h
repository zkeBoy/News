//
//  NSString+Extension.h
//  NNews
//
//  Created by Tom on 2017/11/3.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)
+ (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime
                           duration:(NSTimeInterval)duration;

+ (NSString *)stringWithTemperatureString:(NSString *)high
                                      low:(NSString *)low;
@end
