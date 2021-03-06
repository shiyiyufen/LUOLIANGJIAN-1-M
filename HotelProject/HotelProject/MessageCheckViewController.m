//
//  MessageCheckViewController.m
//  HotelProject
//
//  Created by GameWave on 13-12-12.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "MessageCheckViewController.h"
#import "LogViewController.h"
@import MessageUI;
@interface MessageCheckViewController ()<UITextFieldDelegate>
@property (nonatomic,assign) BOOL checked,enabled;
@property (nonatomic,strong) NSString *lastKeyString;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation MessageCheckViewController
//static int leftTime = 60;
static int leftTime = 5;
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
    self.title = @"个人用户注册";
    self.navigationItem.leftBarButtonItem = [[Tool shared] createBackBtn:self];
    self.view.backgroundColor = [UIColor whiteColor];
	self.checked = NO;self.enabled = YES;
	self.label_Phone.text = self.phone;
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	if (!self.enabled)
	{
		[self startTimer];
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	if (!self.enabled)
	{
		[self stopTimer];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startTimer
{
	if (!_timer || ![_timer isValid])
	{
		_timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
	}
}

- (void)stopTimer
{
	if (!_timer || ![_timer isValid]) return;
	[_timer invalidate];
}

- (void)updateTime
{
    leftTime --;
	[self.btn_ReGet setTitle:[NSString stringWithFormat:@"%d 秒后重新获取",leftTime] forState:UIControlStateNormal];
	if (leftTime <= 0)
    {
        [self.btn_ReGet setTitle:[NSString stringWithFormat:@"重新获取验证码"] forState:UIControlStateNormal];
        [self stopTimer];
    }
}

- (IBAction)action_Register:(id)sender
{
	if (self.textField_Msg.text.length != 6)
	{
		[[Tool shared] showTip:@"请输入6位验证码"];
		return;
	}
	//check
	if ([self.lastKeyString isEqualToString:self.textField_Msg.text])
	{
		self.enabled = YES;
		self.checked = YES;
		[self.btn_ReGet setTitle:[NSString stringWithFormat:@"重新获取验证码"] forState:UIControlStateNormal];
	}
	
	if (!self.checked) return;
	[[Tool shared] showWaiting];
    [self.textField_Msg resignFirstResponder];
	if (0 == self.type)
	{
		[DataHelper getResiterWithPhone:self.phone account:self.account email:self.email pwd:self.pwd completion:^(NSDictionary *resultInfo)
		 {
			 NSLog(@"resultInfo:%@",resultInfo);
			 if (resultInfo)
			 {
				 if ([[resultInfo objectForKey:@"result"] intValue] == 1)
				 {
					 [[Tool shared] showTip:@"注册成功!"];
                     [self popToLogin];
				 }else [[Tool shared] showTip:resultInfo[@"msg"] ? resultInfo[@"msg"] : @"注册失败"];
			 }else [[Tool shared] hideTip];
		 }];
	}else
	{
		[DataHelper getResiterWithPhone:self.phone account:self.account sex:self.sex name:self.name area:self.areaID address:self.address email:self.email pwd:self.pwd completion:^(NSDictionary *resultInfo)
		 {
			 NSLog(@"resultInfo:%@",resultInfo);
			 if (resultInfo)
			 {
				 if ([[resultInfo objectForKey:@"result"] intValue] == 1)
				 {
					 [[Tool shared] showTip:@"注册成功!"];
                     [self popToLogin];
				 }else [[Tool shared] showTip:resultInfo[@"msg"] ? resultInfo[@"msg"] : @"注册失败"];
			 }else [[Tool shared] hideTip];
		 }];
	}
}

- (void)popToLogin
{
    for (UIViewController *vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass:[LogViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}

- (IBAction)action_SendMsg:(UIButton *)sender
{
	if (self.enabled)
	{
		self.enabled = NO;
		self.lastKeyString = [NSString stringWithFormat:@"%d%d%d%d%d%d",arc4random() % 10,arc4random() % 10,arc4random() % 10,arc4random() % 10,arc4random() % 10,arc4random() % 10];
		[DataHelper sendMsgForUser:MSG_NAME password:MSG_PWD mobile:self.phone content:[NSString stringWithFormat:@"尊敬的客户，您正在使用联和网【手机验证】，您的验证码是：%@【东泰联合】",self.lastKeyString] completion:^(NSDictionary *resultInfo)
		 {
			if (resultInfo && [resultInfo isKindOfClass:[NSString class]])
			{
				NSString *result = (NSString *)resultInfo;
				if (result)
					//if ([result intValue] == 0)
				{
					NSLog(@"发送成功");
					self.textField_Msg.text = self.lastKeyString;
					[self startTimer];
				}
			}
		}];
		
	}
}

- (void)showMessageView
{
	int number = rand() % 10000;
    if( [MFMessageComposeViewController canSendText] )
	{
		
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init]; //autorelease];
		
        controller.recipients = [NSArray arrayWithObject:self.label_Phone.text];
        controller.body = [NSString stringWithFormat:@"%d",number];
		
        [self presentModalViewController:controller animated:YES];
		
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"测试短信"];//修改短信界面标题
    }
}


#pragma mark - TextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
