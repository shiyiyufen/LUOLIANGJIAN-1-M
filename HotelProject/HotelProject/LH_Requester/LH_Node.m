//
//  LH_Node
//  LH_Library
//
//  Created by  on 12-10-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "LH_Node.h"
@implementation LH_Node
@synthesize parentNode;
@synthesize children = _children;
@synthesize key = _key;
@synthesize leafValue = _leafValue;
@synthesize attributeDict = _attributeDict;

- (LH_Node *) init
{
	if (self = [super init]) 
	{
		//code
	}
	return self;
}

#pragma mark cleanup

- (NSMutableArray *)children
{
    if (!_children)
    {
        _children = [[NSMutableArray alloc] init];
    }
    return _children;
}

- (void) dealloc
{
	self.parentNode = nil;
	self.children = nil;
	self.key = nil;
	self.leafValue = nil;
    self.attributeDict = nil;
	[super dealloc];
}
@end

