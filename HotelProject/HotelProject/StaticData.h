//
//  StaticData.h
//  MyHousing
//
//  Created by ZhaoJuan on 13-11-5.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#ifndef MyHousing_StaticData_h
#define MyHousing_StaticData_h
#import "AppDelegate.h"
#define NAME(X)             [UIImage imageNamed:X]
#define WIDTH               [[UIScreen mainScreen] bounds].size.width
#define HEIGHT              [[UIScreen mainScreen] bounds].size.height
#define SEVEN               IS_IOS_UPPER(@"7.0")
#define APP_DELEGATE        ((AppDelegate *)[UIApplication sharedApplication].delegate) //应用程序代理
#define IS_IPHONE5          ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IS_IOS_UPPER(x)     ([[UIDevice currentDevice].systemVersion compare:x options:NSNumericSearch] != NSOrderedAscending)
#define DOCUMENTPATH		[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define BASE_URL			@"http://guard.mi688.com/jsonsen/"
#define IMAGE_INDEX			@"IMAGE_INDEX"
#define USER_ID				@"householdId"
#define IMAGE_URL			@"imageUrl"

#import "UIViewController+Extension.h"
//#import "Tool.h"
//#import "DataHelper.h"

#endif