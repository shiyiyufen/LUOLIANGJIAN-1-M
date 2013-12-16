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
@property (nonatomic,strong) NSDictionary *provinces,*cities,*areas;

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
		self.provinces = [[Tool shared] provinces];
    }
    return self;
}

//- (void)configureProvinces:(NSArray *)provinces
//{
//    self.provinces = provinces;
//}

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
	switch (component)
    {
        case 0:
        {
            NSArray *keys = [self.provinces allKeys];
			return [[self.provinces objectForKey:keys[row]] objectForKey:@"provincename"];
            break;
        }
        case 1:
        {
            NSString *key = [[self.provinces allKeys] objectAtIndex:[pickerView selectedRowInComponent:0]];
			NSDictionary *cities = [[self.provinces objectForKey:key] objectForKey:@"items"];
			self.cities = cities;
			NSArray *keys = [cities allKeys];
			return [[cities objectForKey:keys[row]] objectForKey:@"cityname"];
            break;
        }
        case 2:
        {
            NSString *key = [[self.cities allKeys] objectAtIndex:[pickerView selectedRowInComponent:1]];
			NSDictionary *areas = [[self.cities objectForKey:key] objectForKey:@"items"];
			self.areas = areas;
			NSArray *keys = [areas allKeys];
			return [[areas objectForKey:keys[row]] objectForKey:@"areasname"];
            break;
        }
        default:
            break;
    }
    return @"";
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	int count = 0;
	switch (component)
	{
		case 0:
		{
			self.province = [[self.provinces objectForKey:[[self.provinces allKeys] objectAtIndex:0]] objectForKey:@"provincename"];
			count = [[self provinces] count];
			break;
		}
		case 1:
		{
			NSString *key = [[self.provinces allKeys] objectAtIndex:[pickerView selectedRowInComponent:0]];
			NSDictionary *cities = [[self.provinces objectForKey:key] objectForKey:@"items"];
			if (cities.count)
			{
				self.cities = cities;
				self.city = [[cities objectForKey:[[cities allKeys] objectAtIndex:0]] objectForKey:@"cityname"];
				count = cities.count;
			}
			break;
		}
		case 2:
		{
			NSString *key = [[self.cities allKeys] objectAtIndex:[pickerView selectedRowInComponent:1]];
			NSDictionary *areas = [[self.cities objectForKey:key] objectForKey:@"items"];
			if (areas.count)
			{
				self.areas = areas;
				self.address = [[areas objectForKey:[[areas allKeys] objectAtIndex:0]] objectForKey:@"areasname"];
				count = areas.count;
				self.areaID = [[areas allKeys] objectAtIndex:0];
			}
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
    return count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (component)
    {
        case 0:
        {
            self.province = [NSString stringWithFormat:@"四川省%d",row];
			NSString *key = [[self.provinces allKeys] objectAtIndex:[pickerView selectedRowInComponent:0]];
			NSDictionary *cities = [[self.provinces objectForKey:key] objectForKey:@"items"];
			if (cities.count)
			{
				if (pickerView) [pickerView reloadComponent:1];
				[pickerView reloadComponent:2];
			}

			self.province = [[self.provinces objectForKey:[[self.provinces allKeys] objectAtIndex:row]] objectForKey:@"provincename"];
            break;
        }
        case 1:
        {
            self.city = [NSString stringWithFormat:@"南充市%d",row];
			NSString *key = [[self.cities allKeys] objectAtIndex:[pickerView selectedRowInComponent:1]];
			NSDictionary *areas = [[self.cities objectForKey:key] objectForKey:@"items"];
			if (areas.count)
			{
				if (pickerView) [pickerView reloadComponent:2];
			}
			self.city = [[self.cities objectForKey:[[self.cities allKeys] objectAtIndex:row]] objectForKey:@"cityname"];
			break;
        }
        case 2:
        {
            self.address = [NSString stringWithFormat:@"顺庆区%d",row];
			self.address = [[self.areas objectForKey:[[self.areas allKeys] objectAtIndex:row]] objectForKey:@"areasname"];
			self.areaID = [[self.areas allKeys] objectAtIndex:row];
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
