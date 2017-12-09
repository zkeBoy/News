//
//  ZKBaseNetWork.m
//  MVVM
//
//  Created by Tom on 2017/12/2.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "ZKBaseNetWork.h"

@implementation ZKBaseNetWork

+ (AFHTTPSessionManager *)shareManager {
    static AFHTTPSessionManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc] init];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain", nil];
    });
    return manager;
}

+ (id)GET:(NSString *)path para:(NSDictionary *)para progress:(void(^)(NSProgress *))progress completionHandler:(void(^)(id obj, NSError *error))completionHandler{
    return [[ZKBaseNetWork shareManager] GET:path parameters:para progress:^(NSProgress * pro){
        if (progress) {
            progress (pro);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completionHandler) {
            completionHandler (responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionHandler) {
            completionHandler (nil, error);
        }
    }];
}

+ (id)POST:(NSString *)path para:(NSDictionary *)para progress:(void(^)(NSProgress *))progress completionHandler:(void(^)(id obj, NSError *error))completionHandler{
    return [[ZKBaseNetWork shareManager] POST:path parameters:para progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completionHandler) {
            completionHandler (responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionHandler) {
            completionHandler (nil, error);
        }
    }];
}

//上传
/*
 此方法参数
 1. 要上传的[二进制数据]
 2. 对应网站上[upload.php中]处理文件的[字段"file"]
 3. 要保存在服务器上的[文件名]
 4. 上传文件的[mimeType]
 */
+ (id)POST:(NSString *)path sourceImage:(UIImage *)image para:(NSDictionary *)para progress:(void(^)(NSProgress *))progress completionHandler:(void(^)(id obj, NSError *error))completionHandler{
    return [[ZKBaseNetWork shareManager] POST:path parameters:para constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data = UIImagePNGRepresentation(image);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (completionHandler) {
            completionHandler (responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionHandler) {
            completionHandler (nil, error);
        }
    }];
}

@end
