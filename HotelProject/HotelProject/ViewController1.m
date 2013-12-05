//
//  ViewController1.m
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-3.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "ViewController1.h"


@implementation HighLightBtn

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted)
    {
        self.backgroundColor = [UIColor lightGrayColor];
        
    }else self.backgroundColor = [UIColor clearColor];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didHighLightBtn:)])
    {
        [self.delegate didHighLightBtn:highlighted];
    }
}

@end

@interface ProductViewForScroll : UIView
- (id)initProductViewForScrollWithOrginX:(CGFloat)x;
- (void)configureViewWithUrls:(NSString *)url1 :(NSString *)url2 :(NSString *)url3;
@property (nonatomic,strong) NSString *url1,*url2,*url3;
@end

@interface ProductViewForScroll()
@property (nonatomic,strong) UIImageView *imageView_Left;
@property (nonatomic,strong) UIImageView *imageView_Top;
@property (nonatomic,strong) UIImageView *imageView_Bottom;
@end

@implementation ProductViewForScroll

- (id)initProductViewForScrollWithOrginX:(CGFloat)x
{
	if (self = [super initWithFrame:CGRectMake(x, 0, WIDTH - SPACE_MID * 2, 190)])
	{
		self.backgroundColor = [UIColor clearColor];
		
		self.imageView_Left = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 190, 190)];
		self.imageView_Top = [[UIImageView alloc] initWithFrame:CGRectMake(190 + SPACE_MID, 0, 90, 90)];
		self.imageView_Bottom = [[UIImageView alloc] initWithFrame:CGRectMake(190 + SPACE_MID, CGRectGetMaxY(self.imageView_Top.frame) + SPACE_MID, 90, 90)];
		[self addSubview:self.imageView_Left];
		[self addSubview:self.imageView_Top];
		[self addSubview:self.imageView_Bottom];
	}
	return self;
}

- (void)configureViewWithUrls:(NSString *)url1 :(NSString *)url2 :(NSString *)url3
{
	[self.imageView_Left setImageWithURL:[NSURL URLWithString:url1] placeholderImage:nil];
	[self.imageView_Top setImageWithURL:[NSURL URLWithString:url2] placeholderImage:nil];
	[self.imageView_Bottom setImageWithURL:[NSURL URLWithString:url3] placeholderImage:nil];
}

@end


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
	[self configureProductScroll];
	[self configureHotelOrder];
	[self configureMall];
	self.scrollView_Main.contentSize = CGSizeMake(0, 1140);
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
    self.btn_HighLight.delegate = self;
    NSString *now = [NSString stringWithFormat:@"￥ %@",@"874"];
    CGSize size0 = [now sizeWithFont:self.label_ProductPriceNow.font constrainedToSize:CGSizeMake(MAXFLOAT, self.label_ProductPriceNow.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    self.label_ProductPriceNow.frame = (CGRect){self.label_ProductPriceNow.frame.origin,size0.width,self.label_ProductPriceNow.frame.size.height};
    self.label_ProductPriceNow.text = now;
    NSString *pre = [NSString stringWithFormat:@"￥ %@",@"1024"];
    CGSize size = [pre sizeWithFont:self.label_ProductPricePre.font constrainedToSize:CGSizeMake(MAXFLOAT, self.label_ProductPricePre.bounds.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    self.label_ProductPricePre.frame = (CGRect){CGRectGetMaxX(self.label_ProductPriceNow.frame) + SPACE_MID,self.label_ProductPricePre.frame.origin.y,size.width,self.label_ProductPricePre.frame.size.height};
    self.label_ProductPricePre.text = pre;
}

- (void)configureProductScroll
{
	NSArray *products = @[@"",@"",@"",@"",@""];
	for (int i = 0; i < products.count; i ++)
	{
		ProductViewForScroll *view = [[ProductViewForScroll alloc] initProductViewForScrollWithOrginX:i * 290];
		[view configureViewWithUrls:@"http://img1.bdstatic.com/img/image/5141f178a82b9014a9077f9f2b3ab773912b21beefd.jpg" :@"http://img.baidu.com/img/image/sy.jpg" :@"http://img1.bdstatic.com/img/image/23754fbb2fb43166d228e36559d442309f79052d272.jpg"];
		[self.scrollView_Product addSubview:view];
	}
	self.scrollView_Product.contentSize = CGSizeMake(self.scrollView_Product.bounds.size.width * products.count, 0);
	self.pageControl_Product.numberOfPages = products.count;
    self.pageControl_Product.type = 1;
}

- (void)configureHotelOrder
{
	[self.imageView_Hotel setImageWithURL:[NSURL URLWithString:@"http://img3.yododo.com/files/forum/2011-08-09/0131AD8F46BD1653FF80808131AAFC98.jpg"] placeholderImage:nil];
}

- (void)configureMall
{
	[self.imageView_Mall setImageWithURL:[NSURL URLWithString:@"http://www.brjt.cn/UpLoadFiles/chaoshi/2012-4/2012042509545393233.jpg"] placeholderImage:nil];
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
    [self.scrollView_Main addSubview:_bannerView];
}

- (IBAction)touchItem:(UIButton *)sender
{
     NSLog(@"tag:%d",[sender tag]);
}


#pragma mark - HighLight
- (void)didHighLightBtn:(BOOL)highlight
{
    self.imageView_Sharp.image = highlight ? NAME(@"icon_7_1") : NAME(@"icon_7");
}

#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = (scrollView.contentOffset.x+scrollView.frame.size.width/2)/scrollView.frame.size.width;
    self.pageControl_Product.currentPage = page;
	self.label_ProductScrollTitle.text = [NSString stringWithFormat:@"产品类型：%d",page];
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
