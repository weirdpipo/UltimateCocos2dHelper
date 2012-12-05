//
//  CCDirector+popScene.h
//  Potatoss
//
//  Created by Phillipe Casorla Sagot on 10/25/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCDirector (CCDirector_popScene)
//Pops out a scene from the queue with a custom transition
- (void) popSceneWithTransition: (Class)c duration:(ccTime)t;
@end
