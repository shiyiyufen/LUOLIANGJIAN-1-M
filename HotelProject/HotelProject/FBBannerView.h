//
//  FBBannerView.h
//  Chemayi
//
//  Created by Iceland on 13-10-25.
//  Copyright (c) 2013年 Iceland. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBPageControl.h"
@interface FBBannerView : UIView <UIScrollViewDelegate>
{
    id delegate;
    int currentPage;
    BOOL isAutoScroll;
    NSTimer *timer;
    UIScrollView *scrollView;
    NSArray *imageArray;
    NSArray *titleArray;
}
- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)array titleArray:(NSArray *)strArray;
- (void)setIsAutoScroll:(BOOL)isAuto;

@property (nonatomic,assign)id delegate;
@property (nonatomic,assign)int currentPage;
@property (nonatomic,assign)BOOL isAutoScroll;
@property (nonatomic,retain)UIScrollView *scrollView;
@property (nonatomic,retain)UILabel *label;

@property (nonatomic,retain)NSArray *imageArray;
@property (nonatomic,retain)NSArray *titleArray;
@property (nonatomic,retain)NSTimer *timer;

@end

@protocol FBBannerViewDelegate <NSObject>
- (void) didTabScrollView:(FBBannerView *)scr AtIndex:(int) index;
@end