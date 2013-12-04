//
//  ViewController1.m
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-3.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "ViewController1.h"

@interface ViewController1 ()
@property (nonatomic,strong) UITextField *searchTextField;
@end

@implementation ViewController1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[self reSetBannerView];
    [self configureMenuView];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[[Tool shared] createBackgroundViewForBar:self.navigationController.navigationBar type:BarViewTypeSearch target:self];
	for (UITextField *view in  self.navigationController.navigationBar.subviews)
	{
		if ([view isKindOfClass:[UITextField class]])
		{
			self.searchTextField = view;
			break;
		}
	}
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[[Tool shared] createBackgroundViewForBar:self.navigationController.navigationBar type:BarTypeDefault target:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureMenuView
{
    [self.imageView_Product setImageWithURL:[NSURL URLWithString:@"http://img2.bdstatic.com/img/image/724e4dde71190ef76c6baa1a23c9f16fdfaaf5167b1.jpg"] placeholderImage:nil];
    self.label_ProductTitle.text = @"龙凤呈祥吊坠";
    
    NSString *now = [NSString stringWithFormat:@"￥ %@",@"874"];
    CGSize size0 = [now sizeWithFont:self.label_ProductPriceNow.font constrainedToSize:CGSizeMake(MAXFLOAT, self.label_ProductPriceNow.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    self.label_ProductPriceNow.frame = (CGRect){self.label_ProductPriceNow.frame.origin,size0.width,self.label_ProductPriceNow.frame.size.height};
    self.label_ProductPriceNow.text = now;
    NSString *pre = [NSString stringWithFormat:@"￥ %@",@"1024"];
    CGSize size = [pre sizeWithFont:self.label_ProductPricePre.font constrainedToSize:CGSizeMake(MAXFLOAT, self.label_ProductPricePre.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    self.label_ProductPricePre.frame = (CGRect){CGRectGetMaxX(self.label_ProductPriceNow.frame) + SPACE_MID,self.label_ProductPricePre.frame.origin.y,size.width,self.label_ProductPricePre.frame.size.height};
    self.label_ProductPricePre.text = pre;
}

-(void)reSetBannerView
{
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
//    NSMutableArray *titleArray = [[NSMutableArray alloc] init];
	self.bannerArray = @[@"http://img.baidu.com/img/image/xqxbz.jpg",@"http://img.baidu.com/img/image/zyx.jpg",@"http://img.baidu.com/img/image/bjtj.jpg",@"http://img2.bdstatic.com/img/image/724e4dde71190ef76c6baa1a23c9f16fdfaaf5167b1.jpg"];
    for (int i=0; i<self.bannerArray.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*WIDTH, 0, WIDTH, 140)];
        [imageView setImageWithURL:[NSURL URLWithString:self.bannerArray[i]]  placeholderImage:nil];
        [imageArray addObject:imageView];
        
//        NSString *str = [[self.bannerArray objectAtIndex:i] objectForKey:@"navDesc"];
//        [titleArray addObject:str];
    }
    
    _bannerView = [[FBBannerView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 140) imageArray:imageArray titleArray:nil];
    _bannerView.isAutoScroll = YES;
    [self.view addSubview:_bannerView];
}

#pragma mark - Touch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (self.searchTextField && [self.searchTextField isFirstResponder])
	{
		[self.searchTextField resignFirstResponder];
	}
}

#pragma mark - TextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.searchTextField)
	{
		[textField resignFirstResponder];
	}
	return YES;
}

#pragma mark - didStartSearch
- (void)didStartSearch
{
	NSLog(@"MethodName:%@", NSStringFromSelector(_cmd));
}

@end
