//
//  CCLabelTTF+Resize.m
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 3/12/12.
//  Copyright (c) 2012 Sabor Studio. All rights reserved.
//

#import "CCLabelTTF+Resize.h"

@implementation CCLabelTTF (CCLabelTTF_Resize)

+ (id) labelWithStringAutoSize:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment lineBreakMode:(CCLineBreakMode)lineBreakMode fontName:(NSString*)name fontSize:(CGFloat)size;
{
    if (IF_IPAD()) {
        size = size * 2.5;
    }        
	return [[[self alloc] initWithString: string dimensions:dimensions hAlignment:alignment vAlignment: kCCVerticalTextAlignmentTop lineBreakMode:lineBreakMode fontName:name fontSize:size]autorelease];

}

+ (id) labelWithStringAutoSize:(NSString*)string dimensions:(CGSize)dimensions alignment:(CCTextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size
{
    if (IF_IPAD()) {
        size = size * 2.5;
    }        
	return [[[self alloc] initWithString: string dimensions:dimensions hAlignment:alignment vAlignment:kCCVerticalTextAlignmentTop fontName:name fontSize:size]autorelease];
}

+ (id) labelWithStringAutoSize:(NSString*)string fontName:(NSString*)name fontSize:(CGFloat)size
{
    if (IF_IPAD()) {
        size = size * 2.5;
    }        
	return [[[self alloc] initWithString: string fontName:name fontSize:size]autorelease];
}
@end
