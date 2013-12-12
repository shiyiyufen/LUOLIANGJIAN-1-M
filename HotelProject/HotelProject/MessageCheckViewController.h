//
//  MessageCheckViewController.h
//  HotelProject
//
//  Created by GameWave on 13-12-12.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageCheckViewController : BaseViewController
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *account;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *areaID;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *pwd;
//type : 0	快速注册
//1:		完整注册
@property (nonatomic,assign) int type;

@property (weak, nonatomic) IBOutlet UILabel *label_Phone;
@property (weak, nonatomic) IBOutlet UITextField *textField_Msg;
@property (weak, nonatomic) IBOutlet UIButton *btn_ReGet;

- (IBAction)action_Register:(id)sender;
@end
