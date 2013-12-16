//
//  RegisterViewController.m
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-7.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "RegisterViewController.h"
#import "AddressPicker.h"
#import "MessageCheckViewController.h"
@interface RegisterViewController ()<AddressPickerDelegate>
{
	UITextField *lastField;
}

@property (nonatomic,strong) NSString *sexString;
@property (nonatomic,strong) NSString *areaID;


@end

@implementation RegisterViewController

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
    self.btn_Register1.selected = YES;
    self.btn_Register2.selected = NO;
    
    self.imageView_Male.image = NAME(@"icon_30_1");
    self.imageView_Female.image = NAME(@"icon_30");
    self.sexString = @"0";
    self.scrollView_Right.contentSize = CGSizeMake(0, 550);
    
    
    self.textField_Name.delegate = self;
    self.textField_Account1.delegate = self;
    self.textField_Account2.delegate = self;
    
    AddressPicker *pickerView = [[AddressPicker alloc] initAddressPicker];
    pickerView.delegate = self;
    self.textField_Address.inputView = pickerView;
	self.textField_Address.delegate = self;
    self.textField_DetailAddress.delegate = self;
    self.textField_Email1.delegate = self;
    self.textField_Email2.delegate = self;
    self.textField_Phone1.delegate = self;
    self.textField_Phone2.delegate = self;
    self.textField_Pwd1.delegate = self;
    self.textField_Pwd2.delegate = self;
    self.textField_PwdAgain1.delegate = self;
    self.textField_PwdAgain2.delegate = self;
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)action_RegisterFast:(id)sender
{
    int offset = self.scrollView_Main.contentOffset.x;
    if (offset != 0)
    {
        [self.scrollView_Main setContentOffset:CGPointMake(0, 0) animated:YES];
        self.btn_Register1.selected = YES;
        self.btn_Register2.selected = NO;
		if (lastField) [lastField resignFirstResponder];
		self.scrollView_Right.contentSize = CGSizeMake(0, 500);
    }
}

- (IBAction)action_RegisterFull:(id)sender
{
    int offset = self.scrollView_Main.contentOffset.x;
    if (offset == 0)
    {
        [self.scrollView_Main setContentOffset:CGPointMake(self.scrollView_Main.bounds.size.width, 0) animated:YES];
        self.btn_Register2.selected = YES;
        self.btn_Register1.selected = NO;
        if (lastField) [lastField resignFirstResponder];
		self.scrollView_left.contentSize = CGSizeMake(0, 300);
    }
}

- (IBAction)action_Address:(id)sender
{
    
}

- (IBAction)action_TouchSex:(UIButton *)sender
{
    if ([sender tag])//女
    {
        self.imageView_Male.image = NAME(@"icon_30");
        self.imageView_Female.image = NAME(@"icon_30_1");
        self.sexString = @"1";
    }else
    {
        self.imageView_Male.image = NAME(@"icon_30_1");
        self.imageView_Female.image = NAME(@"icon_30");
        self.sexString = @"0";
    }
}

