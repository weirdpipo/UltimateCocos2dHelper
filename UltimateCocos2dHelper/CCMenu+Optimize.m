//
//  CCMenu+Optimize.m
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 7/5/12.
//  Copyright (c) 2012 Sabor Studio. All rights reserved.
//

#import "CCMenu+Optimize.h"
#import "CCLabelTTF+Resize.h"
#import "CCSprite+CustomData.h"

@implementation CCMenu (CCMenu_Optimize)
+(id) menuWithSpriteName:(NSString*)spriteName target:(id)target selector:(SEL)selector{
    CCSprite* spriteNormal = [CCSprite spriteWithSpriteFrameName:spriteName];
    CCSprite* spriteNormal2 = [CCSprite spriteWithSpriteFrameName:spriteName];   
    CCMenuItemSprite *item = [CCMenuItemSprite itemWithNormalSprite:spriteNormal
                                                              selectedSprite:spriteNormal2 target:target selector:selector];
    
    CCMenu *menu = [CCMenu menuWithItems:item, nil];
    return menu;
}
+(id) menuWithSpriteName:(NSString*)spriteName target:(id)target selector:(SEL)selector andUserData:(NSObject*)data{
    CCSprite* spriteNormal = [CCSprite spriteWithSpriteFrameName:spriteName];
    spriteNormal.customData = data;
    CCSprite* spriteNormal2 = [CCSprite spriteWithSpriteFrameName:spriteName];   
    CCMenuItemSprite *item = [CCMenuItemSprite itemWithNormalSprite:spriteNormal
                                                     selectedSprite:spriteNormal2 target:target selector:selector];
    
    CCMenu *menu = [CCMenu menuWithItems:item, nil];
    return menu;    
}
+(id) menuWithLabel:(CCLabelTTF *)label target:(id)target selector:(SEL)selector{
    CCMenuItemSprite *item = [CCMenuItemLabel itemWithLabel:label target:target selector:selector];
    
    CCMenu *menu = [CCMenu menuWithItems:item, nil];
    return menu;
}
@end
