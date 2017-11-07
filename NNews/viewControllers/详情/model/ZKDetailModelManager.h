//
//  ZKDetailModelManager.h
//  NNews
//
//  Created by Tom on 2017/11/7.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZKDetailModelManager : NSObject

+ (void)detailWithURLString:(NSString *)urlString
                    andPara:(NSDictionary *)para
                    success:(void(^)(id))sBlock
                    failure:(void(^)(NSError *))fBlock;

@end
