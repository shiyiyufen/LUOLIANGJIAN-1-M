//
//  MessageCheckViewController.m
//  HotelProject
//
//  Created by GameWave on 13-12-12.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "MessageCheckViewController.h"

@interface MessageCheckViewController ()
@property (nonatomic,assign) BOOL checked;
@end

@implementation MessageCheckViewController

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
	self.checked = NO;
	self.label_Phone.text = self.phone;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action_Register:(id)sender
{
	if (!self.checked) return;
	[[Tool shared] showWaiting];
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
				 }else [[Tool shared] showTip:resultInfo[@"msg"] ? resultInfo[@"msg"] : @"注册失败"];
			 }else [[Tool shared] hideTip];
		 }];
	}
}
@end
