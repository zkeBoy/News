//
//  ZKHomeImgsCell.h
//  NewDemo
//
//  Created by Tom on 2017/12/7.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKHomeModel.h"
@interface ZKHomeImgsCell : UITableViewCell
@property (nonatomic, strong) ZKHomeModel * model;
@property (nonatomic, strong) UILabel     * titleLabel;
@property (nonatomic, strong) UIImageView * imgIcon1;
@property (nonatomic, strong) UIImageView * imgIcon2;
@property (nonatomic, strong) UIImageView * imgIcon3;
@property (nonatomic, strong) UILabel     * sourceLabel;
@property (nonatomic, strong) UILabel     * replayLabel;
@end
