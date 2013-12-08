//
//  LH_Requester.h
//  HuangTao
//
//  Created by  on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHRequest.h"

@protocol LH_RequesterDelegate;
@interface LH_Requester : LHRequest

//open
@property (nonatomic, assign) id <LH_RequesterDelegate> delegate;
@property (nonatomic, assign) BOOL requestMethodGet;//通过get/post请求，默认post
@property (nonatomic,   copy) NSString *requestBaseURL;//请求的域名
@property (nonatomic, retain) NSOperationQueue *operationQueue;//操作队列

//private
@property (readonly, nonatomic, retain)   NSMutableData *receivedata;//获取的数据
@property (readonly, nonatomic) long long totalBytes;//数据下载总量
@property (readonly, nonatomic) CGFloat dataRatio;//数据下载百分比

//专用初始化
- (id)initLHRequest;

//ios 5.0
//返回数据数组的请求接口
- (void)asyConnectWithAddress:(NSString *)address handlerArray:(void(^)(NSArray *dataArray ,NSString *message,int error))handler;

- (void)asyConnectWithAddress:(NSString *)address parmsDic:(NSDictionary *)parms handlerArray:(void(^)(NSArray *dataArray ,NSString *message,int error))handler;
/*
- (void)asyConnectWithAddress:(NSString *)address parmsXML:(NSString *)parms handlerArray:(void(^)(NSArray *dataArray ,enum LH_Requesterror error))handler;
*/
//返回数据字典的请求接口
- (void)asyConnectWithAddress:(NSString *)address handlerDic:(void(^)(NSDictionary *dictionary,NSString *message ,int error))handler;

- (void)asyConnectWithAddress:(NSString *)address parmsDic:(NSDictionary *)parms handlerDic:(void(^)(NSDictionary *dictionary,NSString *message ,int error))handler;
/*
- (void)asyConnectWithAddress:(NSString *)address parmsXML:(NSString *)parms handlerDic:(void(^)(NSDictionary *dictionary ,enum LH_Requesterror error))handler;

//< ios 5.0
//异步连接
- (void)asyConnectWithAddress:(NSString *)address delegate:(id<LH_RequesterDelegate>)target;
- (void)asyConnectWithAddress:(NSString *)address requestIndex:(NSInteger)requestIndex delegate:(id<LH_RequesterDelegate>)target;
- (void)asyConnectWithAddress:(NSString *)address requestIndex:(NSInteger)requestIndex parmsDic:(NSDictionary *)parms delegate:(id<LH_RequesterDelegate>)target;

//同步连接
- (NSArray *)synchConnectWithAddress:(NSString *)address;
- (NSArray *)synchConnectWithAddress:(NSString *)address parmsDic:(NSDictionary *)parms error:(NSError *)error;
 */
@end


@protocol LH_RequesterDelegate <NSObject>;

//完成解析－》返回数组
- (void)didFinishDataLoading:(NSArray *)array atIndex:(NSInteger)index;

//解析完成－》捕获错误
- (void)didFailLoadDataAtIndex:(NSInteger)index error:(enum LH_Requesterror)error;
@end