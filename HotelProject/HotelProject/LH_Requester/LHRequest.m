//
//  LHRequest.m
//  HuangTao
//
//  Created by  on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LHRequest.h"
#define DefaultSeconds 30
@interface LHRequest()

@end

@implementation LHRequest
@synthesize willCancelMe,continueRequestEnabled,requestFinish;
@synthesize cancelSeconds,currentRequestIndex;

- (void)dealloc
{
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) 
    {
        requestFinish = NO;
        willCancelMe = NO;
        currentRequestIndex = 0;
        continueRequestEnabled = YES;
    }
    return self;
}

- (void)startDown
{
	if (!willCancelMe) 
	{
        if ([self isCancelled])//确保自己未被取消
        {
            [self start];
        }
		//异步
		connection = [[NSURLConnection connectionWithRequest:request delegate:self] retain];
	}
}


- (NSInteger)secondsBeforeCancel
{
    NSInteger seconds;//取消连接的秒数
    if (0 == cancelSeconds)
    {
        seconds = DefaultSeconds;
    }else
    {
        seconds = cancelSeconds;
    }
    return seconds;
}

//是否能够继续请求
- (BOOL)continueRequestEnabled
{
    if ([self isCancelled] || willCancelMe) return NO;
    return YES;
}

- (BOOL)isConcurrent 
{
    //返回yes表示支持异步调用，否则为支持同步调用
    return YES;
}

- (BOOL)isExecuting
{
    return connection == nil; 
}

- (BOOL)isFinished
{
    return connection == nil;  
}

- (void)cancel
{
	if (![self isCancelled] || !willCancelMe)
	{
		willCancelMe   = YES;
        requestFinish = YES;
		if (connection)//取消此连接
		{
			[connection cancel];
		}
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	[super cancel];
}

- (void)main
{
	[super main];
	// do a little work
    if ([self isCancelled] || willCancelMe) 
	{
		return; 
	}
    // do a little more work
    if ([self isCancelled] || willCancelMe)
	{
		return; 
	}
}
@end
