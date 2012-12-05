//
//  ExampleScene.m
//  UltimateCocos2dHelper
//
//  Created by Phillipe Casorla Sagot on 10/31/12.
//  Copyright (c) 2012 Phillipe Casorla Sagot. All rights reserved.
//

#import "ExampleScene.h"
#import "CCLoadingTitle.h"
#import "CCLabelTTF+Resize.h"
#import "SuperReachability.h"
#import "CCSpriteFrameCache+DocumentsFolder.h"

@implementation ExampleScene
+(id) example
{
	CCScene* scene = [CCScene node];
	ExampleScene* layer = [[[self alloc] init] autorelease];
	[scene addChild:layer z:0];
	return scene;
}
-(id) init{
    if (self = [super init]) {
        CGPoint screen = PTP(480,320);
        CCLayerColor *gradient = [CCLayerColor layerWithColor:ccc4(255,255,255, 255) width:screen.x height:screen.y];
        gradient.anchorPoint = ccp(0,0);
        gradient.position = PTP(0,0);
        [self addChild:gradient z:0 tag:12];
        
        //init texture loader if there is a connection
        CCLabelTTF *label = [CCLabelTTF labelWithStringAutoSize:@"Downloading the UI Texture" fontName:@"HelveticaNeue-Light" fontSize:18];
        label.position = PTP(240,200);
        label.color = ccBLACK;
        [self addChild:label z:10 tag:10];
        CCLoadingTitle *loading = [CCLoadingTitle loadingNode:PTP(240,160)];
        [self addChild:loading z:10 tag:11];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textureLoaded:) name:@"TextureNotification" object:nil];
        [self performSelector:@selector(startLoadingTexture) withObject:nil afterDelay:1.0f];
    }
    return self;
}
-(void) startLoadingTexture{
    textureLoader = [[TextureLoader alloc] initWithNotificationName:@"TextureNotification"];
    [textureLoader loadTexture:@"Layer0"];
}
-(void) textureLoaded:(NSNotification*) notification{
    NSNumber *result = notification.object;
    //call a function on the main thread
    [self performSelectorOnMainThread:@selector(textureLoadedMain:) withObject:result waitUntilDone:NO];
}
-(void) textureLoadedMain:(NSNumber*) result{
    //check if we loaded the texture withoutproblems    
    if ([result boolValue]) {
        [self removeChildByTag:10 cleanup:YES];
        [self removeChildByTag:11 cleanup:YES];
        [self removeChildByTag:12 cleanup:YES];
        CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
        //TEXTURES ARE LOADED FROM THE DOCUMENTS FOLDER, BECAUSE WE ARE LOADING TEXTURES DOWNLOADED FROM THE BACKEND
        [frameCache addSpriteFramesWithFileAtDocumentFolder:TEXTURE_NAME_FULL(@"Layer0",YES)];
        CCSprite* menuSprite = [CCSprite spriteWithSpriteFrameName:@"Layer0.png"];
        menuSprite.anchorPoint = ccp(0,0);
        menuSprite.position =ccp(0,0);
        [self addChild:menuSprite z:0 tag:0];
    } else {
        [self removeChildByTag:11 cleanup:YES];
        CCLabelTTF *label = (CCLabelTTF*)[self getChildByTag:10];
        [label setString: @"Problem Loading Texture"];
    }
}
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [textureLoader release];
    [super dealloc];
}
@end
