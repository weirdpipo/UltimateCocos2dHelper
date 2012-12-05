//
//  CCNode+enableAllButtons.h
//  Potatoss
//
//  Created by Phillipe Casorla Sagot on 10/25/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCNode (CCNode_enableAllButtons)
//enable or disable all the buttons/CCMenu availables in this CCNode, useful when pausing a layer
-(void) enableAllButtons:(bool)enable;
@end
