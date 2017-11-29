//
//  ZKUser.h
//  BmobDemo
//
//  Created by Tom on 2017/11/29.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const userNameKey = @"userName";
static NSString * const passWordKey = @"passWord";

@interface ZKUser : NSObject
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * passWord;

@end
