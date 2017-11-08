//
//  ZKTTPicture.m
//  NNews
//
//  Created by Tom on 2017/11/8.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKTTPicture.h"

@implementation ZKTTPicture

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self= [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [self mj_encode:aCoder];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id",
             @"top_cmt":@"top_cmt[0]"};
}

- (CGFloat)cellHeight {
    return 0;
}

@end
