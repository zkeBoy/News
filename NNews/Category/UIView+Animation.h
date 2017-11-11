//
//  UIView+Animation.h
//  NNews
//
//  Created by Tom on 2017/11/11.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  动画类型
 */
typedef enum{
    ZKpageCurl,               // 向上翻一页
    ZKpageUnCurl,              //向下翻一页
    ZKrippleEffect,            //波纹
    ZKsuckEffect,              //吸收
    ZKcube,                    //立方体
    ZKoglFlip,                 //翻转
    ZKcameraIrisHollowOpen,    //镜头开
    ZKcameraIrisHollowClose,   //镜头关
    ZKfade,                    //淡出淡入
    ZKmovein,                  //弹出
    ZKpush                     //推出
}AnimationType;

/**
 *  动画方向
 */
typedef enum{
    ZKleft,                 //左
    ZKright,                //右
    ZKtop,                  //顶部
    ZKbottom,               //底部
    ZKmiddle
}Direction;

@interface UIView (Animation)

- (void)addCATransitionAnimationWithType:(AnimationType)animation
                                duration:(float)durationTime
                        directionSubtype:(Direction)subtype;

@end
