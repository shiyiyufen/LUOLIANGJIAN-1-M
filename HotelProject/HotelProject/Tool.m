//
//  Tool.m
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-3.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "Tool.h"
#import "MBProgressHUD.h"
@implementation Tool
static Tool *__tool = nil;
static const int navBarViewTag = 100;
+ (Tool *)shared
{
	if (!__tool)
	{
		__tool = [[Tool alloc] init];
	}
	return __tool;
}


- (void)createBackgroundViewForBar:(UINavigationBar *)navigationBar type:(BarType)type
{
    switch (type)
    {
        case BarTypeDefault:
        {
            UIView *view = [navigationBar viewWithTag:navBarViewTag];
            if (view) [view removeFromSuperview];
            break;
        }
        case BarViewTypeSearch:
        {
            break;
        }
        default:
            break;
    }
}

- (void)hideTip
{
	[MBProgressHUD hideHUDForView:APP_DELEGATE.window animated:YES];
}

- (void)showWaiting
{
	//初始化进度框，置于当前的View当中
	MBProgressHUD *HUD = [MBProgressHUD HUDForView:APP_DELEGATE.window];
    if (HUD) [MBProgressHUD hideHUDForView:APP_DELEGATE.window animated:YES];
	HUD = [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window
								   text:@"请稍候..."
						showImmediately:YES];
}

- (void)hideTipForView:(UIView *)view
{
    MBProgressHUD *HUD = [MBProgressHUD HUDForView:view];
    if (!HUD) return;
    [MBProgressHUD hideHUDForView:view animated:YES];
}

- (void)showWaiting:(NSString *)msg forView:(UIView *)view
{
    //初始化进度框，置于当前的View当中
	MBProgressHUD *HUD = [MBProgressHUD HUDForView:view];
    if (HUD) [MBProgressHUD hideHUDForView:view animated:YES];
	HUD = [MBProgressHUD showHUDAddedTo:view
								   text:msg
						showImmediately:YES];
}

- (void)showTip:(NSString *)msg
{
    if (msg.length == 0) return;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:APP_DELEGATE.window];
    if (!hud)
        hud = [MBProgressHUD showHUDAddedTo:APP_DELEGATE.window
                                       text:msg
                            showImmediately:YES];
    else
        hud.labelText = msg;
    
	hud.isFinished = NO;
    hud.labelFont = [UIFont systemFontOfSize:14];
    hud.mode = MBProgressHUDModeText;
    hud.userInteractionEnabled = NO;
    hud.margin = 10.f;
    hud.yOffset = 130;
    
    [hud hide:YES afterDelay:2];
}

- (UIBarButtonItem *)createBackBtn:(id)target
{
	UIImage *backBg = [UIImage imageNamed: @"icon_back"];
	UIImage *backPressBg = [UIImage imageNamed:@"icon_back_1"];
	
	//	CGSize btnSize = backBg.size;
	
	UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 27)];
	[backBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
	[backBtn setTitle:NSLocalizedString(@"txt-fh", nil) forState:UIControlStateNormal];
	[backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[backBtn setBackgroundImage:backBg forState:UIControlStateNormal];
	[backBtn setBackgroundImage:backPressBg forState:UIControlStateHighlighted];
    //	if (SEVEN) [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    //	else [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -13, 0, 0)];
	[backBtn addTarget:target action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
	
	return [[UIBarButtonItem alloc] initWithCustomView:backBtn];
}


- (NSDate *)dateFromString:(NSString *)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
	[formatter setCalendar:[NSCalendar currentCalendar]];
	return [formatter dateFromString:date];
}

- (NSString *)YMDstringFromDate:(NSDate *)date
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"yyyy-MM-dd"];
	[formatter setCalendar:[NSCalendar currentCalendar]];
	return [formatter stringFromDate:date];
}
@end