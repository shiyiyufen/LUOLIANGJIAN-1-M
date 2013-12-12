//
//  LH_ConnectPool.m
//  HuangTao
//
//  Created by  on 13-1-10.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LH_ConnectPool.h"
#define  MaxCount 5 //最大并发数，可自由更改

@interface LH_ConnectPool()//隐藏方法，仅内部调用
//添加新的请求连接《－重写
- (void)addLHRequestConnections:(LH_Requester *)request;
@end

@implementation LH_ConnectPool
@synthesize concurrentEnabled,requestMethodGet;


static LH_ConnectPool *pools = nil;
- (void)dealloc
{
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) 
    {
        //最大并发数
        self.maxConcurrentOperationCount = MaxCount;
        concurrentEnabled = NO;
        requestMethodGet = NO;
    }
    return self;
}

+ (LH_ConnectPool *)sharedConnectionPool
{
    if (!pools)
    {
        pools = [[LH_ConnectPool alloc] init];
    }
    return pools;
}

#pragma mark interface

//ios 5.0
- (void)asyConnectWithAddress:(NSString *)address handlerArray:(void(^)(NSArray *objects,NSString *message ,int error))handler
{
    LH_Requester *request = [[LH_Requester alloc] init];
    request.requestMethodGet = self.requestMethodGet;
    [self addLHRequestConnections:request];
    [request asyConnectWithAddress:address handlerArray:handler];
    [request release];
}

- (void)asyConnectWithAddress:(NSString *)address handlerDic:(void(^)(NSDictionary *dictionary,NSString *message ,int error))handler
{
    LH_Requester *request = [[LH_Requester alloc] init];
    request.requestMethodGet = self.requestMethodGet;
    [self addLHRequestConnections:request];
    [request asyConnectWithAddress:address handlerDic:handler];
    [request release];
}


- (void)asyConnectWithAddress:(NSString *)address parmsDic:(NSDictionary *)parms handlerArray:(void(^)(NSArray *dataArray ,NSString *message ,int error))handler
{
    LH_Requester *request = [[LH_Requester alloc] init];
    request.requestMethodGet = self.requestMethodGet;
    [self addLHRequestConnections:request];
    [request asyConnectWithAddress:address parmsDic:parms handlerArray:handler];
    [request release];
}
 
- (void)asyConnectWithAddress:(NSString *)address parmsDic:(NSDictionary *)parms handlerDic:(void(^)(NSDictionary *dictionary ,NSString *message ,int error))handler
{
    LH_Requester *request = [[LH_Requester alloc] init];
    request.requestMethodGet = self.requestMethodGet;
    [self addLHRequestConnections:request];
    [request asyConnectWithAddress:address parmsDic:parms handlerDic:handler];
    [request release];
}

/*
- (void)asyConnectWithAddress:(NSString *)address parmsXML:(NSString *)parms handlerArray:(void(^)(NSArray *dataArray ,enum LH_Requesterror error))handler
{
    LH_Requester *request = [[LH_Requester alloc] init];
    request.requestMethodGet = self.requestMethodGet;
    [self addLHRequestConnections:request];
    [request asyConnectWithAddress:address parmsXML:parms handlerArray:handler];
    [request release];
}

- (void)asyConnectWithAddress:(NSString *)address parmsXML:(NSString *)parms handlerDic:(void(^)(NSDictionary *dictionary ,enum LH_Requesterror error))handler
{
    LH_Requester *request = [[LH_Requester alloc] init];
    request.requestMethodGet = self.requestMethodGet;
    [self addLHRequestConnections:request];
    [request asyConnectWithAddress:address parmsXML:parms handlerDic:handler];
    [request release];
}

//异步
- (void)asyConnectWithAddress:(NSString *)address delegate:(id<LH_RequesterDelegate>)target
{
    LH_Requester *request = [[LH_Requester alloc] initLHRequest];
    request.requestMethodGet = self.requestMethodGet;
    [self addLHRequestConnections:request];
    [request asyConnectWithAddress:address delegate:target];
    [request release];
}

- (void)asyConnectWithAddress:(NSString *)address requestIndex:(NSInteger)requestIndex delegate:(id<LH_RequesterDelegate>)target
{
    LH_Requester *request = [[LH_Requester alloc] initLHRequest];
    request.requestMethodGet = self.requestMethodGet;
    [self addLHRequestConnections:request];
    [request asyConnectWithAddress:address requestIndex:requestIndex delegate:target];
    [request release];
}

- (void)asyConnectWithAddress:(NSString *)address requestIndex:(NSInteger)requestIndex parmsDic:(NSDictionary *)parms delegate:(id<LH_RequesterDelegate>)target
{
    LH_Requester *request = [[LH_Requester alloc] initLHRequest];
    request.requestMethodGet = self.requestMethodGet;
    [self addLHRequestConnections:request];
    [request asyConnectWithAddress:address requestIndex:requestIndex parmsDic:parms delegate:target];
    [request release];
}

//同步连接
- (NSArray *)synchConnectWithAddress:(NSString *)address
{
    LH_Requester *request = [[LH_Requester alloc] initLHRequest];
    request.requestMethodGet = self.requestMethodGet;
    NSArray *array = [[request synchConnectWithAddress:address] retain];
    [request release];
    return [array autorelease];
}

- (NSArray *)synchConnectWithAddress:(NSString *)address parmsDic:(NSDictionary *)parms error:(NSError *)error
{
    LH_Requester *request = [[LH_Requester alloc] initLHRequest];
    request.requestMethodGet = self.requestMethodGet;
    NSArray *array = [[request synchConnectWithAddress:address parmsDic:parms error:error] retain];
    [request release];
    return [array autorelease];
}
*/
#pragma mark OperationConnect

- (void)addLHRequestConnections:(LH_Requester *)request
{
    if (request)
    {
        if (!concurrentEnabled)//第二个操作必须等第一个操作结束后再执行
        {
            if ([[self operations] count] > 0)
            { 
                LH_Requester *theBeforeTask=[[self operations] lastObject]; 
                if (theBeforeTask && [theBeforeTask isKindOfClass:[LH_Requester class]])
                {
                    [request addDependency:theBeforeTask]; 
                }
            }
        }
        
        //只针对ios5的版本
#ifdef __IPHONE_5_0
            //设定操作的队列
            if (pools)
            {
                request.operationQueue = pools;
            }else
            {
                request.operationQueue = self;
            }
#endif
        [self addOperation:request];
    }
}

- (void)removeAllConnections
{
    @autoreleasepool {
        for (LH_Requester *request in self.operations)
        {
            if ([request isKindOfClass:[LH_Requester class]] && ![request isCancelled])//取消没有被取消连接的请求
            {
                [request cancel];
            }
        }
        [self cancelAllOperations];//从操作池中移除
    }
}

@end
