//
//  ZKDetailHeaderView.m
//  NNews
//
//  Created by Tom on 2017/11/4.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKDetailHeaderView.h"

@interface ZKDetailHeaderView ()
@property (nonatomic, strong) UIView      * mainView;     //主View
@property (nonatomic, strong) UIImageView * userIcon;     //用户ICON
@property (nonatomic, strong) UILabel     * userName;     //用户名称
@property (nonatomic, strong) UILabel     * timeTitle;    //视频时间
@property (nonatomic, strong) UIImageView * coverImage;   //封面

@property (nonatomic, strong) UILabel     * watchNumber;  //观看人数,视频评论有
@property (nonatomic, strong) UILabel     * playTimes;    //播放次数,视频评论有

@property (nonatomic, strong) UILabel     * pictureCommentTitle; //图片评论

@property (nonatomic, strong) UIImageView * moreInfoImageView; //更多详情界面

@end

@implementation ZKDetailHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
