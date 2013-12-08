//
//  LH_ConnectPool.h
//  HuangTao
//
//  Created by  on 13-1-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

/*
 //array
 //ios 5
 [[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:@"http://yapei.toms.mobi/xml/modulelist" handlerArray:^(NSArray *dataArray, enum LH_Requesterror error)
 {
 if (error == LH_RequesterrorNone)
 {
 NSLog(@"dataArray:%@",dataArray);
 NSLog(@"operations:%@ %d%d",[[LH_ConnectPool sharedConnectionPool] operations],i,i);
 }
 }];
 
 //dictionary**
 [[LH_ConnectPool sharedConnectionPool] asyConnectWithAddress:@"http://bjclen.toms.mobi/xml/channellist/product/?i=1048464640" handlerDic:^(NSDictionary *dictionary, enum LH_Requesterror error) {
 NSLog(@"dictionary:%@",dictionary);
 }];
 *
 
 ios4
 - (void)removeConnections
 {
 [[LH_ConnectPool sharedConnectionPool] removeAllConnections];
 }
 
 */

#import <Foundation/Foundation.h>
#import "LH_Requester.h"
@interface LH_ConnectPool : NSOperationQueue

@property (nonatomic,assign) BOOL concurrentEnabled;//否支持并发,默认no
@property (nonatomic,assign) BOOL requestMethodGet;//通过get/post请求，默认post

//获得单例请求池
+ (LH_ConnectPool *)sharedConnectionPool;

/***///interface
//外部联合调用，与LH_Requester区别是：
//1.保留了请求类实例
//2.增加取消连接机制
//3.隐藏多余的属性

//ios 5.0 异步
//返回数组
- (void)asyConnectWithAddress:(NSString *)address handlerArray:(void(^)(NSArray *objects,NSString *message ,int error))handler;

- (void)asyConnectWithAddress:(NSString *)address parmsDic:(NSDictionary *)parms handlerArray:(void(^)(NSArray *dataArray ,NSString *message ,int error))handler;
/*
- (void)asyConnectWithAddress:(NSString *)address parmsXML:(NSString *)parms handlerArray:(void(^)(NSArray *dataArray ,enum LH_Requesterror error))handler;
*/
//返回字典
- (void)asyConnectWithAddress:(NSString *)address handlerDic:(void(^)(NSDictionary *dictionary ,NSString *message,int error))handler;

- (void)asyConnectWithAddress:(NSString *)address parmsDic:(NSDictionary *)parms handlerDic:(void(^)(NSDictionary *dictionary ,NSString *message ,int error))handler;
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

*///interface

//取消某一个连接
//- (void)removeRequestConnection:(LH_Requester *)request;
//取消所有连接
- (void)removeAllConnections;
@end
