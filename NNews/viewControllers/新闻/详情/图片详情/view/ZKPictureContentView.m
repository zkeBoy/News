//
//  ZKPictureContentView.m
//  ZKSport
//
//  Created by Tom on 2017/11/23.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKPictureContentView.h"
#import <FLAnimatedImageView.h>

@interface ZKPictureContentView () <UIScrollViewDelegate>

@end

@implementation ZKPictureContentView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setUI];
}

- (void)setUI {
    [self addSubview:self.scrollView];
}

- (void)setImglinks:(NSArray *)imglinks{
    _imglinks = imglinks;
    self.scrollView.contentSize = CGSizeMake(D_WIDTH*imglinks.count, 0);
    NSInteger page = 0;
    for (NSString * link in imglinks) {
        FLAnimatedImageView * imgView = [[FLAnimatedImageView alloc] init];
        [self.scrollView addSubview:imgView];
        [imgView sd_setImageWithURL:[NSURL URLWithString:link] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGSize size = image.size;
            //CGFloat w = size.width;
            CGFloat h = size.height;
            imgView.frame = CGRectMake(page*D_WIDTH, D_HEIGHT/2-h/2, D_WIDTH, h);
        }];
        page++;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView { //滑动结束时调用
    NSInteger page = scrollView.contentOffset.x / D_WIDTH;
    [self.delegate contentDidSelectItemAtIndex:page];
}

#pragma mark - lazy init
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
