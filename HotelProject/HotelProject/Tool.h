//
//  Tool.h
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-3.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum BarViewType
{
    BarTypeDefault,
    BarViewTypeSearch
}BarType;

@interface Tool : NSObject
+ (Tool *)shared;

- (void)createBackgroundViewForBar:(UINavigationBar *)navigationBar type:(BarType)type;

- (void)hideTip;
- (void)showWaiting;
- (void)hideTipForView:(UIView *)view;
- (void)showWaiting:(NSString *)msg forView:(UIView *)view;
- (void)showTip:(NSString *)msg;
- (UIBarButtonItem *)createBackBtn:(id)target;

- (NSString *)YMDstringFromDate:(NSDate *)date;
- (NSDate *)dateFromString:(NSString *)date;
@end