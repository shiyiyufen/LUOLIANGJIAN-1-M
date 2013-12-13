//
//  AddressPicker.h
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-8.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddressPickerDelegate;
@interface AddressPicker : UIView

@property (nonatomic,assign) id <AddressPickerDelegate> delegate;
@property (nonatomic,strong) UIPickerView *picker;
@property (nonatomic,strong) UIToolbar *toolBar;


- (id)initAddressPicker;
//- (void)configureProvinces:(NSArray *)provinces;
@end

@protocol AddressPickerDelegate<NSObject>
- (void)didMakeSureWithTitle:(NSString *)title areaID:(NSString *)areaID;

- (void)didCancle;
@end