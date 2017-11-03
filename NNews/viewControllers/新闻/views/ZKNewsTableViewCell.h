//
//  ZKNewsTableViewCell.h
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKNewsModel.h"
@interface ZKNewsTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView      * mainView;
@property (nonatomic, strong) UIImageView * headIcon;
@property (nonatomic, strong) UILabel     * detailTitle;
@property (nonatomic, strong) UIView      * separatorView;
@property (nonatomic, strong) ZKNewsModel * model;
@end
