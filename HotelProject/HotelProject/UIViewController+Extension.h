//
//  UIViewController+Extension.h
//  GuoGuo
//
//  Created by leijun on 13-7-3.
//  Copyright (c) 2013年 QuYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)
- (void)addRectVersionJudge;


@end


@interface UINavigationController(trans)
- (void)pushViewControllerRetro:(UIViewController *)viewController animated:(BOOL)animated;
- (void)popViewControllerRetroAnimated:(BOOL)animated;
@end

@implementation UINavigationController(trans)

- (void)pushViewControllerRetro:(UIViewController *)viewController animated:(BOOL)animated
{
	CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:nil];
	
    [self pushViewController:viewController animated:NO];
}

- (void)popViewControllerRetroAnimated:(BOOL)animated
{
	CATransition *transition = [CATransition animation];
    transition.duration = 0.25;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:transition forKey:nil];
	
    [self popViewControllerAnimated:NO];
}


@end