- (IBAction)action_Next:(UIButton *)sender
{
     NSLog(@"tag:%d",[sender tag]);
    if ([sender tag] == 0)//快速注册
    {
        NSString *phone = self.textField_Phone1.text;
        if (0 == phone.length)
        {
            [[Tool shared] showTip:@"请输入您的手机号码"];
            return;
        }
        NSString *account = self.textField_Account1.text;
        if (0 == account.length)
        {
            [[Tool shared] showTip:@"请输入您的注册账号"];
            return;
        }
		[[Tool shared] showWaiting];
		[DataHelper getCheckAccountWithAccount:account completion:^(NSDictionary *resultInfo)
		{
			
			if (resultInfo)
			{
				if ([[resultInfo objectForKey:@"result"] intValue] == 1)//已经注册
				{
					[[Tool shared] showTip:@"该账号已经被注册"];
				}else
				{
					NSString *email = self.textField_Email1.text;
					if (0 == email.length)
					{
						[[Tool shared] showTip:@"请输入您的邮箱"];
						return;
					}
					NSString *pwd = self.textField_Pwd1.text;
					if (0 == pwd.length)
					{
						[[Tool shared] showTip:@"请输入您的密码"];
						return;
					}
					NSString *pwd2 = self.textField_PwdAgain1.text;
					if (0 == pwd2.length)
					{
						[[Tool shared] showTip:@"请再次输入您的密码"];
						return;
					}
					if (![pwd isEqualToString:pwd2])
					{
						[[Tool shared] showTip:@"两次输入的密码不一致"];
						return;
					}
					[[Tool shared] hideTip];
					UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
					MessageCheckViewController *controller = [main instantiateViewControllerWithIdentifier:@"MessageCheckViewController"];
					controller.phone = phone;
					controller.sex = self.sexString;
					controller.pwd = pwd;
					controller.email = email;
					[controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
					[self.navigationController pushViewControllerRetro:controller animated:YES];
				}
			}else [[Tool shared] hideTip];
		}];
        
    }else
    {
        NSString *phone = self.textField_Phone2.text;
        if (0 == phone.length)
        {
            [[Tool shared] showTip:@"请输入您的手机号码"];
            return;
        }
        NSString *account = self.textField_Account2.text;
        if (0 == account.length)
        {
            [[Tool shared] showTip:@"请输入您的注册账号"];
            return;
        }
		[[Tool shared] showWaiting];
		[DataHelper getCheckAccountWithAccount:account completion:^(NSDictionary *resultInfo)
		 {
			 [[Tool shared] hideTip];
			 if (resultInfo)
			 {
				 if ([[resultInfo objectForKey:@"result"] intValue] == 1)//已经注册
				 {
					 [[Tool shared] showTip:@"注册账号已经被注册"];
				 }else
				 {
					 NSString *name = self.textField_Name.text;
					 if (0 == name.length)
					 {
						 [[Tool shared] showTip:@"请输入您的姓名"];
						 return;
					 }
					 if (self.areaID == nil)
					 {
						 [[Tool shared] showTip:@"请选择地区"];
						 return;
					 }
					 NSString *address = self.textField_Address.text;
					 if (0 == address.length)
					 {
						 [[Tool shared] showTip:@"请输入您的地址"];
						 return;
					 }
					 NSString *email = self.textField_Email2.text;
					 if (0 == email.length)
					 {
						 [[Tool shared] showTip:@"请输入您的邮箱"];
						 return;
					 }
					 NSString *pwd = self.textField_Pwd2.text;
					 if (0 == pwd.length)
					 {
						 [[Tool shared] showTip:@"请输入您的密码"];
						 return;
					 }
					 NSString *pwd2 = self.textField_PwdAgain2.text;
					 if (0 == pwd2.length)
					 {
						 [[Tool shared] showTip:@"请再次输入您的密码"];
						 return;
					 }
					 if (![pwd isEqualToString:pwd2])
					 {
						 [[Tool shared] showTip:@"两次输入的密码不一致"];
						 return;
					 }
					 
					 UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
					 MessageCheckViewController *controller = [main instantiateViewControllerWithIdentifier:@"MessageCheckViewController"];
					 controller.phone = phone;
					 controller.name = name;
					 controller.sex = self.sexString;
					 controller.address = address;
					 controller.areaID = self.areaID;
					 controller.pwd = pwd;
					 controller.email = email;
					 [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
					 [self.navigationController pushViewControllerRetro:controller animated:YES];
				 }
			 }
			 
		 }];
        
    }
}

#pragma mark - TextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	lastField = textField;
	if ([self.btn_Register2 isSelected])
	{
		self.scrollView_Right.contentSize = CGSizeMake(0, 660);
	}else
	{
		self.scrollView_left.contentSize = CGSizeMake(0, 500);
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
	if ([self.btn_Register2 isSelected])
	{
		self.scrollView_Right.contentSize = CGSizeMake(0, 500);
	}else
	{
		self.scrollView_left.contentSize = CGSizeMake(0, 300);
	}
    return YES;
}

#pragma mark - AddressPicker
- (void)didMakeSureWithTitle:(NSString *)title areaID:(NSString *)areaID
{
    self.textField_Address.text = title;
    self.areaID = areaID;
}

- (void)didCancle
{
    [self.textField_Address resignFirstResponder];
}
@end
