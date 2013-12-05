//
//  ViewController1.h
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-3.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "BaseViewController.h"
#import "FBBannerView.h"
@interface ViewController1 : BaseViewController<UITextFieldDelegate,FBBannerViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *view_Menu;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Product;
@property (weak, nonatomic) IBOutlet UILabel *label_ProductTitle;
@property (weak, nonatomic) IBOutlet UILabel *label_ProductPriceNow;
@property (weak, nonatomic) IBOutlet PriceLabel *label_ProductPricePre;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Main;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView_Product;
@property (weak, nonatomic) IBOutlet FBPageControl *pageControl_Product;
@property (weak, nonatomic) IBOutlet UILabel *label_ProductScrollTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Hotel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_Mall;



@property (nonatomic,retain) FBBannerView		*bannerView;
@property (nonatomic,retain) NSMutableArray		*bannerArray;
@end
