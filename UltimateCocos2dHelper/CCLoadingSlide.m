//
//  CCLoadingSlide.m
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 8/26/12.
//
//

#import "CCLoadingSlide.h"
#import "CCLabelTTF+Resize.h"
#import "CCLoadingTitle.h"

@implementation CCLoadingSlide
+(id) loadingSlide:(CCScrollLayer*)scrollLayer delegate:(id<LoadingSlideDelegate>)del{
    return [[[self alloc] initLoadingSlide:scrollLayer delegate:del] autorelease];
}
-(id) initLoadingSlide:(CCScrollLayer*)scrollLayer delegate:(id<LoadingSlideDelegate>)del{
    if (self = [super init]) {
        [self initLoading];
        scroll = scrollLayer;
        delegate = del;
        [self schedule:@selector(moveSlide:)];
        if (IF_IPAD()) {
            separationX = 215;
            loadPos = PTP(-80,190);
        } else {
            separationX = 20;
            loadPos = PTP(10,200);
        }
	}
	return self;
}
-(void) initLoading{
    position = PTP(-80,170);
    CGPoint sizePoint = PTP(120,100);
    CCLabelTTF *pull = [CCLabelTTF labelWithStringAutoSize:@"Pull to refresh..." dimensions:CGSizeMake(sizePoint.x , sizePoint.y) alignment:UITextAlignmentCenter lineBreakMode:UILineBreakModeWordWrap fontName:@"nb_strange" fontSize:12];
    pull.position = position;
    pull.color = ccBLACK;
    pull.rotation = -90;
    [self addChild:pull z:0 tag:123];
    CCSprite *arrow = [CCSprite spriteWithSpriteFrameName:@"Arrow.png"];
    CGPoint arrowPos = PTP(40,60);
    arrow.position = ccp(position.x - arrowPos.x, position.y - arrowPos.y);
    arrow.color = ccBLACK;
    arrow.scale = 0.5f;
    [self addChild:arrow z:0 tag:124];
}
-(void) moveSlide:(ccTime) time{
    if ([scroll currentScreen] == 0) {
        if (!loading) {
            self.position = ccp(scroll.position.x + separationX,scroll.position.y);
        }
        if (!onRelease && scroll.position.x > 140) {
            [self addRelease];
        }
        if (onRelease && scroll.position.x <= 5) {
            position = loadPos;
            [self addDynamicLoading];
            [self gotoPos];
        }
    }
}
-(void) gotoPos{
    CCLabelTTF *L = (CCLabelTTF*)[self getChildByTag:_L];
    CCLabelTTF *O = (CCLabelTTF*)[self getChildByTag:_O];
    CCLabelTTF *A = (CCLabelTTF*)[self getChildByTag:_A];
    CCLabelTTF *D = (CCLabelTTF*)[self getChildByTag:_D];
    CCLabelTTF *I = (CCLabelTTF*)[self getChildByTag:_I];
    CCLabelTTF *N = (CCLabelTTF*)[self getChildByTag:_N];
    CCLabelTTF *G = (CCLabelTTF*)[self getChildByTag:_G];
    [L runAction:[CCFadeIn actionWithDuration:0.3f]];
    [O runAction:[CCFadeIn actionWithDuration:0.3f]];
    [A runAction:[CCFadeIn actionWithDuration:0.3f]];
    [D runAction:[CCFadeIn actionWithDuration:0.3f]];
    [I runAction:[CCFadeIn actionWithDuration:0.3f]];
    [N runAction:[CCFadeIn actionWithDuration:0.3f]];
    [G runAction:[CCFadeIn actionWithDuration:0.3f]];
}
-(void) addRelease{
    onRelease = YES;
    CCLabelTTF *release = (CCLabelTTF*)[self getChildByTag:123];
    [release setString:@"Release to refresh..."];
    CCSprite *arrow = (CCSprite*)[self getChildByTag:124];
    [arrow runAction:[CCRotateTo actionWithDuration:0.2f angle:-180]];
}
-(void) addDynamicLoading{
    [self removeChildByTag:123 cleanup:YES];
    [self removeChildByTag:124 cleanup:YES];
    [delegate runLoadTask];
    onRelease = NO;
    loading = YES;    
    int separation = PTP(0,8).y;
    position = ccp(position.x,position.y - 15);
    CCLabelTTF *L = [CCLabelTTF labelWithStringAutoSize:@"L" fontName:@"nb_strange" fontSize:12];
    CCLabelTTF *O = [CCLabelTTF labelWithStringAutoSize:@"O" fontName:@"nb_strange" fontSize:12];
    CCLabelTTF *A = [CCLabelTTF labelWithStringAutoSize:@"A" fontName:@"nb_strange" fontSize:12];
    CCLabelTTF *D = [CCLabelTTF labelWithStringAutoSize:@"D" fontName:@"nb_strange" fontSize:12];
    CCLabelTTF *I = [CCLabelTTF labelWithStringAutoSize:@"I" fontName:@"nb_strange" fontSize:12];
    CCLabelTTF *N = [CCLabelTTF labelWithStringAutoSize:@"N" fontName:@"nb_strange" fontSize:12];
    CCLabelTTF *G = [CCLabelTTF labelWithStringAutoSize:@"G" fontName:@"nb_strange" fontSize:12];
    L.position = ccp(position.x,position.y-separation*3);
    L.color = ccBLACK;
    L.rotation = -90;
    L.opacity = 0;
    O.position = ccp(position.x,position.y-separation*2);
    O.color = ccBLACK;
    O.rotation = -90;
    O.opacity = 0;
    A.position = ccp(position.x,position.y-separation);
    A.color = ccBLACK;
    A.rotation = -90;
    A.opacity = 0;
    D.position = ccp(position.x,position.y);
    D.color = ccBLACK;
    D.rotation = -90;
    D.opacity = 0;
    I.position = ccp(position.x,position.y+separation);
    I.color = ccBLACK;
    I.rotation = -90;
    I.opacity = 0;
    N.position = ccp(position.x,position.y+separation*2);
    N.color = ccBLACK;
    N.rotation = -90;
    N.opacity = 0;
    G.position = ccp(position.x,position.y+separation*3);
    G.color = ccBLACK;
    G.rotation = -90;
    G.opacity = 0;
    [self addChild:L z:0 tag:_L];
    [self addChild:O z:0 tag:_O];
    [self addChild:A z:0 tag:_A];
    [self addChild:D z:0 tag:_D];
    [self addChild:I z:0 tag:_I];
    [self addChild:N z:0 tag:_N];
    [self addChild:G z:0 tag:_G];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCCallFunc actionWithTarget:self selector:@selector(rotateLettersSideways)], nil]];
}
-(void) rotateLetters{
    CCLabelTTF *L = (CCLabelTTF*)[self getChildByTag:_L];
    CCLabelTTF *O = (CCLabelTTF*)[self getChildByTag:_O];
    CCLabelTTF *A = (CCLabelTTF*)[self getChildByTag:_A];
    CCLabelTTF *D = (CCLabelTTF*)[self getChildByTag:_D];
    CCLabelTTF *I = (CCLabelTTF*)[self getChildByTag:_I];
    CCLabelTTF *N = (CCLabelTTF*)[self getChildByTag:_N];
    CCLabelTTF *G = (CCLabelTTF*)[self getChildByTag:_G];
    [L runAction:[CCRotateTo actionWithDuration:0.3f angle:-90.0f]];
    [O runAction:[CCRotateTo actionWithDuration:0.3f angle:-90.0f]];
    [A runAction:[CCRotateTo actionWithDuration:0.3f angle:-90.0f]];
    [D runAction:[CCRotateTo actionWithDuration:0.3f angle:-90.0f]];
    [I runAction:[CCRotateTo actionWithDuration:0.3f angle:-90.0f]];
    [N runAction:[CCRotateTo actionWithDuration:0.3f angle:-90.0f]];
    [G runAction:[CCRotateTo actionWithDuration:0.3f angle:-90.0f]];
    
    [L runAction:[CCMoveTo actionWithDuration:0.3f position:G.position]];
    [O runAction:[CCMoveTo actionWithDuration:0.3f position:N.position]];
    [A runAction:[CCMoveTo actionWithDuration:0.3f position:I.position]];
    [D runAction:[CCMoveTo actionWithDuration:0.3f position:D.position]];
    [I runAction:[CCMoveTo actionWithDuration:0.3f position:A.position]];
    [N runAction:[CCMoveTo actionWithDuration:0.3f position:O.position]];
    [G runAction:[CCMoveTo actionWithDuration:0.3f position:L.position]];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCCallFunc actionWithTarget:self selector:@selector(rotateLettersSideways)], nil]];    
    
}
-(void) rotateLettersSideways{
    CCLabelTTF *L = (CCLabelTTF*)[self getChildByTag:_L];
    CCLabelTTF *O = (CCLabelTTF*)[self getChildByTag:_O];
    CCLabelTTF *A = (CCLabelTTF*)[self getChildByTag:_A];
    CCLabelTTF *D = (CCLabelTTF*)[self getChildByTag:_D];
    CCLabelTTF *I = (CCLabelTTF*)[self getChildByTag:_I];
    CCLabelTTF *N = (CCLabelTTF*)[self getChildByTag:_N];
    CCLabelTTF *G = (CCLabelTTF*)[self getChildByTag:_G];
    [L runAction:[CCRotateTo actionWithDuration:0.3f angle:90.0f]];
    [O runAction:[CCRotateTo actionWithDuration:0.3f angle:90.0f]];
    [A runAction:[CCRotateTo actionWithDuration:0.3f angle:90.0f]];
    [D runAction:[CCRotateTo actionWithDuration:0.3f angle:90.0f]];
    [I runAction:[CCRotateTo actionWithDuration:0.3f angle:90.0f]];
    [N runAction:[CCRotateTo actionWithDuration:0.3f angle:90.0f]];
    [G runAction:[CCRotateTo actionWithDuration:0.3f angle:90.0f]];
    
    [L runAction:[CCMoveTo actionWithDuration:0.3f position:G.position]];
    [O runAction:[CCMoveTo actionWithDuration:0.3f position:N.position]];
    [A runAction:[CCMoveTo actionWithDuration:0.3f position:I.position]];
    [D runAction:[CCMoveTo actionWithDuration:0.3f position:D.position]];
    [I runAction:[CCMoveTo actionWithDuration:0.3f position:A.position]];
    [N runAction:[CCMoveTo actionWithDuration:0.3f position:O.position]];
    [G runAction:[CCMoveTo actionWithDuration:0.3f position:L.position]];
    [self runAction:[CCSequence actions:[CCDelayTime actionWithDuration:1.5f],[CCCallFunc actionWithTarget:self selector:@selector(rotateLetters)], nil]];
}
-(void) disable{
    [self unschedule:@selector(moveSlide:)];
    [self runAction:[CCHide action]];
}
-(void) enable{
    [self schedule:@selector(moveSlide:)];
    [self runAction:[CCShow action]];
}
-(void) doneLoading{
    [self removeChildByTag:_L cleanup:YES];
    [self removeChildByTag:_O cleanup:YES];
    [self removeChildByTag:_A cleanup:YES];
    [self removeChildByTag:_D cleanup:YES];
    [self removeChildByTag:_I cleanup:YES];
    [self removeChildByTag:_N cleanup:YES];
    [self removeChildByTag:_G cleanup:YES];
    [self initLoading];
}
@end
