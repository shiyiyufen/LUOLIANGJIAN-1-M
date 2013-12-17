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
 * 发送短信验证码
 * @param  http://平台ip:平台端口号/CPDXT/SendSms?commandID=3&username=用户名&password=密码&mobile=手机号码&content=发送内容&needReport=0
 * @return
 */
+ (void)sendMsgForUser:(NSString *)username password:(NSString *)password mobile:(NSString *)mobile content:(NSString *)content completion:(void(^)(NSDictionary *resultInfo))handler;

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

/**
 * 查询酒店
 * @param 县编号areaid
 * @param 关键字keywords
 * @return
 */
+ (void)getResultsWithSearchKey:(NSString *)key areaID:(NSString *)areaID completion:(void(^)(NSArray *datas))handler;

/**
 * 酒店信息
 * @param 酒店编号 hotelnumber
 * @return 
 data[0][‘hotel’]
 酒店基本信息data[0][‘room’]和
 所有图片data[0][‘piclist’]
 
 */
+ (void)getHotelInfoWithHotelNumber:(NSString *)hotel completion:(void(^)(NSDictionary *resultInfo))handler;

/**
 * 酒店预订页面
 * @param 入住时间 		checkintime
 * @param 离店时间 		leavetime,
 * @param 入住人数		bookpsrnum,
 * @param 预订房间数		bookroomnum,
 * @param 预订人姓名		bookpsrname,
 * @param 预订人电话		bookpsrtel,
 * @param 最晚到达时间    lastarrivetime,
 * @param 预订房间费用    totalprice,
 * @param 预订的床型编号， bookbednumber,
 * @param 预订的酒店名称   hotelname,
 * @param 预订的酒店编号   hotelnumber,
 * @param 预订人账号      psraccount，
 * @param 发布酒店的账号   htraccount
 * @return data[0][‘info’]==1成功2失败

 */
+ (void)getOrderResultWithStartDate:(NSString *)startdate endDate:(NSString *)enddate peopleCount:(NSString *)pCount roomCount:(NSString *)rCount name:(NSString *)name phone:(NSString *)phone overDate:(NSString *)oDate money:(NSString *)money bedNumber:(NSString *)bedNumber hotelName:(NSString *)hotel hotelID:(NSString *)hID account:(NSString *)acccount hAccount:(NSString *)hAccount completion:(void(^)(NSDictionary *resultInfo))handler;

/**
 * 查询酒店订单详情
 * @param 酒店订单编号hotelindentnumber
 * @return data[0][‘info’]
 */
+ (void)getOrderDetailWithOrderID:(NSString *)orderID completion:(void(^)(NSDictionary *resultInfo))handler;

/**
 * 我的所有酒店订单
 * @param 预订人账号psraccount
 * @return data[0][‘info’]
 
 */
+ (void)getAllMyOrdersListWithAccount:(NSString *)account completion:(void(^)(NSArray *datas))handler;

/**
 * 我的所有收藏
 * @param 收藏人账号psraccount
 * @return data[0][‘info’]
 
 */
+ (void)getAllMySavedListWithAccount:(NSString *)account completion:(void(^)(NSArray *datas))handler;
@end
