//
//  LogViewController.h
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-7.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *textField_Name;
@property (weak, nonatomic) IBOutlet UITextField *textField_Pwd;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Main;

- (IBAction)action_Register:(id)sender;
- (IBAction)action_Log:(id)sender;
- (IBAction)action_Sina:(id)sender;
- (IBAction)action_QQ:(id)sender;

@end
