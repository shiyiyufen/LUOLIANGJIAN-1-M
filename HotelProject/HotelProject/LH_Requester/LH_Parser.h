//
//  LH_Parser
//  HuangTao
//
//  Created by  on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LH_Node.h"
@interface LH_Parser : NSObject<NSXMLParserDelegate>
{    
    NSMutableArray       *treeArray;//树节点数据
    NSString             *currentItem;//当前的节点名称
}

//外部接口->数组
- (NSArray *)generateArrayFromXmlData:(NSData *)data;

- (NSArray *)generateArrayFromXmlString:(NSString *)data;

//外部接口->字典
- (NSDictionary *)generateDictionaryFromXmlData:(NSData *)data;

- (NSDictionary *)generateDictionaryFromXmlString:(NSString *)data;

@end
