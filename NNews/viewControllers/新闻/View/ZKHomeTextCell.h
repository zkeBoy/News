//
//  ZKHomeTexCell.h
//  NewDemo
//
//  Created by Tom on 2017/12/7.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKHomeModel.h"
@interface ZKHomeTextCell : UITableViewCell
@property (nonatomic, strong) ZKHomeModel * model;
@property (nonatomic, strong) UIImageView * imgIcon;
@property (nonatomic, strong) UILabel     * subTitleLabel;
@property (nonatomic, strong) UIImageView * defaultIcon;
@end
