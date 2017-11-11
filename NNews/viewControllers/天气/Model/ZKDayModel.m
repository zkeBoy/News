//
//  ZKDayModel.m
//  NNews
//
//  Created by Tom on 2017/11/11.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKDayModel.h"

@implementation ZKDayModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"codeDay":@"code_day",
             @"codeNight":@"code_night"
             };
}

@end
