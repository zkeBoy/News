//
//  ZKPictureBottomView.m
//  ZKSport
//
//  Created by Tom on 2017/11/23.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKPictureBottomView.h"

@implementation ZKPictureBottomView

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setUI];
}

- (void)setUI {
    [self addSubview:self.pageLabel];
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(StatusH);
        make.left.equalTo(self).offset(Margin);
        make.right.equalTo(self).offset(-Margin);
        make.height.equalTo(self.pageLabel);
    }];
}

#pragma mark - lazy init
- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] init];
        _pageLabel.backgroundColor = [UIColor clearColor];
        _pageLabel.textColor = [UIColor whiteColor];
        _pageLabel.textAlignment = NSTextAlignmentLeft;
        _pageLabel.font = [UIFont systemFontOfSize:14];
        _pageLabel.numberOfLines = 0;
        _pageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _pageLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
