//
//  DataHelper.m
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-7.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import "DataHelper.h"
#import "LH_ConnectPool.h"


@implementation DataHelper

+ (void)getResiterWithPhone:(NSString *)phone account:(NSString *)account email:(NSString *)email pwd:(NSString *)pwd completion:(void(^)(NSDictionary *resultInfo))handler
{
    NSString *url = [NSString stringWithFormat:@"%@personRigister!addPersonInfo.do?person_tel=%@&person_account=%@&person_email=%@&person_pwd=%@",BASE_URL,phone,account,email,pwd];
    [[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url handlerDic:^(NSDictionary *dictionary, NSString *message, int error) {
        if (error == LH_RequesterrorNone)
        {
            handler(dictionary);
        }else handler(nil);
    }];
}

+ (void)getResiterWithPhone:(NSString *)phone account:(NSString *)account sex:(NSString *)sex name:(NSString *)name area:(NSString *)areaID address:(NSString *)address email:(NSString *)email pwd:(NSString *)pwd completion:(void(^)(NSDictionary *resultInfo))handler
{
    NSString *url = [NSString stringWithFormat:@"%@personRigister!addPersonInfo.do?person_tel=%@&person_account=%@&person_email=%@&person_pwd=%@&person_sex=%@&person_name=%@&person_adress=%@&person_adressdetail=%@",BASE_URL,phone,account,email,pwd,sex,name,areaID,address];
    [[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url handlerDic:^(NSDictionary *dictionary, NSString *message, int error) {
        if (error == LH_RequesterrorNone)
        {
            handler(dictionary);
        }else handler(nil);
    }];
}
//820000
+ (void)getProvincesWithCompletion:(void(^)(NSArray *provinces))handler
{
    NSString *url = [NSString stringWithFormat:@"%@findAddress!getProvinces.do",BASE_URL];
	[[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url handlerDic:^(NSDictionary *objects, NSString *message, int error)
     {
         if (error == LH_RequesterrorNone)
         {
			 if (objects && [objects isKindOfClass:[NSDictionary class]])
			 {
				 NSArray *items = [objects objectForKey:@"pro"];
				 if ([items isKindOfClass:[NSArray class]])
				 {
					 handler(items);
				 }else handler(nil);
			 }else handler(nil);
         }else handler(nil);
     }];
}

+ (void)getCitiesWithProvince:(NSString *)provinceID completion:(void(^)(NSArray *cities))handler
{
    NSString *url = [NSString stringWithFormat:@"%@findAddress!getCitys.do?provinceid=%@",BASE_URL,provinceID];
	[[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url handlerDic:^(NSDictionary *dataArray, NSString *message, int error)
     {
         if (error == LH_RequesterrorNone)
         {
			 if (dataArray && [dataArray isKindOfClass:[NSDictionary class]])
			 {
				 NSArray *items = [dataArray objectForKey:@"city"];
				 if ([items isKindOfClass:[NSArray class]])
				 {
					 handler(items);
				 }else handler(nil);
			 }else handler(nil);
         }else handler(nil);
     }];
}

+ (void)getAreasWithCityID:(NSString *)cityID completion:(void(^)(NSArray *datas))handler
{
    NSString *url = [NSString stringWithFormat:@"%@findAddress!getAreas.do?cityid=%@",BASE_URL,cityID];
	[[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url handlerDic:^(NSDictionary *dataArray, NSString *message, int error)
     {
         if (error == LH_RequesterrorNone)
         {
			 if (dataArray && [dataArray isKindOfClass:[NSDictionary class]])
			 {
				 NSArray *items = [dataArray objectForKey:@"area"];
				 if ([items isKindOfClass:[NSArray class]])
				 {
					 handler(items);
				 }else handler(nil);
			 }else handler(nil);
         }else handler(nil);
     }];
}

+ (void)getCheckAccountWithAccount:(NSString *)account completion:(void(^)(NSDictionary *resultInfo))handler
{
    NSString *url = [NSString stringWithFormat:@"%@checkAccount!personAccountExist.do?personaccount=%@",BASE_URL,account];
//    NSDictionary *info = @{@"personaccount": account};
    [[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url  handlerDic:^(NSDictionary *dictionary, NSString *message, int error) {
        if (error == LH_RequesterrorNone)
        {
            handler(dictionary);
        }else handler(nil);
    }];
}

+ (void)getResultsWithSearchKey:(NSString *)key areaID:(NSString *)areaID completion:(void(^)(NSArray *datas))handler
{
    
}

+ (void)getHotelInfoWithHotelNumber:(NSString *)hotel completion:(void(^)(NSDictionary *resultInfo))handler
{
    
}

+ (void)getOrderResultWithStartDate:(NSString *)startdate endDate:(NSString *)enddate peopleCount:(NSString *)pCount roomCount:(NSString *)rCount name:(NSString *)name phone:(NSString *)phone overDate:(NSString *)oDate money:(NSString *)money bedNumber:(NSString *)bedNumber hotelName:(NSString *)hotel hotelID:(NSString *)hID account:(NSString *)acccount hAccount:(NSString *)hAccount completion:(void(^)(NSDictionary *resultInfo))handler
{
    
}

+ (void)getOrderDetailWithOrderID:(NSString *)orderID completion:(void(^)(NSDictionary *resultInfo))handler
{
    
}

+ (void)getAllMyOrdersListWithAccount:(NSString *)account completion:(void(^)(NSArray *datas))handler
{
    
}

+ (void)getAllMySavedListWithAccount:(NSString *)account completion:(void(^)(NSArray *datas))handler
{
    
}

@end
