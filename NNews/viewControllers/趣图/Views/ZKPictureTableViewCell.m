//
//  ZKPictureTableViewCell.m
//  NNews
//
//  Created by Tom on 2017/11/8.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKPictureTableViewCell.h"

@implementation ZKPictureTableViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setUI];
}

- (void)setPictureModel:(ZKTTPicture *)pictureModel {
    _pictureModel = pictureModel;
}


#pragma mark -
#pragma mark lazy init

#pragma mark - setUI
- (void)setUI{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
