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
    /*
    CGSize size = CGSizeMake(D_WIDTH, <#CGFloat height#>)
    CGRect rect = [self.content boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(nullable NSDictionary<NSAttributedStringKey,id> *)#> context:<#(nullable NSStringDrawingContext *)#>];
    */
    return 0;
}

@end
