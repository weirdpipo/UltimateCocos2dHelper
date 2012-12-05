//
//  CCNode+Opaque.m
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 2/10/12.
//  Copyright (c) 2012 Sabor Studio. All rights reserved.
//

#import "CCNode+Opaque.h"

@implementation CCNode (CCNode_Opaque)
// Set the opacity of all of our children that support it
-(void) setOpacity: (GLubyte) opacity
{
    for( CCNode *node in [self children] )
    {
        if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
        {
            [(id<CCRGBAProtocol>) node setOpacity: opacity];
        }
    }
}
- (GLubyte)opacity {
	for (CCNode *node in [self children]) {
		if ([node conformsToProtocol:@protocol(CCRGBAProtocol)]) {
			return [(id<CCRGBAProtocol>)node opacity];
		}
	}
	return 255;
}
@end