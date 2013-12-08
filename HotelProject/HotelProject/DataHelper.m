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
    NSString *url = [NSString stringWithFormat:@"%@personRigister!addPersonInfo.do",BASE_URL];
    NSDictionary *info = @{@"personmobilenumber": phone,@"personaccount": account,@"personemail": email,@"personpwd": pwd};
    [[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url parmsDic:info handlerDic:^(NSDictionary *dictionary, NSString *message, int error) {
        if (error == LH_RequesterrorNone)
        {
            handler(dictionary);
        }else handler(nil);
    }];
}

+ (void)getResiterWithPhone:(NSString *)phone account:(NSString *)account sex:(NSString *)sex name:(NSString *)name area:(NSString *)areaID address:(NSString *)address email:(NSString *)email pwd:(NSString *)pwd completion:(void(^)(NSDictionary *resultInfo))handler
{
    NSString *url = [NSString stringWithFormat:@"%@personRigister!addPersonInfo.do",BASE_URL];
    NSDictionary *info = @{@"personmobilenumber": phone,@"personaccount": account,@"personemail": email,@"personpwd": pwd,@"personsex":sex,@"personname" : name,@"areasid" : areaID,@"personaddressdetail" : address};
    [[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url parmsDic:info handlerDic:^(NSDictionary *dictionary, NSString *message, int error) {
        if (error == LH_RequesterrorNone)
        {
            handler(dictionary);
        }else handler(nil);
    }];
}

+ (void)getProvincesWithCompletion:(void(^)(NSArray *provinces))handler
{
    NSString *url = [NSString stringWithFormat:@"%@findAddress!getProvinces.do",BASE_URL];
	[[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url handlerArray:^(NSArray *objects, NSString *message, int error)
     {
         if (error == LH_RequesterrorNone)
         {
             handler(objects);
         }else handler(nil);
     }];
}

+ (void)getCitiesWithProvince:(NSString *)provinceID completion:(void(^)(NSArray *cities))handler
{
    NSString *url = [NSString stringWithFormat:@"%@findAddress!getCitys.do",BASE_URL];
    NSDictionary *info = @{@"provinceid": provinceID};
	[[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url parmsDic:info handlerArray:^(NSArray *dataArray, NSString *message, int error)
     {
         if (error == LH_RequesterrorNone)
         {
             handler(dataArray);
         }else handler(nil);
     }];
}

+ (void)getAreasWithCityID:(NSString *)cityID completion:(void(^)(NSArray *datas))handler
{
    NSString *url = [NSString stringWithFormat:@"%@findAddress!getAreas.do",BASE_URL];
    NSDictionary *info = @{@"cityid": cityID};
	[[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url parmsDic:info handlerArray:^(NSArray *dataArray, NSString *message, int error)
     {
         if (error == LH_RequesterrorNone)
         {
             handler(dataArray);
         }else handler(nil);
     }];
}

+ (void)getCheckAccountWithAccount:(NSString *)account completion:(void(^)(NSDictionary *resultInfo))handler
{
    NSString *url = [NSString stringWithFormat:@"%@checkAccount!personAccountExist.do",BASE_URL];
    NSDictionary *info = @{@"personaccount": account};
    [[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:url parmsDic:info  handlerDic:^(NSDictionary *dictionary, NSString *message, int error) {
        if (error == LH_RequesterrorNone)
        {
            handler(dictionary);
        }else handler(nil);
    }];
}

@end
