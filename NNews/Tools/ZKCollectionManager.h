//
//  ZKCollectionManager.h
//  NNews
//
//  Created by Tom on 2018/1/16.
//  Copyright © 2018年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKCollectionManager : NSObject

+ (void)saveURL:(NSString *)urlString;
+ (void)deleteURL:(NSString *)urlString;
+ (void)deleteWithItem:(NSInteger)item;
+ (NSArray *)getAllURLStrings;
@end
