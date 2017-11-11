//
//  UIView+Animation.m
//  NNews
//
//  Created by Tom on 2017/11/11.
//  Copyright © 2017年 Tom. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView (Animation)

- (void)addCATransitionAnimationWithType:(AnimationType)animation
                                duration:(float)durationTime
                        directionSubtype:(Direction)subtype{
    NSString * animationType = [self getAnimation:animation];
    NSString * subType = [self getDirection:subtype];
    CATransition * transition = [[CATransition alloc] init];
    transition.duration = durationTime;
    transition.type = animationType;
    transition.subtype = subType;
    //transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    [self.layer addAnimation:transition forKey:nil];
}

- (NSString *)getAnimation:(AnimationType)animation{
    NSString * type;
    switch (animation) {
        case ZKpageCurl:
            type = @"pageCurl";
            break;
        case ZKpageUnCurl:
            type = @"pageUnCurl";
            break;
        case ZKrippleEffect:
            type = @"rippleEffect";
            break;
        case ZKsuckEffect:
            type = @"suckEffect";
            break;
        case ZKcube:
            type = @"cube";
            break;
        case ZKoglFlip:
            type = @"oglFlip";
            break;
        case ZKcameraIrisHollowOpen:
            type = @"cameraIrisHollowOpen";
            break;
        case ZKcameraIrisHollowClose:
            type = @"cameraIrisHollowClose";
            break;
        case ZKfade:
            type = @"fade";
            break;
        case ZKmovein:
            type = @"movein";
            break;
        case ZKpush:
            type = @"push";
            break;
        default:
            break;
    }
    return type;
}

- (NSString *)getDirection:(Direction)subtype{
    NSString * direction;
    switch (subtype) {
        case ZKleft:
            direction = kCATransitionFromLeft;
            break;
        case ZKright:
            direction = kCATransitionFromRight;
            break;
        case ZKtop:
            direction = kCATransitionFromTop;
            break;
        case ZKbottom:
            direction = kCATransitionFromBottom;
            break;
        case ZKmiddle:
            direction = kCATruncationMiddle;
            break;
        default:
            break;
    }
    return direction;
}

@end
