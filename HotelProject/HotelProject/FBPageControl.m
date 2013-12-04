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
        activeImage = NAME(@"icon_6");
        inactiveImage = NAME(@"icon_5");
        
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
    if (SEVEN)
    {
        for (UIView *su in self.subviews) {
            [su removeFromSuperview];
        }
        [self setNeedsDisplay];
    }else [self updateDots];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
    [super setNumberOfPages:numberOfPages];
    if (SEVEN)
    {
        for (UIView *su in self.subviews) {
            [su removeFromSuperview];
        }
        [self setNeedsDisplay];
    }else [self updateDots];
}

- (void)drawRect:(CGRect)iRect
{
    int i;
    CGRect rect;
    UIImage *image;
    
    iRect = self.bounds;
    
    if (self.opaque) {
        [self.backgroundColor set];
        UIRectFill(iRect);
    }
    
    UIImage *_activeImage = activeImage;
    UIImage *_inactiveImage = inactiveImage;
    CGFloat _kSpacing = 5.0f;
    
    if (self.hidesForSinglePage && self.numberOfPages == 1) {
        return;
    }
    
    rect.size.height = _activeImage.size.height;
    rect.size.width = self.numberOfPages * _activeImage.size.width + (self.numberOfPages - 1) * _kSpacing;
    rect.origin.x = floorf((iRect.size.width - rect.size.width) / 2.0);
    rect.origin.y = floorf((iRect.size.height - rect.size.height) / 2.0);
    rect.size.width = _activeImage.size.width;
    
    for (i = 0; i < self.numberOfPages; ++i) {
        image = (i == self.currentPage) ? _activeImage : _inactiveImage;
        [image drawInRect:rect];
        rect.origin.x += _activeImage.size.width + _kSpacing;
    }
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
