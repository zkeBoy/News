//
//  ZKNewsDetailModel.h
//  NewDemo
//
//  Created by Tom on 2017/12/7.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZKImageDetailModel;

@interface ZKNewsDetailModel : NSObject
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 发布时间 */
@property (nonatomic, copy) NSString *ptime;
/** 内容 */
@property (nonatomic, copy) NSString *body;
/** 配图 */
@property (nonatomic, strong) NSArray *img;
@end

@interface ZKImageDetailModel: NSObject
@property (nonatomic, copy) NSString *src;
/** 图片尺寸 */
@property (nonatomic, copy) NSString *pixel;
/** 图片所处的位置 */
@property (nonatomic, copy) NSString *ref;
@end
