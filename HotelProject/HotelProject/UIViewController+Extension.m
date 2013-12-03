//
//  UIViewController+Extension.m
//  GuoGuo
//
//  Created by leijun on 13-7-3.
//  Copyright (c) 2013年 QuYou. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (void)back
{
	[self.navigationController popViewControllerRetroAnimated:YES];
}

- (void)addRectVersionJudge
{
	if (IS_IOS_UPPER(@"7.0"))
	{
		self.edgesForExtendedLayout = UIRectEdgeNone;
	}
}

@end