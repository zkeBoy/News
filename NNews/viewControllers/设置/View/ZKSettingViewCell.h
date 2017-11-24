//
//  ZKSettingViewCell.h
//  ZKSport
//
//  Created by Tom on 2017/11/24.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKSettingModel.h"
@interface ZKSettingViewCell : UITableViewCell
@property (nonatomic, strong) ZKSettingModel * model;
@property (nonatomic, strong) UIView         * mainView;
@property (nonatomic, strong) UIImageView    * headerView;
@property (nonatomic, strong) UILabel        * titleLabel;
@property (nonatomic, strong) UIImageView    * iconView;
@property (nonatomic, strong) UILabel        * memoryLabel;
@end
