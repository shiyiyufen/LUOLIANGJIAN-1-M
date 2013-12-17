//
//  Tool.m
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-3.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "Tool.h"
#import "MBProgressHUD.h"
#define USER_ID @"USER_ID"
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

- (NSString *)userID
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:USER_ID];
}

- (void)saveUser:(NSString *)userID
{
    if (USER_ID.length == 0) return;
    NSUserDefaults *stands = [NSUserDefaults standardUserDefaults];
    [stands setObject:userID forKey:USER_ID];
    [stands synchronize];
}

- (void)saveProvinces:(NSArray *)provinces
{
	NSMutableDictionary *items = [NSMutableDictionary dictionary];
	for (NSDictionary *dic in provinces)
	{
		NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:dic[@"provincename"],@"provincename", nil];
		[items setObject:item forKey:dic[@"provinceid"]];
	}
	
	NSString *path = [DOCUMENTPATH stringByAppendingPathComponent:@"address.plist"];
	[items writeToFile:path atomically:YES];
}

- (NSDictionary *)provinces
{
	NSString *path = [DOCUMENTPATH stringByAppendingPathComponent:@"address.plist"];
	NSDictionary *array = [NSDictionary dictionaryWithContentsOfFile:path];
	return array;
}

- (void)saveCity:(NSArray *)cities forProvince:(NSString *)provinceId
{
	NSMutableDictionary *provinces = [NSMutableDictionary dictionaryWithDictionary:[self provinces]];
	if (!provinces) return;
	if (!provinceId) return;
	if (!cities) return;
	NSMutableDictionary *province = [NSMutableDictionary dictionaryWithDictionary:[provinces objectForKey:provinceId]];
	
	if (![province objectForKey:@"items"])
	{
		NSMutableDictionary *items = [NSMutableDictionary dictionary];
		for (NSDictionary *dic in cities)
		{
			NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:dic[@"cityname"],@"cityname", nil];
			[items setObject:item forKey:dic[@"cityid"]];
		}
		
		[province setObject:items forKey:@"items"];
		[provinces setObject:province forKey:provinceId];
		
		NSString *path = [DOCUMENTPATH stringByAppendingPathComponent:@"address.plist"];
		[provinces writeToFile:path atomically:YES];
	}
}

- (void)saveArea:(NSArray *)areas forCity:(NSString *)cityId province:(NSString *)provinceId
{
	NSMutableDictionary *provinces = [NSMutableDictionary dictionaryWithDictionary:[self provinces]];
	if (!provinces) return;
	if (!cityId) return;
	if (!areas) return;
	NSMutableDictionary *province = [NSMutableDictionary dictionaryWithDictionary:[provinces objectForKey:provinceId]];
	if ([province objectForKey:@"items"])
	{
		NSMutableDictionary *cities = [province objectForKey:@"items"];
		NSMutableDictionary *city = [NSMutableDictionary dictionaryWithDictionary:[cities objectForKey:cityId]];
		if (![city objectForKey:@"items"])
		{
			NSMutableDictionary *items = [NSMutableDictionary dictionary];
			for (NSDictionary *dic in areas)
			{
				NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:dic[@"areasname"],@"areasname", nil];
				[items setObject:item forKey:dic[@"areasid"]];
			}
			[city setObject:items forKey:@"items"];
			[cities setObject:city forKey:cityId];
			[province setObject:cities forKey:@"items"];
			[provinces setObject:province forKey:provinceId];
			NSString *path = [DOCUMENTPATH stringByAppendingPathComponent:@"address.plist"];
			[provinces writeToFile:path atomically:YES];
		}
	}
}

- (void)createBackgroundViewForBar:(UINavigationBar *)navigationBar type:(BarType)type target:(id)target
{
    switch (type)
    {
        case BarTypeDefault:
        {
			for (UIView *view in navigationBar.subviews)
			{
				if (view.tag == navBarViewTag)
				{
					[view removeFromSuperview];
				}
			}
            break;
        }
        case BarViewTypeSearch:
        {
			UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(5, (44-25)/2, 64, 25)];
			img.image = NAME(@"icon_2");
			[img setTag:navBarViewTag];
			[navigationBar addSubview:img];
			
			UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
			btn.frame = CGRectMake(WIDTH - 10 - 40, (44-25)/2, 40, 25);
			[btn setBackgroundImage:NAME(@"icon_3") forState:UIControlStateNormal];
			[btn setBackgroundImage:NAME(@"icon_3_1") forState:UIControlStateHighlighted];
			if (target) [btn addTarget:target action:@selector(didStartSearch) forControlEvents:UIControlEventTouchUpInside];
			[btn setTag:navBarViewTag];
			[navigationBar addSubview:btn];
			
			UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 160, 25)];
			textField.borderStyle = UITextBorderStyleRoundedRect;
			textField.layer.masksToBounds = YES;
			textField.layer.cornerRadius = 12.5f;
			textField.returnKeyType = UIReturnKeyDone;
			textField.delegate = target;
			textField.font = [UIFont systemFontOfSize:12];
			textField.clearButtonMode = UITextFieldViewModeWhileEditing;
			[textField setCenter:CGPointMake(navigationBar.bounds.size.width/2 + 10, navigationBar.bounds.size.height/2)];
			[textField setTag:navBarViewTag];
			[navigationBar addSubview:textField];
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
	
	UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 37)];
	[backBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//	[backBtn setTitle:NSLocalizedString(@"txt-fh", nil) forState:UIControlStateNormal];
	[backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[backBtn setImage:backBg forState:UIControlStateNormal];
	[backBtn setImage:backPressBg forState:UIControlStateHighlighted];
    //	if (SEVEN) [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    //	else [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -13, 0, 0)];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(8, 5, 8, 12)];
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
