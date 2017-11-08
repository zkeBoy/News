//
//  ZKTTVideoComment.h
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZKTTVideoUser.h"

@interface ZKTTVideoComment : NSObject
@property (nonatomic, copy)   NSString      * ID;        //评论的标识
@property (nonatomic, copy)   NSString      * voiceUrl;
@property (nonatomic, assign) NSInteger       voicetime;  /** 音频文件的时长 */
@property (nonatomic, copy)   NSString      * content;    /** 评论的文字内容 */
@property (nonatomic, assign) NSInteger       like_count; /** 被点赞的数量 */
@property (nonatomic, strong) ZKTTVideoUser * user;       /** 用户 */

@property (nonatomic, assign) CGFloat         cellHeight; //Cell 高度
@end
