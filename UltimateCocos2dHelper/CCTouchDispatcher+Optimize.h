//
//  CCTouchDispatcher+Optimize.h
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 7/30/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCTouchDispatcher (targetedHandlersGetter)

- (NSMutableArray *) targetedHandlers;

@end
