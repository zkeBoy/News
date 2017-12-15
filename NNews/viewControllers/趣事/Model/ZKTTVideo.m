//
//  ZKTTVideo.m
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKTTVideo.h"

CGFloat const cellMargin = 10;
CGFloat const cellTextY = 55;
CGFloat const cellBottomBarHeight = 40;
CGFloat const cellTopCommentTopLabelHeight = 16;

@implementation ZKTTVideo

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID":@"id",
             @"top_cmt":@"top_cmt[0]"};
}

-(CGFloat)cellHeight {
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 2*cellMargin, MAXFLOAT);
    CGFloat textHeight = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.height;
    _cellHeight = cellMargin+cellTextY + textHeight;
    
    //videoImageView的高度
    CGFloat videoX = 0;
    CGFloat videoY = cellTextY + textHeight + cellMargin;
    CGFloat videoWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGFloat videoHeight = self.height * videoWidth/self.width;
    self.videoFrame = CGRectMake(videoX, videoY, videoWidth, videoHeight);
    _cellHeight += videoHeight + cellMargin;
    
    /*
    //热评的高度
    ZKTTVideoComment *cmt = self.top_cmt;
    if (cmt) {//最热评论存在
        NSString *content = [NSString stringWithFormat:@"%@ : %@",cmt.user.username, cmt.content];
        CGFloat topCommentHeight = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 ]} context:nil].size.height;
        
        _cellHeight += 0.5*cellMargin + cellTopCommentTopLabelHeight+topCommentHeight + 0.5*cellMargin + cellBottomBarHeight;
    } else {
        _cellHeight += 0.5*cellMargin+ 0.5*cellMargin +cellBottomBarHeight;
    }
    */
    return _cellHeight+40;
}

@end
