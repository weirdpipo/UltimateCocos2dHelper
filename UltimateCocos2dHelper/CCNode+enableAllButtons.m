//
//  CCNode+enableAllButtons.m
//  Potatoss
//
//  Created by Phillipe Casorla Sagot on 10/25/12.
//
//

#import "CCNode+enableAllButtons.h"

@implementation CCNode (CCNode_enableAllButtons)
-(void) enableAllButtons:(bool)enable
{
	for (CCNode* node in self.children)
	{
		if ([node isKindOfClass:[CCMenu class]])
		{
			CCMenu* menu = (CCMenu*)node;
            [menu setIsTouchEnabled:enable];
		}
	}
}
@end
