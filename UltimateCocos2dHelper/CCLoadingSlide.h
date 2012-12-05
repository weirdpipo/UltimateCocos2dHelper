//
//  CCLoadingSlide.h
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 8/26/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCScrollLayer.h"
@protocol LoadingSlideDelegate
-(void) runLoadTask;
@end
@interface CCLoadingSlide : CCNode{
    CGPoint position;
    CCScrollLayer *scroll;
    BOOL onRelease;
    BOOL loading;
    int separationX;
    CGPoint loadPos;
    id<LoadingSlideDelegate> delegate;
}

+(id) loadingSlide:(CCScrollLayer*)scrollLayer delegate:(id<LoadingSlideDelegate>)del;
-(id) initLoadingSlide:(CCScrollLayer*)scrollLayer delegate:(id<LoadingSlideDelegate>)del;

-(void) doneLoading;
-(void) disable;
-(void) enable;
@end
