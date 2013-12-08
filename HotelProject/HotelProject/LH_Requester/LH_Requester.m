//
//  LH_Requester.m
//  HuangTao
//
//  Created by  on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LH_Requester.h"
#import "LH_Parser.h"
#import "LH_ConnectPool.h"
@interface LH_Requester()//内部方法
- (NSString *)setXMLWithParms:(NSDictionary *)parms;
//配置请求的body,
- (void)configureRequestBody:(id)parms;

//ios 5.0
//建立异步连接－》块
- (void)buildAsyConnectionWithArrayHandler:(void(^)(NSArray *objects,NSString *message ,int error))handler;
- (void)buildAsyConnectionWithDicHandler:(void(^)(NSDictionary *dictionary ,NSString *message,int error))handler;

//配置请求
- (void)configureRequestWithAddress:(NSString *)address;

//< ios 5.0
//配置请求－》代理回调
- (void)configureRequestWithAddress:(NSString *)address delegate:(id)delegate;
@end

@implementation LH_Requester
@synthesize dataRatio,totalBytes,receivedata,requestBaseURL,delegate,operationQueue,requestMethodGet;

- (void)dealloc
{
    self.delegate = nil;
    self.requestBaseURL = nil;
    if (receivedata)
    {
        [receivedata setLength:0];
        [receivedata release];
        receivedata = nil;
    }
    [operationQueue release];
    [super dealloc];
}

- (id)initLHRequest
{
    if (self = [super init])
    {
        //code
    }
    return self;
}

//ios 5
- (void)buildAsyConnectionWithArrayHandler:(void(^)(NSArray *objects,NSString *message ,int error))handler
{
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil)//请求成功，并且返回数据
         {
             NSError *error = nil;
             NSArray *objects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
			 
			 dispatch_sync(dispatch_get_main_queue(), ^{
				 //返回数据
				 handler(objects,@"OK",LH_RequesterrorNone);
			 });
         }
         else if(error != nil && error.code == TimeOutErrorCode)//请求超时
         {
			 dispatch_sync(dispatch_get_main_queue(), ^{handler(nil,@"请求超时",LH_RequesterrorTimeOut);});
         }
         else if ([data length] == 0 && error == nil)//返回空的数据
         {
             dispatch_sync(dispatch_get_main_queue(), ^{handler(nil,@"没有数据",LH_RequesterrorNull);});
         }
         else if (error != nil)
         {
             //请求过程中发生错误
             dispatch_sync(dispatch_get_main_queue(), ^{handler(nil,@"数据请求异常",LH_RequesterrorConnect);});
         }
     }];
}

- (void)buildAsyConnectionWithDicHandler:(void(^)(NSDictionary *dictionary,NSString *message,int error))handler
{
    [NSURLConnection sendAsynchronousRequest:request queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
		 if ([data length] > 0 && error == nil)//请求成功，并且返回数据
         {
             NSError *error = nil;
             NSDictionary *objects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
			 
			 dispatch_sync(dispatch_get_main_queue(), ^{
				 //返回数据
				 handler(objects,@"OK",LH_RequesterrorNone);
			 });
         }
         else if(error != nil && error.code == TimeOutErrorCode)//请求超时
         {
             dispatch_sync(dispatch_get_main_queue(), ^{handler(nil,@"请求超时",LH_RequesterrorTimeOut);});
         }
         else if ([data length] == 0 && error == nil)//返回空的数据
         {
             dispatch_sync(dispatch_get_main_queue(), ^{handler(nil,@"没有数据",LH_RequesterrorNull);});
         }
         else if (error != nil)
         {
             //请求过程中发生错误
             dispatch_sync(dispatch_get_main_queue(), ^{handler(nil,@"数据请求异常",LH_RequesterrorConnect);});
         }
     }];
}

