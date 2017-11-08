//
//  ZKTTPicture.m
//  NNews
//
//  Created by Tom on 2017/11/8.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKTTPicture.h"

#define Margin 10
#define W_H 24

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
    NSInteger c_h = Margin+W_H+Margin;
    CGSize size = CGSizeMake(D_WIDTH-Margin*2, MAXFLOAT);
    CGRect rect = [_text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    CGFloat pictureHeight = self.height * D_WIDTH/self.width;
    if (pictureHeight>D_HEIGHT-NavBarH-TabBarH) {
        pictureHeight = size.width*9/16;
    }
    c_h = c_h +CGRectGetHeight(rect)+Margin*2+pictureHeight;
    return c_h;
}

@end
