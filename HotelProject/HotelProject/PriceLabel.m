//
//  PriceLabel.m
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-5.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "PriceLabel.h"

@implementation PriceLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
	CGContextFillRect(context, rect);
	
	CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    //	if (SEVEN) CGContextStrokeRect(context, CGRectMake(LINE_SPACE_MID + IMG_SIZE_AVTAR.width + LINE_SPACE_MID, rect.size.height, rect.size.width - LINE_SPACE_MID - IMG_SIZE_AVTAR.width - LINE_SPACE_MID, 0.5));
    //	else
    CGContextStrokeRect(context, CGRectMake(0, rect.size.height/2, rect.size.width , 0.5));
}


@end
