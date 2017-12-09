//
//  ZKBaseNetWork.h
//  MVVM
//
//  Created by Tom on 2017/12/2.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface ZKBaseNetWork : NSObject
+ (AFHTTPSessionManager *)shareManager;

+ (id)GET:(NSString *)path para:(NSDictionary *)para progress:(void(^)(NSProgress *))progress completionHandler:(void(^)(id obj, NSError *error))completionHandler;

+ (id)POST:(NSString *)path para:(NSDictionary *)para progress:(void(^)(NSProgress *))progress completionHandler:(void(^)(id obj, NSError *error))completionHandler;

+ (id)POST:(NSString *)path sourceImage:(UIImage *)image para:(NSDictionary *)para progress:(void(^)(NSProgress *))progress completionHandler:(void(^)(id obj, NSError *error))completionHandler;

@end
