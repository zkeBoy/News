//
//  ZKBmobManager.m
//  BmobDemo
//
//  Created by Tom on 2017/11/29.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKBmobManager.h"

#define TabName @"userInfo"

@implementation ZKBmobManager

+ (void)bmobInsertUser:(ZKUser *)user result:(void(^)(BOOL success, NSError * error))resultBlock{
    //往TabName 表添加一条数据
    BmobObject *gameScore = [BmobObject objectWithClassName:TabName];
    [gameScore setObject:user.userName forKey:userNameKey];
    [gameScore setObject:user.passWord forKey:passWordKey];
    [gameScore saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (resultBlock) {
            resultBlock (isSuccessful, error);
        }
    }];
}

+ (void)bmobFindUser:(ZKUser *)user result:(void(^)(BOOL success, NSError * error))resultBlock{
    BmobQuery   *bquery = [BmobQuery queryWithClassName:TabName];
    [bquery setLimit:500];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        BOOL find = NO;
        for (BmobObject *obj in array) {
            NSString * userName = [obj objectForKey:userNameKey];
            if ([userName isEqualToString:user.userName]) {
                find = YES;
                if (resultBlock) {
                    resultBlock (YES, nil);
                }
            }
        }
        if (!find) {
            if (resultBlock) {
                resultBlock (NO, nil);
            }
        }
    }];
}

+ (void)loginSuccess:(ZKUser *)user{
    NSDictionary * userInfo = user.mj_keyValues;
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"userInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logOut{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
}

+ (ZKUser *)user{
    NSDictionary * userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    ZKUser *user = [ZKUser mj_objectWithKeyValues:userInfo];
    return user;
}

@end
