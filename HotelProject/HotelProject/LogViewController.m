//
//  LogViewController.m
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-7.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "LogViewController.h"
#import "RegisterViewController.h"
@interface LogViewController ()<UIScrollViewDelegate,UITextFieldDelegate>

@end

@implementation LogViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addRectVersionJudge];
    self.title = @"账号登录";
    self.navigationItem.leftBarButtonItem = [[Tool shared] createBackBtn:self];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView_Main.contentSize = CGSizeMake(0, 490);
    self.scrollView_Main.delegate = self;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)action_Register:(id)sender
{
    RegisterViewController *controller = [MAIN_STORYBOARD instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.navigationController pushViewControllerRetro:controller animated:YES];
}

- (IBAction)action_Log:(id)sender
{
    
}

- (IBAction)action_Sina:(id)sender
{
    
}

- (IBAction)action_QQ:(id)sender
{
    
}

#pragma mark - Scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y;
    if (y > scrollView.contentSize.height - scrollView.bounds.size.height)
    {
        NSLog(@"waring....");
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollView.contentSize.height - scrollView.bounds.size.height);
    }
}
#pragma mark - Touch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.textField_Name isFirstResponder])[self.textField_Name resignFirstResponder];
    if ([self.textField_Pwd isFirstResponder])[self.textField_Pwd resignFirstResponder];
}

#pragma mark - TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
