//
//  FBPageControl.m
//  Meirenshuo
//
//  Created by Iceland on 13-10-27.
//  Copyright (c) 2013年 Iceland. All rights reserved.
//

#import "FBPageControl.h"

@implementation FBPageControl

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        activeImage = [UIImage imageNamed:@"dote_sel.png"];
        inactiveImage = [UIImage imageNamed:@"dote.png"];
    }
    return self;
}

-(void) updateDots
{
    for (int i = 0; i < [self.subviews count]; i++)
    {
        if ([[self.subviews objectAtIndex:i]isKindOfClass:[UIImageView class]])
        {
            UIImageView* dot = (UIImageView *)[self.subviews objectAtIndex:i];
            if (i == self.currentPage) dot.image = activeImage;
            else dot.image = inactiveImage;
            dot.frame = CGRectMake(dot.frame.origin.x, dot.frame.origin.y, 11.f, 11.f);
        }
    }
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    [self updateDots];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */



@end
