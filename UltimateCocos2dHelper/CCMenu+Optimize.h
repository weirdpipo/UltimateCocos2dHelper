//
//  CCMenu+Optimize.h
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 7/5/12.
//  Copyright (c) 2012 Sabor Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//CCMenu made easy, great for creating buttons just from spriteNames or labels in one line
@interface CCMenu (CCMenu_Optimize)

+(id) menuWithSpriteName:(NSString*)spriteName target:(id)target selector:(SEL)selector;
+(id) menuWithSpriteName:(NSString*)spriteName target:(id)target selector:(SEL)selector andUserData:(NSObject*)data;
+(id) menuWithLabel:(CCLabelTTF *)label target:(id)target selector:(SEL)selector;
@end
