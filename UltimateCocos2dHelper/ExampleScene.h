//
//  ExampleScene.h
//  UltimateCocos2dHelper
//
//  Created by Phillipe Casorla Sagot on 10/31/12.
//  Copyright (c) 2012 Phillipe Casorla Sagot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TextureLoader.h"
@interface ExampleScene : CCLayer
{
    TextureLoader *textureLoader;
}
+(id) example;
@end
