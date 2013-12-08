//
//  DataHelper.h
//  HotelProject
//
//  Created by ZhaoJuan on 13-12-7.
//  Copyright (c) 2013年 ZhaoJuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHelper : NSObject
/**
 * 快速注册接口
 * @param
 * @return result 为1  注册成功  2 注册失败 msg 对应的信息
 
 */
+ (void)getResiterWithPhone:(NSString *)phone account:(NSString *)account email:(NSString *)email pwd:(NSString *)pwd completion:(void(^)(NSDictionary *resultInfo))handler;

/**
 * 完整注册接口
 * @param
 * @return result 为1  注册成功  2 注册失败 msg 对应的信息
 
 */
+ (void)getResiterWithPhone:(NSString *)phone account:(NSString *)account sex:(NSString *)sex name:(NSString *)name area:(NSString *)areaID address:(NSString *)address email:(NSString *)email pwd:(NSString *)pwd completion:(void(^)(NSDictionary *resultInfo))handler;
/**
 * 省份
 * @param
 * @return 省id:provinceid 省名称：provincename
 
 */
+ (void)getProvincesWithCompletion:(void(^)(NSArray *provinces))handler;

/**
 * 城市
 * @param  省id： provinceid
 * @return 市id:cityid 市名称：cityname
 
 */
+ (void)getCitiesWithProvince:(NSString *)provinceID completion:(void(^)(NSArray *cities))handler;

/**
 * 县区
 * @param  市id:cityid
 * @return 县id:areasid 县名称：areasname
 
 */
+ (void)getAreasWithCityID:(NSString *)cityID completion:(void(^)(NSArray *datas))handler;

/**
 * 验证账户是否存在
 * @param 账号：personaccount
 * @return result :1 表示存在 ；2表示 不存在
 */
+ (void)getCheckAccountWithAccount:(NSString *)account completion:(void(^)(NSDictionary *resultInfo))handler;
@end
