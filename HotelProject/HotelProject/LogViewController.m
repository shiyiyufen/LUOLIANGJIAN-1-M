//
//  LogViewController.m
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-7.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "LogViewController.h"
#import "RegisterViewController.h"

@interface LogViewController ()<UIScrollViewDelegate,UITextFieldDelegate,TencentSessionDelegate,TencentLoginDelegate,SinaWeiboDelegate>
{
	BOOL _isLogined;
	time_t                  loginTime;
}
@property (retain, nonatomic) TencentOAuth *tencentOAuth;
@property (readonly, nonatomic) SinaWeibo *sinaWeibo;
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
	
	self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:__TencentDemoAppid_ andDelegate:self];
	
	_sinaWeibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kRedirectURI andDelegate:self];
    [self addRectVersionJudge];
    self.title = @"账号登录";
    self.navigationItem.leftBarButtonItem = [[Tool shared] createBackBtn:self];
    self.view.backgroundColor = [UIColor whiteColor];
    self.scrollView_Main.contentSize = CGSizeMake(0, 490);
    self.scrollView_Main.delegate = self;

}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (IS_IPHONE5) self.view_Bottom.center = CGPointMake(self.view_Bottom.center.x, self.view.frame.size.height - self.view_Bottom.frame.size.height / 2);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tencentDidLogin
{
    if (NO == _isLogined)
    {
        _isLogined = YES;
    }
    
	
	if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
	{
		// 记录登录用户的OpenID、Token以及过期时间
	}
	else
	{
		//@"登录不成功 没有获取accesstoken";
	}
	 NSLog(@"_tencentOAuth.accessToken:%@",_tencentOAuth.accessToken);
	 NSLog(@"_tencentOAuth.id:%@",_tencentOAuth.openId);
	
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录成功" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}

- (void)tencentDidNotLogin:(BOOL)cancelled
{
	if (cancelled)
	{
		//@"用户取消登录";
	}
	else
	{
		// @"登录失败";
	}
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"登录失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
}

- (void)tencentDidNotNetWork
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"结果" message:@"网络失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
    [alertView show];
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
    BOOL authValid = self.sinaWeibo.isAuthValid;
    
    if (!authValid)
    {
        [self.sinaWeibo logIn];
    }
}

//登陆成功后回调方法
- (void) sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
	NSLog(@"sinaweiboDidLogIn");
	 NSLog(@"id:%@",sinaweibo.userID);
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
	NSLog(@"sinaweiboDidLogOut");
}
- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
	NSLog(@"sinaweiboLogInDidCancel");
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
	NSLog(@"MethodName:%@", NSStringFromSelector(_cmd));
}
- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
	NSLog(@"MethodName:%@", NSStringFromSelector(_cmd));
}

- (IBAction)action_QQ:(id)sender
{
	//    NSArray* permissions = [NSArray arrayWithObjects:
	//                     kOPEN_PERMISSION_GET_USER_INFO,
	//                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
	//                     kOPEN_PERMISSION_ADD_ALBUM,
	//                     kOPEN_PERMISSION_ADD_IDOL,
	//                     kOPEN_PERMISSION_ADD_ONE_BLOG,
	//                     kOPEN_PERMISSION_ADD_PIC_T,
	//                     kOPEN_PERMISSION_ADD_SHARE,
	//                     kOPEN_PERMISSION_ADD_TOPIC,
	//                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
	//                     kOPEN_PERMISSION_DEL_IDOL,
	//                     kOPEN_PERMISSION_DEL_T,
	//                     kOPEN_PERMISSION_GET_FANSLIST,
	//                     kOPEN_PERMISSION_GET_IDOLLIST,
	//                     kOPEN_PERMISSION_GET_INFO,
	//                     kOPEN_PERMISSION_GET_OTHER_INFO,
	//                     kOPEN_PERMISSION_GET_REPOST_LIST,
	//                     kOPEN_PERMISSION_LIST_ALBUM,
	//                     kOPEN_PERMISSION_UPLOAD_PIC,
	//                     kOPEN_PERMISSION_GET_VIP_INFO,
	//                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
	//                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
	//                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
	//                     nil];
	time_t currentTime;
	time(&currentTime);
	
	if ((currentTime - loginTime) > 2)
	{
		NSArray *permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_USER_INFO, nil];
		[self.tencentOAuth authorize:permissions inSafari:NO];
		
		loginTime = currentTime;
	}
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
