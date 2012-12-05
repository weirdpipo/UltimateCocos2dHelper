//
//  CCLoadingTitle.m
//  Potatoss-5
//
//  Created by darkslave on 8/24/12.
//
//

#import "CCLoadingTitle.h"
#import "CCLabelTTF+Resize.h"

@implementation CCLoadingTitle
+(id) loadingNode:(CGPoint)position{
    return [[[self alloc] initLoadingNode:position andColor:ccBLACK andFont:nil] autorelease];
}
+(id) loadingNode:(CGPoint)position andColor:(ccColor3B)color{
    return [[[self alloc] initLoadingNode:position andColor:color andFont:nil] autorelease];
}
+(id) loadingNode:(CGPoint)position andColor:(ccColor3B)color andFont:(NSString*)fontName{
    return [[[self alloc] initLoadingNode:position andColor:color andFont:fontName] autorelease];
}
-(id) initLoadingNode:(CGPoint)position andColor:(ccColor3B)color andFont:(NSString*)fontName{
    if (self = [super init]) {
        int separation = PTP(15,0).x;
        if (fontName == nil) {
            fontName = @"HelveticaNeue-Light";
        }
        CCLabelTTF *L = [CCLabelTTF labelWithStringAutoSize:@"L" fontName:fontName fontSize:18];
        CCLabelTTF *O = [CCLabelTTF labelWithStringAutoSize:@"O" fontName:fontName fontSize:18];
        CCLabelTTF *A = [CCLabelTTF labelWithStringAutoSize:@"A" fontName:fontName fontSize:18];
        CCLabelTTF *D = [CCLabelTTF labelWithStringAutoSize:@"D" fontName:fontName fontSize:18];
        CCLabelTTF *I = [CCLabelTTF labelWithStringAutoSize:@"I" fontName:fontName fontSize:18];
        CCLabelTTF *N = [CCLabelTTF labelWithStringAutoSize:@"N" fontName:fontName fontSize:18];
        CCLabelTTF *G = [CCLabelTTF labelWithStringAutoSize:@"G" fontName:fontName fontSize:18];
        L.position = ccp(position.x-separation*3,position.y);
        L.color = color;
        O.position = ccp(position.x-separation*2,position.y);
        O.color = color;
        A.position = ccp(position.x-separation,position.y);
        A.color = color;
        D.position = ccp(position.x,position.y);
        D.color = color;
        I.position = ccp(position.x+separation,position.y);
        I.color = color;
        N.position = ccp(position.x+separation*2,position.y);
        N.color = color;
        G.position = ccp(position.x+separation*3,position.y);
        G.color = color;
        [self addChild:L z:0 tag:_L];
        [self addChild:O z:0 tag:_O];
        [self addChild:A z:0 tag:_A];
        [self addChild:D z:0 tag:_D];
        [self addChild:I z:0 tag:_I];
        [self addChild:N z:0 tag:_N];
        [self addChild:G z:0 tag:_G];
        [self letTheFun];
    }
    return self;
}
-(void) letTheFun{
    CCLabelTTF *L = (CCLabelTTF*)[self getChildByTag:_L];
    [L runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.1f scale:1.3f],[CCScaleTo actionWithDuration:0.1f scale:1.0f],[CCCallFunc actionWithTarget:self selector:@selector(letO)], nil]];
}
-(void) letO{
    CCLabelTTF *O = (CCLabelTTF*)[self getChildByTag:_O];
    [O runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.1f scale:1.3f],[CCScaleTo actionWithDuration:0.1f scale:1.0f],[CCCallFunc actionWithTarget:self selector:@selector(letA)], nil]];
}
-(void) letA{
    CCLabelTTF *A = (CCLabelTTF*)[self getChildByTag:_A];
    [A runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.1f scale:1.3f],[CCScaleTo actionWithDuration:0.1f scale:1.0f],[CCCallFunc actionWithTarget:self selector:@selector(letD)], nil]];
}
-(void) letD{
    CCLabelTTF *D = (CCLabelTTF*)[self getChildByTag:_D];
    [D runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.1f scale:1.3f],[CCScaleTo actionWithDuration:0.1f scale:1.0f],[CCCallFunc actionWithTarget:self selector:@selector(letI)], nil]];
}
-(void) letI{
    CCLabelTTF *I = (CCLabelTTF*)[self getChildByTag:_I];
    [I runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.1f scale:1.3f],[CCScaleTo actionWithDuration:0.1f scale:1.0f],[CCCallFunc actionWithTarget:self selector:@selector(letN)], nil]];
}
-(void) letN{
    CCLabelTTF *N = (CCLabelTTF*)[self getChildByTag:_N];
    [N runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.3f scale:1.3f],[CCScaleTo actionWithDuration:0.1f scale:1.0f],[CCCallFunc actionWithTarget:self selector:@selector(letG)], nil]];
}
-(void) letG{
    CCLabelTTF *G = (CCLabelTTF*)[self getChildByTag:_G];
    [G runAction:[CCSequence actions:[CCScaleTo actionWithDuration:0.3f scale:1.3f],[CCScaleTo actionWithDuration:0.1f scale:1.0f],[CCCallFunc actionWithTarget:self selector:@selector(letTheFun)], nil]];
}
@end
