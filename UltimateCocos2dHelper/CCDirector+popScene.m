//
//  CCDirector+popScene.m
//  Potatoss
//
//  Created by Phillipe Casorla Sagot on 10/25/12.
//
//

#import "CCDirector+popScene.h"

@implementation CCDirector (CCDirector_popScene)
-(void) popSceneWithTransition: (Class)transitionClass duration:(ccTime)t;
{
    NSAssert( runningScene_ != nil, @"A running Scene is needed");
    
    [scenesStack_ removeLastObject];
    NSUInteger c = [scenesStack_ count];
    if( c == 0 ) {
        [self end];
    } else {
        CCScene* scene = [transitionClass transitionWithDuration:t scene:[scenesStack_ objectAtIndex:c-1]];
        [scenesStack_ replaceObjectAtIndex:c-1 withObject:scene];
        nextScene_ = scene;
    }
}
@end
