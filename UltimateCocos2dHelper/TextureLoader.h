//
//  TextureLoader.h
//  UltimateCocos2dHelper
//
//  Created by Phillipe Casorla Sagot on 10/31/12.
//  Copyright (c) 2012 Phillipe Casorla Sagot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextureLoader : NSObject

@property(nonatomic,copy)     NSString *notificationName;
-(id) initWithNotificationName:(NSString*)name;
-(void) loadTexture:(NSString*)textureName;
@end
