//
//  ZKDetailModelManager.m
//  NNews
//
//  Created by Tom on 2017/11/7.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKDetailModelManager.h"

@implementation ZKDetailModelManager

+ (void)detailWithURLString:(NSString *)urlString andPara:(NSDictionary *)para success:(void(^)(id))sBlock failure:(void(^)(NSError *))fBlock{
    [[ZKNetWorkManager shareManager] requestWithType:requestTypePost urlString:urlString andParameters:para success:^(id responsder) {
        if (sBlock) {
            sBlock (responsder);
        }
    } failure:^(NSError * error) {
        if (fBlock) {
            fBlock (error);
        }
    }];
}

@end
