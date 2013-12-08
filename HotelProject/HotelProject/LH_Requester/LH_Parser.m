//
//  LH_Parser.m
//  HuangTao
//
//  Created by  on 13-1-9.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LH_Parser.h"

//所有异常节点处理
#define RequestErrorID @"<html>"
#define RootItem @"channel"
#define ErrorItem @"systemMessage"
#define DeleteItem @"delete"
#define NullItem @"--"
#define NullString @" "

@interface LH_Parser()
//配置树节点
- (void)configureTree;
//开始解析
- (BOOL)startParserWithData:(NSData *)data;

//获得数据节点
- (LH_Node *)parser:(NSData *)data;
//获得数据节点字典
- (NSDictionary *)getNodeElementDic:(LH_Node *)node;
//获得数据节点数组
- (NSArray *)getDataArrayFromNode:(LH_Node *)rootNode;
@end


@implementation LH_Parser

//******************************************
//对外接口
//******************************************

- (NSDictionary *)generateDictionaryFromXmlString:(NSString *)data
{
    NSRange range = [data rangeOfString:RequestErrorID];
    if (range.location != NSNotFound)//服务器出错的判断
    {
        return nil;
    }
    
    //获得xml的树节点
    NSDictionary *dictionary = [self getNodeElementDic:[self parser:[data dataUsingEncoding:NSUTF8StringEncoding]]];
    if (dictionary) //有一个字典对象在此字典中
    {
        if ([[dictionary allKeys] count] == 1)
        {
            if ([[[dictionary objectEnumerator] nextObject] isKindOfClass:[NSDictionary class]])
            {
                return [[dictionary objectEnumerator] nextObject];
            }else return dictionary;
        }else return dictionary;
    }
    return nil;
}

- (NSArray *)generateArrayFromXmlString:(NSString *)data
{
    NSRange range = [data rangeOfString:RequestErrorID];
    if (range.location != NSNotFound)//服务器出错的判断
    {
        return nil;
    }
    
    //获得xml的树节点
    return [self getDataArrayFromNode:[self parser:[data dataUsingEncoding:NSUTF8StringEncoding]]];
}

- (NSArray *)generateArrayFromXmlData:(NSData *)data
{
    NSString *xml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSRange range = [xml rangeOfString:RequestErrorID];
    if (range.location != NSNotFound)//服务器出错的判断
    {
        [xml release];
        xml = nil;
        return nil;
    }
    [xml release];
    xml = nil;
    
    //获得xml的树节点
    return [self getDataArrayFromNode:[self parser:data]];
}

- (NSDictionary *)generateDictionaryFromXmlData:(NSData *)data
{
    NSString *xml = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSRange range = [xml rangeOfString:RequestErrorID];
    if (range.location != NSNotFound)//服务器出错的判断
    {
        [xml release];
        xml = nil;
        return nil;
    }
    [xml release];
    xml = nil;
    
    //获得xml的树节点
    NSDictionary *dictionary = [self getNodeElementDic:[self parser:data]];
    if (dictionary) //有一个字典对象在此字典中
    {
        if ([[dictionary allKeys] count] == 1)
        {
            if ([[[dictionary objectEnumerator] nextObject] isKindOfClass:[NSDictionary class]])
            {
                return [[dictionary objectEnumerator] nextObject];
            }else return dictionary;
        }else return dictionary;
    }
    return nil;
}

//******************************************
//准备解析操作
//******************************************
- (void)configureTree
{
    if (treeArray)//初始化树
    {
        [treeArray release];
        treeArray = nil;
    }
    treeArray = [[NSMutableArray alloc] init];
    
    //根节点
    LH_Node *root = [[LH_Node alloc] init];
	root.parentNode = nil;
	root.leafValue = nil;
	[treeArray addObject:root];
    [root release];
}

//配置xml解析器
- (BOOL)startParserWithData:(NSData *)data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
	[parser setShouldProcessNamespaces:YES];
	[parser setShouldReportNamespacePrefixes:YES];
	[parser setShouldResolveExternalEntities:NO];
    
	BOOL success = [parser parse];
	[parser release];
    return success;
}

- (LH_Node *)parser:(NSData *)data
{
    //配置解析树
    [self configureTree];
	if ([self startParserWithData:data])//如果解析成功
    {
        NSLog(@"解析成功");
        LH_Node *root = nil;
        if (treeArray && [treeArray count] > 0)
        {
            root = [treeArray objectAtIndex:0];
            //取最后一个节点
            LH_Node *realroot = [[root children] lastObject];
            return realroot;
        }
    }
    return nil;
}

