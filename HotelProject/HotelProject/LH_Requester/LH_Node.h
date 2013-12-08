
//
//  LH_Node
//  CompanyMailProject
//
//  Created by apple on 12-7-3.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

//解析xml节点，不直接调用
@interface LH_Node : NSObject 
{
	LH_Node           *parentNode;
	NSMutableArray    *_children;
	NSString          *_key;
	NSString          *_leafValue;
	NSDictionary      *_attributeDict;
}
@property (nonatomic,retain) LH_Node        *parentNode;
@property (nonatomic,retain) NSMutableArray *children;
@property (nonatomic,  copy) NSString       *key;
@property (nonatomic,  copy) NSString       *leafValue;
@property (nonatomic,retain) NSDictionary   *attributeDict;

@end

