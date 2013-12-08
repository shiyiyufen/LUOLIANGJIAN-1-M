//
//  AddressPicker.m
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-8.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "AddressPicker.h"
@interface AddressPicker()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong) NSMutableDictionary *datas;
@property (nonatomic,strong) NSArray *provinces;

@property (nonatomic,strong) UIBarButtonItem *titleItem;
@property (nonatomic,strong) NSString *province,*city,*address;
@property (nonatomic,strong) NSString *areaID;
@end

@implementation AddressPicker

- (id)initAddressPicker
{
    if (self = [super initWithFrame:CGRectMake(0, 0, WIDTH, 216+44)])
    {
        self.backgroundColor = [UIColor whiteColor];
        self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(makeSure)];
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        flexItem.style = UIBarButtonSystemItemFlexibleSpace;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 21)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = SEVEN ? [UIColor blackColor] : [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:12];
        self.titleItem = [[UIBarButtonItem alloc] initWithCustomView:label];
        
        UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
        [self.toolBar setItems:@[item1,flexItem,self.titleItem,flexItem,item]];
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.toolBar.frame), WIDTH, 216)];
        self.picker.delegate = self;
        self.picker.dataSource = self;
        [self addSubview:self.toolBar];
        [self addSubview:self.picker];
        
        
        self.datas = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)configureProvinces:(NSArray *)provinces
{
    self.provinces = provinces;
}

- (void)setAddressLabel:(NSString *)address
{
    UILabel *label = (UILabel *)self.titleItem.customView;
    label.text = address;
}

- (void)makeSure
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didMakeSureWithTitle:areaID:)])
    {
        [self.delegate didMakeSureWithTitle:[NSString stringWithFormat:@"%@-%@-%@",self.province,self.city ? self.city : @"",self.address ? self.address : @""] areaID:self.areaID];
        [self cancle];
    }
}

- (void)cancle
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didCancle)])
    {
        [self.delegate didCancle];
    }
}

#pragma mark - UIPickerView
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return @"1122";
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            self.province = @"四川省0";
            break;
        }
        case 1:
        {
            self.city = @"南充市0";
            break;
        }
        case 2:
        {
            self.address = @"顺庆区0";
            break;
        }
        default:
            break;
    }
    return 5;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            self.province = [NSString stringWithFormat:@"四川省%d",row];
            break;
        }
        case 1:
        {
            self.city = [NSString stringWithFormat:@"南充市%d",row];
            break;
        }
        case 2:
        {
            self.address = [NSString stringWithFormat:@"顺庆区%d",row];
            break;
        }
        default:
            break;
    }
    NSString *text = self.province;
    if (self.city)
    {
        text = [text stringByAppendingFormat:@"-%@",self.city];
        if (self.address)
        {
            text = [text stringByAppendingFormat:@"-%@",self.address];
        }
    }
    [self setAddressLabel:text];
}




@end