- (NSURLRequest *)connection:(NSURLConnection *)_connection willSendRequest:(NSURLRequest *)arequest redirectResponse:(NSURLResponse *)response
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    totalBytes = [response expectedContentLength];//数据总量
	if (!self.continueRequestEnabled)//如果请求被取消的话
	{
		[_connection cancel];
		return nil;
	}
	return arequest;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (!self.continueRequestEnabled) return;//如果请求被取消的话
    dataRatio = 0.0;
	[receivedata setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if (!self.continueRequestEnabled) return;//如果请求被取消的话
    
	[receivedata appendData:data];
    if (totalBytes > 0)
    {
        //数据下载比率
        dataRatio = [receivedata length] / totalBytes;
    }
	data = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection
{
    //设置请求完成状态
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	requestFinish = TRUE;
	[connection release];
	connection = nil;
    
	if (!self.continueRequestEnabled)//如果请求被取消的话 
	{
        willCancelMe = NO;
		self.delegate = nil;
		return;
	}
    
    //获取正常的数据
	willCancelMe = NO;
	LH_Parser *parser = [[LH_Parser alloc] init];
	NSArray *dataArray = [[parser generateArrayFromXmlData:receivedata] retain];
    [parser release];
	[self successRecieveData:dataArray atIndex:self.currentRequestIndex];
	[dataArray release];
}

- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (error && error.code == TimeOutErrorCode)//请求超时
    {
        [self failRecieveDataAtIndex:self.currentRequestIndex error:LH_RequesterrorTimeOut];
    }else//其他错误
    {
        [self failRecieveDataAtIndex:self.currentRequestIndex error:LH_RequesterrorConnect];
    }
	[connection release];
	connection = nil;
    requestFinish = TRUE;
}

- (void)asyConnectWithAddress:(NSString *)address delegate:(id<LH_RequesterDelegate>)target
{
    [self configureRequestWithAddress:address delegate:target];
    self.currentRequestIndex = 0;
    [self startDown];
}

- (void)asyConnectWithAddress:(NSString *)address requestIndex:(NSInteger)requestIndex delegate:(id<LH_RequesterDelegate>)target
{
    self.currentRequestIndex = requestIndex;
    [self asyConnectWithAddress:address delegate:target];
}

- (void)asyConnectWithAddress:(NSString *)address requestIndex:(NSInteger)requestIndex parmsDic:(NSDictionary *)parms delegate:(id<LH_RequesterDelegate>)target
{
    [self configureRequestWithAddress:address delegate:target];
    //表单
    [self configureRequestBody:parms];
    self.currentRequestIndex = requestIndex;
    [self startDown];
}

//ios 5.0
- (void)asyConnectWithAddress:(NSString *)address handlerArray:(void(^)(NSArray *dataArray ,NSString *message,int error))handler
{
#ifdef __IPHONE_5_0
    //配置请求
    [self configureRequestWithAddress:address];
    
    //建立连接
    [self buildAsyConnectionWithArrayHandler:handler];
#else
    NSLog(@"waring.... ios version is lower than 5.0!");
    return;
#endif
}

- (void)asyConnectWithAddress:(NSString *)address handlerDic:(void(^)(NSDictionary *dictionary,NSString *message ,int error))handler
{
#ifdef __IPHONE_5_0
    //配置请求
    [self configureRequestWithAddress:address];
    
    //建立连接
    [self buildAsyConnectionWithDicHandler:handler];
#else
    NSLog(@"waring.... ios version is lower than 5.0!");
    return;
#endif
}

- (void)asyConnectWithAddress:(NSString *)address parmsDic:(NSDictionary *)parms handlerDic:(void(^)(NSDictionary *dictionary,NSString *message ,int error))handler
{
#ifdef __IPHONE_5_0
    //配置请求
    [self configureRequestWithAddress:address];
    //表单
    [self configureRequestBody:parms];
    //建立连接
    [self buildAsyConnectionWithDicHandler:handler];
#else
    NSLog(@"waring.... ios version is lower than 5.0!");
    return;
#endif
}
//
//- (void)asyConnectWithAddress:(NSString *)address parmsXML:(NSString *)parms handlerArray:(void(^)(NSArray *dataArray ,enum LH_Requesterror error))handler
//{
//#ifdef __IPHONE_5_0
//    //配置请求
//    [self configureRequestWithAddress:address];
//    //表单
//    [self configureRequestBody:parms];
//    //建立连接
//    [self buildAsyConnectionWithArrayHandler:handler];
//#else
//    NSLog(@"waring.... ios version is lower than 5.0!");
//    return;
//#endif
//}
//
//- (void)asyConnectWithAddress:(NSString *)address parmsXML:(NSString *)parms handlerDic:(void(^)(NSDictionary *dictionary ,enum LH_Requesterror error))handler
//{
//#ifdef __IPHONE_5_0
//    //配置请求
//    [self configureRequestWithAddress:address];
//    //表单
//    [self configureRequestBody:parms];
//    //建立连接
//    [self buildAsyConnectionWithDicHandler:handler];
//#else
//    NSLog(@"waring.... ios version is lower than 5.0!");
//    return;
//#endif
//}
//
- (void)asyConnectWithAddress:(NSString *)address parmsDic:(NSDictionary *)parms handlerArray:(void(^)(NSArray *objects,NSString *message ,int error))handler
{
#ifdef __IPHONE_5_0

    //配置请求
    [self configureRequestWithAddress:address];
    //表单
    [self configureRequestBody:parms];
    //建立连接
    [self buildAsyConnectionWithArrayHandler:handler];
#else
    NSLog(@"waring.... ios version is lower than 5.0!");
    return;
#endif
}

