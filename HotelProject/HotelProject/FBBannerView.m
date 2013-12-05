//
//  FBBannerView.m
//  Chemayi
//
//  Created by Iceland on 13-10-25.
//  Copyright (c) 2013年 Iceland. All rights reserved.
//

#import "FBBannerView.h"


@interface FBBannerView ()
@property (nonatomic,retain)FBPageControl *pageCtrl;

@property (nonatomic,assign)int totalPages;
@property (nonatomic,assign)float bannerWidth;
@property (nonatomic,assign)float bannerHeight;

@end


@implementation FBBannerView

@synthesize delegate = _delegate;
@synthesize bannerWidth = _bannerWidth;
@synthesize bannerHeight = _bannerHeight;
@synthesize totalPages = _totalPages;

@synthesize imageArray = _imageArray;
@synthesize titleArray = _titleArray;
@synthesize scrollView = _scrollView;
@synthesize pageCtrl = _pageCtrl;
@synthesize currentPage = _currentPage;
@synthesize isAutoScroll = _isAutoScroll;
@synthesize timer = _timer;

- (id)initWithFrame:(CGRect)frame imageArray:(NSArray *)array titleArray:(NSArray *)strArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.totalPages = [array count];
        self.currentPage = 0;
        self.bannerWidth = frame.size.width;
        self.bannerHeight = frame.size.height;
        self.autoresizesSubviews = YES;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.autoresizesSubviews = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(frame.size.width*self.totalPages, frame.size.height);
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        
        self.imageArray = array;
        self.titleArray = strArray;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.scrollView addGestureRecognizer:singleTap];

        _pageCtrl = [[FBPageControl alloc] initWithFrame:CGRectMake(0, 0, _bannerWidth, 20)];
        self.pageCtrl.userInteractionEnabled = NO;
        self.pageCtrl.numberOfPages = array.count;
        self.pageCtrl.currentPage = 0;
        self.pageCtrl.backgroundColor = [UIColor clearColor];

        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 600, 43)];
//        self.label.textColor = [FBPublicMethod colorWithHexString:@"FEFEFE"];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.text = [strArray objectAtIndex:0];
        
        UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, _bannerHeight -20, _bannerWidth, 20)];
        coverView.backgroundColor = [UIColor colorWithRed:55/255.f green:55/255.f blue:50/255.f alpha:0.6];
//        [FBPublicMethod colorWithHexString:@"373732"]
        [coverView addSubview:_pageCtrl];
//        [coverView addSubview:self.label];
        [self addSubview:coverView];
    }
    return self;
}

- (void)dealloc
{
    [self stopAutoScrollTimer];
}

- (void)setImageArray:(NSArray *)array
{
    _imageArray = [NSArray arrayWithArray:array];
    self.totalPages = [array count];
    [self.scrollView setContentSize:CGSizeMake(self.totalPages*self.bannerWidth, self.bannerHeight)];
    for (int i=0; i<[array count]; i++)
    {
        UIImageView *imageView = (UIImageView *)[self.imageArray objectAtIndex:i];
        imageView.frame = CGRectMake(i*self.frame.size.width,0, self.frame.size.width, self.frame.size.height);
        [self.scrollView addSubview:imageView];
    }
}

#pragma mark -
#pragma mark - Function
- (void)setIsAutoScroll:(BOOL)isAuto
{
    _isAutoScroll = isAuto;
    if (_isAutoScroll) {
        //开启定时器
        [self startAutoScrollTimer];
    } else {
        [self stopAutoScrollTimer];
    }
}

#pragma mark -
#pragma mark - handleTap
-(void)handleTap:(UITapGestureRecognizer *)tap
{
    if ([_delegate respondsToSelector:@selector(didTabScrollView: AtIndex:)])
    {
        [_delegate didTabScrollView:self AtIndex:self.currentPage];
    }
}

#pragma mark -
#pragma mark - NSTimer
- (void)stopAutoScrollTimer
{
    if (nil != self.timer && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)startAutoScrollTimer
{
    [self stopAutoScrollTimer];
    if (self.totalPages > 1)
    {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f
                                                      target:self
                                                    selector:@selector(autoToNextPage)
                                                    userInfo:nil
                                                     repeats:YES];
    }
}

- (void)autoToNextPage
{
    int nextPage = (self.currentPage+1)%self.totalPages;
    [self.scrollView setContentOffset:CGPointMake(nextPage*self.frame.size.width, 0) animated:YES];
    self.label.text = [self.titleArray objectAtIndex:self.currentPage];
}

#pragma mark -
#pragma mark - scrollView Delegate && page
//计算当前是第几页
- (void)scrollViewDidScroll:(UIScrollView *)ascrollView
{
    self.currentPage = (ascrollView.contentOffset.x+self.frame.size.width/2)/self.frame.size.width;
    self.pageCtrl.currentPage = self.currentPage;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.isAutoScroll)
    {
        [self stopAutoScrollTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.label.text = [self.titleArray objectAtIndex:self.currentPage];
    if (self.isAutoScroll)
    {
        [self startAutoScrollTimer];
    }
}
@end
