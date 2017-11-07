//
//  ZKTTVideoComment.m
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKTTVideoComment.h"

#define Margin 10

@implementation ZKTTVideoComment

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id"};
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [self mj_encode:aCoder];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self= [super init]) {
        [self mj_decode:aDecoder];
    }
    return self;
}

- (CGFloat)cellHeight {
    CGSize size = CGSizeMake(D_WIDTH-80, MAXFLOAT);
    CGRect rect = [self.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    _cellHeight = Margin*2 +20 + CGRectGetHeight(rect);
    return _cellHeight;
}

@end
