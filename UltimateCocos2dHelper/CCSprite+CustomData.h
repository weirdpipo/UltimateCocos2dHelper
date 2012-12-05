//
//  CCSprite+CustomData.h
//  Potatoss
//
//  Created by Phillipe Casorla Sagot on 10/25/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCSprite (CCSprite_CustomData)
/** Save useful data right on a sprite, gotta release it */
@property (nonatomic,retain) NSObject *customData;
@end
