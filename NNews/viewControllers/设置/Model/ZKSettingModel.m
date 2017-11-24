//
//  ZKSettingModel.m
//  ZKSport
//
//  Created by Tom on 2017/11/24.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKSettingModel.h"

@implementation ZKSettingModel

+ (instancetype)initWithIcon:(NSString *)icon title:(NSString *)title clean:(BOOL)clean header:(BOOL)header{
    ZKSettingModel * model = [[ZKSettingModel alloc] init];
    model.icon = icon;
    model.title = title;
    model.cleanMemory = clean;
    model.isHeader = header;
    return model;
}

@end
