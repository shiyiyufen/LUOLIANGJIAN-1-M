//
//  RegisterViewController.h
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-7.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btn_Register1;
@property (weak, nonatomic) IBOutlet UIButton *btn_Register2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Main;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Right;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_left;

@property (weak, nonatomic) IBOutlet UITextField *textField_Phone1;
@property (weak, nonatomic) IBOutlet UITextField *textField_Account1;
@property (weak, nonatomic) IBOutlet UITextField *textField_Email1;
@property (weak, nonatomic) IBOutlet UITextField *textField_Pwd1;
@property (weak, nonatomic) IBOutlet UITextField *textField_PwdAgain1;

@property (weak, nonatomic) IBOutlet UITextField *textField_Phone2;
@property (weak, nonatomic) IBOutlet UITextField *textField_Account2;
@property (weak, nonatomic) IBOutlet UITextField *textField_Name;
@property (weak, nonatomic) IBOutlet UITextField *textField_Address;
@property (weak, nonatomic) IBOutlet UITextField *textField_Email2;
@property (weak, nonatomic) IBOutlet UITextField *textField_Pwd2;
@property (weak, nonatomic) IBOutlet UITextField *textField_PwdAgain2;
@property (weak, nonatomic) IBOutlet UITextField *textField_DetailAddress;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_Male;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Female;

- (IBAction)action_RegisterFast:(id)sender;
- (IBAction)action_RegisterFull:(id)sender;

- (IBAction)action_Address:(id)sender;
- (IBAction)action_TouchSex:(id)sender;
- (IBAction)action_Next:(id)sender;
@end
