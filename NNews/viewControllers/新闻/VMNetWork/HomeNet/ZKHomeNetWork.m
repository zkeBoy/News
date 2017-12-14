//
//  ZKHomeNetWork.m
//  MVVM
//
//  Created by Tom on 2017/12/2.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKHomeNetWork.h"

@implementation ZKHomeNetWork

+ (id)requestWithType:(listType)type lastTime:(NSString *)lastTime page:(NSInteger)page completionHandler:(void(^)(id obj, NSError *error))completionHandler{
    NSString * path;
    if (type == listTypeFir) {
        
    }else if (type == listTypeNba){
        
    }else if (type == listTypeTec){
        path = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%ld-20.html",(long)page];
    }
    return [self GET:path para:nil progress:nil completionHandler:completionHandler];
}

@end
