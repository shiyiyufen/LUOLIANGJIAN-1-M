//
//  LHRequest.h
//  HuangTao
//
//  Created by  on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TimeOutErrorCode -1001
#define MinStatusCode 200
#define MaxStatusCode 300
enum LH_Requesterror
{
    LH_RequesterrorNone = 91,//没有错误
    LH_RequesterrorNull,//数据为空
    LH_RequesterrorServer,//服务器出错
    LH_RequesterrorTimeOut,//连接超时
    LH_RequesterrorConnect//连接请求出错
};
#define REQUEST_RESULT enum LH_Requesterror

@interface LHRequest : NSOperation
{
    //private->内部调用
    NSTimer                    *timer;
    BOOL                       requestFinish;//请求数据是否完成
    BOOL                       willCancelMe;//是否将取消此连接
    NSURLConnection             *connection;
    NSMutableURLRequest         *request;
}
@property (nonatomic,assign) NSInteger    currentRequestIndex;//请求的索引
@property (nonatomic,assign) NSInteger    cancelSeconds;//设置连接超时的秒数
@property (nonatomic,readonly,assign) BOOL willCancelMe,continueRequestEnabled;//已经被告知取消

@property (nonatomic,readonly,assign) BOOL requestFinish;
//@property (nonatomic,assign) NSURLConnection *connection;

@end

@interface LHRequest(interface)
//开始下载 
//recommand for ios 5.0
- (void)startDown;

//获取取消连接的秒数
- (NSInteger)secondsBeforeCancel;
//request notification
- (void)successRecieveData:(NSArray *)array atIndex:(NSInteger)index;
- (void)failRecieveDataAtIndex:(NSInteger)index error:(enum LH_Requesterror)error;
@end