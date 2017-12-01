//
//  ZKSwitchViewCell.h
//  NNews
//
//  Created by Tom on 2017/12/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKSettingModel.h"
@interface ZKSwitchViewCell : UITableViewCell
@property (nonatomic, strong) ZKSettingModel * model;
@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) UILabel     * titleLabel;
@property (nonatomic, strong) UISwitch    * switchView;

@end
