//
//  ZKHomeNetWork.h
//  MVVM
//
//  Created by Tom on 2017/12/2.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKBaseNetWork.h"

typedef NS_ENUM(NSInteger, listType) {
    listTypeFir = 1, //头条
    listTypeNba = 2, //NBA
    listTypePho = 3, //手机
    listTypeMbi = 4, //移动互联 (Mobile Interconnection)
    listTypeEnt = 5, //娱乐
    listTypeFas = 6, //时尚 Fashion
    listTypeMov = 7, //电影 Movie
    listTypeTec = 8, //科技 Technology
};

@interface ZKHomeNetWork : ZKBaseNetWork
+ (id)requestWithType:(listType)type lastTime:(NSString *)lastTime page:(NSInteger)page completionHandler:(void(^)(id obj, NSError *error))completionHandler;
@end
