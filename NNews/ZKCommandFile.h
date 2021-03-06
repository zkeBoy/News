//
//  ZKCommandFile.h
//  NNews
//
//  Created by Tom on 2017/11/1.
//  Copyright © 2017年 Tom. All rights reserved.
//

#ifndef ZKCommandFile_h
#define ZKCommandFile_h

#define D_WIDTH  [UIScreen mainScreen].bounds.size.width
#define D_HEIGHT [UIScreen mainScreen].bounds.size.height

#define NavBarH  64
#define TabBarH  49
#define StatusH  20
#define TabFrame CGRectMake(0, NavBarH, D_WIDTH, D_HEIGHT-NavBarH-TabBarH)

#define Scale(s) (D_HEIGHT/736*s)
#define CellH    44
#define N_Cell   60

#define U_I_S    40.f //User Icon size

#define MainColor [UIColor colorWithRed:242/255.0 green:242/255.0 blue:244/255.0 alpha:1]
#define Margin 10

//app名称
#define kAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
//app版本
#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#endif /* ZKCommandFile_h */
