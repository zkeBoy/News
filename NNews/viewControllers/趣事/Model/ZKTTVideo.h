//
//  ZKTTVideo.h
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKTTVideoComment.h"

@interface ZKTTVideo : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *profile_image;
@property (nonatomic, copy) NSString *screen_name;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *love;
@property (nonatomic, copy) NSString *cai;
@property (nonatomic, copy) NSString *repost;
@property (nonatomic, copy) NSString *comment;
@property (nonatomic, copy) NSString *maxtime;
@property (nonatomic, assign) BOOL sina_v;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *image0;
@property (nonatomic, copy) NSString *image1;
@property (nonatomic, copy) NSString *image2;
@property (nonatomic, copy) NSString *playcount;
@property (nonatomic, copy) NSString *videotime;
@property (nonatomic, copy) NSString *videouri;

@property (nonatomic, strong) ZKTTVideoComment *top_cmt; //热评
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) CGRect  videoFrame;
@end