//******************************************
//解析操作
//******************************************
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    currentItem = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName attributes: (NSDictionary *)attributeDict 
{
    if (qName) elementName = qName;
    currentItem = elementName;
    
    //叶子节点
    LH_Node *leaf = [[LH_Node alloc] init];
	leaf.parentNode = [treeArray lastObject];
	[(NSMutableArray *)[[treeArray lastObject] children] addObject:leaf];
    
    if (attributeDict)//属性列表是否存在
    {
        leaf.attributeDict = attributeDict;
    }
	
    //加到树上
	leaf.key       = elementName;
	leaf.leafValue  = nil;
	[treeArray addObject:leaf];
    [leaf release];
}

//解析节点完成
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{	
    currentItem = nil;
	[treeArray removeLastObject];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string 
{
    //utf-8解码
    NSString *utf8String = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	string = nil;
    
	if ([utf8String isEqualToString:ErrorItem])//如果节点是服务器错误节点
	{
		utf8String = NullString;
	}
	if (![[treeArray lastObject] leafValue])
	{
		[[treeArray lastObject] setLeafValue:utf8String];
		return;
	}
    
    NSString *leafValue = [[NSString alloc] initWithFormat:@"%@%@", [[treeArray lastObject] leafValue], utf8String];
	[[treeArray lastObject] setLeafValue:leafValue];
    [leafValue release];
}

//******************************************
//操作节点，转换成数据
//******************************************

- (NSArray *)getDataArrayFromNode:(LH_Node *)rootNode
{
    if (nil == rootNode) return nil;
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
	for (int i = 0;i < rootNode.children.count; i++)
	{
        @autoreleasepool 
        {
            LH_Node *node  = [rootNode.children objectAtIndex:i];
            NSDictionary *dic = [self getNodeElementDic:node];
            if (!dic || [dic count] == 0) 
            {
                break;
            }
            if ([dic objectForKey:DeleteItem]) 
            {
                continue;
            }
            NSDictionary *dictionary = [[NSDictionary alloc] initWithDictionary:dic];
            [resultArray addObject:dictionary];
            [dictionary release];
            dictionary = nil;
        }
	}
    rootNode = nil;
    return [resultArray autorelease];
}

- (NSDictionary *)getNodeElementDic:(LH_Node *)node
{
	NSMutableDictionary *myDic  = [[NSMutableDictionary alloc] init];
	if (node.children.count > 0)//有孩子节点，读取孩子节点内容
	{
		for (int i = 0; i < node.children.count; i ++)//遍历所有节点
		{
            @autoreleasepool 
            {
                LH_Node *n = [node.children objectAtIndex:i];
                if ([n.key isEqualToString:ErrorItem] || [n.key isEqualToString:DeleteItem])//如果此节点是服务器错误节点或者删除节点，过滤
                {
                    continue;
                }else//如果此节点是正常节点
                {
                    if(n.children.count > 0)//如果此节点还有子节点，即还有下一级的节点->递归操作
                    {
                        NSDictionary *dic = [[self getNodeElementDic:n] retain];
                        [myDic setObject:dic forKey:n.key];
                        [dic release];
                    }else//如果此节点下没有其他子节点
                    {
                        //如果此节点的值有效
                        if ([n.leafValue isEqualToString:NullItem] || !n.leafValue || n.leafValue == (id)[NSNull null] || n.leafValue.length == 0) 
                        {
                            if (n.attributeDict && n.attributeDict.count > 0)
							{
								[myDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:n.attributeDict,NullString, nil] forKey:n.key];
							} else [myDic setObject:NullString forKey:n.key];
                        }else 
                        {
							if (n.attributeDict && n.attributeDict.count > 0)
							{
								[myDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:n.attributeDict,n.leafValue, nil] forKey:n.key];
							} else [myDic setObject:n.leafValue forKey:n.key];
                        }
                    }
                }
            }
		}
	}else//没有孩子节点，直接读取值
	{
		if ([node.key isEqualToString:ErrorItem] || [node.key isEqualToString:DeleteItem])//如果此节点是服务器错误节点或者删除节点，过滤
		{
			[myDic release];
			myDic = [[NSMutableDictionary alloc] init];
		}else
		{
			if ([node.leafValue isEqualToString:NullItem] || !node.leafValue || node.leafValue == (id)[NSNull null] || node.leafValue.length == 0) 
			{
				if (node.attributeDict && node.attributeDict.count > 0)
				{
					[myDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:node.attributeDict,NullString, nil] forKey:node.key];
				} else [myDic setObject:NullString forKey:node.key];
			}else 
			{
				if (node.attributeDict && node.attributeDict.count > 0)
				{
					[myDic setObject:[NSDictionary dictionaryWithObjectsAndKeys:node.attributeDict,node.leafValue, nil] forKey:node.key];
				} else [myDic setObject:node.leafValue forKey:node.key];
			}
		}
	}
	return [myDic autorelease];
}


@end
