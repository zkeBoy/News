//
//  ZKCollectionManager.m
//  NNews
//
//  Created by Tom on 2018/1/16.
//  Copyright © 2018年 Tom. All rights reserved.
//

#import "ZKCollectionManager.h"

static NSString * const saveURLKey = @"saveURLString";
#define userDefaults [NSUserDefaults standardUserDefaults]

@implementation ZKCollectionManager

+ (void)saveURL:(NSString *)urlString {
    //compare
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[self getAllURLStrings]];
    if ([arr containsObject:urlString]) {
        return;
    }
    [arr addObject:urlString];
    [userDefaults setObject:[arr mutableCopy] forKey:saveURLKey];
}

+ (void)deleteURL:(NSString *)urlString {
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[self getAllURLStrings]];
    if ([arr containsObject:urlString]) {
        [arr removeObject:urlString];
    }
    [userDefaults setObject:[arr mutableCopy] forKey:saveURLKey];
}

+ (void)deleteWithItem:(NSInteger)item {
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[self getAllURLStrings]];
    if (arr.count&&item<arr.count) {
        [arr removeObjectAtIndex:item];
    }
    [userDefaults setObject:[arr mutableCopy] forKey:saveURLKey];
}

+ (NSArray *)getAllURLStrings {
    NSArray * arr = [userDefaults objectForKey:saveURLKey];
    return arr;
}

@end