- (NSArray *)synchConnectWithAddress:(NSString *)address
{
    if (!self.requestBaseURL) 
    {
        self.requestBaseURL = @"";
    }
    //组装接口地址
    NSString *xml = [[NSString alloc] initWithFormat:@"%@%@",self.requestBaseURL,address];
	NSLog(@"全域名:%@",xml);
	address = nil;
	NSMutableURLRequest *myRequest = [[NSMutableURLRequest alloc]init];
	[myRequest setURL:[NSURL URLWithString:xml]];
    [myRequest setTimeoutInterval:[self secondsBeforeCancel]];//连接超时
	if (requestMethodGet)
    {
        [myRequest setHTTPMethod:@"GET"];//请求方式
    }else
    {
        [myRequest setHTTPMethod:@"POST"];//请求方式
    }
	[myRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [myRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];//数据压缩
    [xml release];
	xml = nil;
    
    requestFinish = NO;
	NSHTTPURLResponse* urlResponse = nil;
    //发送同步请求
	NSData *responseData = [NSURLConnection sendSynchronousRequest:myRequest 
												 returningResponse:&urlResponse error:nil];
    [myRequest release];
    requestFinish = YES;
    //远程服务器出错code
	if ([urlResponse statusCode] < MinStatusCode || [urlResponse statusCode] >= MaxStatusCode)
    {
        NSLog(@"远程服务器出错!");
		return nil;
	}
    
    //数据请求正常
    LH_Parser *parser = [[LH_Parser alloc] init];
	NSArray *dataArray = [[parser generateArrayFromXmlData:responseData] retain];
    [parser release];
    return [dataArray autorelease];
}

- (NSArray *)synchConnectWithAddress:(NSString *)address parmsDic:(NSDictionary *)parms error:(NSError *)error
{
    if (!self.requestBaseURL) 
    {
        self.requestBaseURL = @"";
    }
    //组装接口地址
    NSString *xml = [[NSString alloc] initWithFormat:@"%@%@",self.requestBaseURL,address];
	NSLog(@"全域名:%@",xml);
    NSMutableURLRequest *myRequest = [[NSMutableURLRequest alloc]init];
	[myRequest setURL:[NSURL URLWithString:xml]];
    [myRequest setTimeoutInterval:[self secondsBeforeCancel]];//连接超时
	if (requestMethodGet)
    {
        [myRequest setHTTPMethod:@"GET"];//请求方式
    }else
    {
        [myRequest setHTTPMethod:@"POST"];//请求方式
    }
	[myRequest addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [myRequest setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];//数据压缩
    [xml release];
	xml = nil;
    
    //数据流
    if (parms)
    {
        NSMutableData *data = [[NSMutableData alloc] init];//要发送的xml数据
        NSString *send = [[self setXMLWithParms:parms] retain];
        parms = nil;
        if (send)
        {
            [data appendData:[send dataUsingEncoding:NSUTF8StringEncoding]];//utf-8编码
        }
        [send release];
        send = nil;
        [myRequest setHTTPBody:data]; 
        [data release];
    }
    
    requestFinish = NO;
	NSHTTPURLResponse* urlResponse = nil;
    //发送同步请求
	NSData *responseData = [NSURLConnection sendSynchronousRequest:myRequest 
												 returningResponse:&urlResponse error:nil];
    [myRequest release];
    requestFinish = YES;
    //远程服务器出错code
	if ([urlResponse statusCode] < MinStatusCode || [urlResponse statusCode] >= MaxStatusCode)
    {
        NSLog(@"远程服务器出错!");
		return nil;
	}
    
    //数据请求正常
    LH_Parser *parser = [[LH_Parser alloc] init];
	NSArray *dataArray = [[parser generateArrayFromXmlData:responseData] retain];
    [parser release];
    return [dataArray autorelease];
}


- (void)successRecieveData:(NSArray *)array atIndex:(NSInteger)index
{
    if (delegate && [delegate respondsToSelector:@selector(didFinishDataLoading:atIndex:)])
    {
        [delegate didFinishDataLoading:array atIndex:index];
    }
}

- (void)failRecieveDataAtIndex:(NSInteger)index error:(enum LH_Requesterror)error
{
    if (delegate && [delegate respondsToSelector:@selector(didFailLoadDataAtIndex:error:)])
    {
        [delegate didFailLoadDataAtIndex:index error:error];
    }
}

//ios 5.0
- (void)configureRequestWithAddress:(NSString *)address
{
    if (!self.requestBaseURL) 
    {
        self.requestBaseURL = @"";
    }
    //组装接口地址
	NSString *xml = [[NSString alloc] initWithFormat:@"%@%@",self.requestBaseURL,[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"xml eee:%@",xml);
	
    if (request)
    {
        [request release];
        request = nil;
    }
	request = [[NSMutableURLRequest alloc]init];
	[request setURL:[NSURL URLWithString:xml]];
    [request setTimeoutInterval:[self secondsBeforeCancel]];
	if (requestMethodGet)
    {
        [request setHTTPMethod:@"GET"];//请求方式
    }else
    {
        [request setHTTPMethod:@"POST"];//请求方式
    }
	[request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];//数据压缩
    [xml release];
	xml = nil;
}

// < ios 5.0
- (void)configureRequestWithAddress:(NSString *)address delegate:(id<LH_RequesterDelegate>)target
{
    willCancelMe = NO;
    if (!self.requestBaseURL) 
    {
        self.requestBaseURL = @"";
    }
    //组装接口地址
	NSString *xml = [[NSString alloc] initWithFormat:@"%@%@",self.requestBaseURL,[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSLog(@"xml eee:%@",xml);
	
    if (request)
    {
        [request release];
        request = nil;
    }
	request = [[NSMutableURLRequest alloc]init];
	[request setURL:[NSURL URLWithString:xml]];
    [request setTimeoutInterval:[self secondsBeforeCancel]];
	if (requestMethodGet)
    {
        [request setHTTPMethod:@"GET"];//请求方式
    }else
    {
        [request setHTTPMethod:@"POST"];//请求方式
    }
	[request addValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];//数据压缩
    [xml release];
	xml = nil;
	
    //设置代理
    self.delegate = (id<LH_RequesterDelegate>)target;
    
    //初始化receivedata
    if (receivedata)
    {
        [receivedata setLength:0];
        [receivedata release];
        receivedata = nil;
    }
    receivedata = [[NSMutableData alloc] init];
}

- (void)configureRequestBody:(id)parms
{
    if (parms)
    {
        if ([parms isKindOfClass:[NSDictionary class]])
        {
            //数据流
            NSMutableData *data = [NSMutableData data];//要发送的xml数据
            NSString *send = [[self setXMLWithParms:parms] retain];
            [data appendData:[send dataUsingEncoding:NSUTF8StringEncoding]];//utf-8编码
            [send release];
            send = nil;
            [request setHTTPBody:data];
        }
        else if([parms isKindOfClass:[NSString class]])
        {
            //数据流
            NSMutableData *data = [NSMutableData data];//要发送的xml数据
            [data appendData:[parms dataUsingEncoding:NSUTF8StringEncoding]];//utf-8编码
            [request setHTTPBody:data];
        }
    }
}

/*
 组装xml字符串
 */
- (NSString *)setXMLWithParms:(NSDictionary *)parms
{
    if (nil == parms) return nil;
    NSMutableString *string = [[NSMutableString alloc] init];
    [string appendString:@"<from>"];
    NSUInteger count = [parms count];
	if (count > 0)//有参数->组装参数
	{
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		for (id key in parms) 
		{
			[string appendFormat:@"<%@>%@</%@>",key,[parms objectForKey:key],key];
		}
        [pool release];
	}
    [string appendString:@"</from>"];
    NSLog(@"组装的xml字符串:%@",string);
    return [string autorelease];
}

@end
