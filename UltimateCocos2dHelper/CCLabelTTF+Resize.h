//
//  CCLabelTTF+Resize.h
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 3/12/12.
//  Copyright (c) 2012 Sabor Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

@interface  CCLabelTTF (CCLabelTTF_Resize)
//Awesome CCLabelTTF that will resize automatically depending on the screen size
+ (id) labelWithStringAutoSize:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment lineBreakMode:(CCLineBreakMode)lineBreakMode fontName:(NSString*)name fontSize:(CGFloat)size;


+ (id) labelWithStringAutoSize:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size;
+ (id) labelWithStringAutoSize:(NSString*)string fontName:(NSString*)name fontSize:(CGFloat)size;
@end
