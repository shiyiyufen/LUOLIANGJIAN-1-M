//
//  ViewController.m
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-3.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()<UITabBarControllerDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.delegate = self;
	[self addRectVersionJudge];
	
	NSDictionary *dict=[NSDictionary dictionaryWithObjects:
                        [NSArray arrayWithObjects:
						 [UIColor whiteColor],
						 [UIFont boldSystemFontOfSize:17],
						 [UIColor clearColor],nil] forKeys:
                        [NSArray arrayWithObjects:
						 UITextAttributeTextColor,
						 UITextAttributeFont,
						 UITextAttributeTextShadowColor,nil]];
	self.navigationController.navigationBar.titleTextAttributes=dict;
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	if (![NSStringFromClass([viewController class]) isEqualToString:@"ViewController1"])
	{
		tabBarController.title = viewController.tabBarItem.title;
	}else tabBarController.title = @"";
	
}

@end
