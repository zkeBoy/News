//
//  ZKPictureModel.h
//  ZKSport
//
//  Created by Tom on 2017/11/23.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKPictureModel : NSObject
@property (nonatomic, copy) NSString * postid;
@property (nonatomic, copy) NSString * series;
@property (nonatomic, copy) NSString * clientadurl;
@property (nonatomic, copy) NSString * desc;
@property (nonatomic, copy) NSString * datatime;
@property (nonatomic, copy) NSString * createdate;
@property (nonatomic, copy) NSString * relatedids;
@property (nonatomic, copy) NSString * scover;
@property (nonatomic, copy) NSString * autoid;
@property (nonatomic, copy) NSString * url;
@property (nonatomic, copy) NSString * creator;
@property (nonatomic, copy) NSString * reporter;
@property (nonatomic, strong) NSArray * photos;

@end
