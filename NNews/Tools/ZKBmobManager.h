//
//  ZKBmobManager.h
//  BmobDemo
//
//  Created by Tom on 2017/11/29.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKUser.h"

@interface ZKBmobManager : NSObject

//注册接口(插入一条数据)
+ (void)bmobInsertUser:(ZKUser *)user result:(void(^)(BOOL success, NSError * error))resultBlock;

//登录接口(查找数据)
+ (void)bmobFindUser:(ZKUser *)user result:(void(^)(BOOL success, NSError * error))resultBlock;

@end
