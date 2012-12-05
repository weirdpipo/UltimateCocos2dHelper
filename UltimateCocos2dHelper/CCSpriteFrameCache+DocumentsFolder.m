//
//  CCSpriteFrameCache+DocumentsFolder.m
//  Potatoss
//
//  Created by Phillipe Casorla Sagot on 10/25/12.
//
//

#import "CCSpriteFrameCache+DocumentsFolder.h"

@implementation CCSpriteFrameCache (CCSpriteFrameCache_DocumentsFolder)
-(void) addSpriteFramesWithFileAtDocumentFolder:(NSString*)plist
{
    if( ! [loadedFilenames_ member:plist] ) {
        NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* path = [applicationDocumentsDir stringByAppendingPathComponent: plist];
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        NSString *texturePath = nil;
        NSDictionary *metadataDict = [dict objectForKey:@"metadata"];
        if( metadataDict )
            // try to read  texture file name from meta data
            texturePath = [metadataDict objectForKey:@"textureFileName"];
        
        if( texturePath )
        {
            // build texture path relative to plist file
            NSString *textureBase = [path stringByDeletingLastPathComponent];
            texturePath = [textureBase stringByAppendingPathComponent:texturePath];
        } else {
            // build texture path by replacing file extension
            texturePath = [path stringByDeletingPathExtension];
            texturePath = [texturePath stringByAppendingPathExtension:@"png"];
            
            CCLOG(@"cocos2d: CCSpriteFrameCache: Trying to use file '%@' as texture", texturePath);
        }
        [self addSpriteFramesWithDictionaryPublic:dict textureReference:texturePath];
		
		[loadedFilenames_ addObject:plist];

    } else
		CCLOGINFO(@"cocos2d: CCSpriteFrameCache: file already loaded: %@", plist);
}
-(void) addSpriteFramesWithDictionaryPublic:(NSDictionary*)dictionary textureReference:(id)textureReference
{
    /*
     Supported Zwoptex Formats:
     ZWTCoordinatesFormatOptionXMLLegacy = 0, // Flash Version
     ZWTCoordinatesFormatOptionXML1_0 = 1, // Desktop Version 0.0 - 0.4b
     ZWTCoordinatesFormatOptionXML1_1 = 2, // Desktop Version 1.0.0 - 1.0.1
     ZWTCoordinatesFormatOptionXML1_2 = 3, // Desktop Version 1.0.2+
     */
    NSDictionary *metadataDict = [dictionary objectForKey:@"metadata"];
    NSDictionary *framesDict = [dictionary objectForKey:@"frames"];
    
    int format = 0;
    
    // get the format
    if(metadataDict != nil)
        format = [[metadataDict objectForKey:@"format"] intValue];
    
    // check the format
    NSAssert( format >= 0 && format <= 3, @"format is not supported for CCSpriteFrameCache addSpriteFramesWithDictionary:textureFilename:");
    
    // SpriteFrame info
    CGRect rectInPixels;
    BOOL isRotated;
    CGPoint frameOffset;
    CGSize originalSize;
    
    // add real frames
    for(NSString *frameDictKey in framesDict) {
        NSDictionary *frameDict = [framesDict objectForKey:frameDictKey];
        CCSpriteFrame *spriteFrame=nil;
        if(format == 0) {
            float x = [[frameDict objectForKey:@"x"] floatValue];
            float y = [[frameDict objectForKey:@"y"] floatValue];
            float w = [[frameDict objectForKey:@"width"] floatValue];
            float h = [[frameDict objectForKey:@"height"] floatValue];
            float ox = [[frameDict objectForKey:@"offsetX"] floatValue];
            float oy = [[frameDict objectForKey:@"offsetY"] floatValue];
            int ow = [[frameDict objectForKey:@"originalWidth"] intValue];
            int oh = [[frameDict objectForKey:@"originalHeight"] intValue];
            // check ow/oh
            if(!ow || !oh)
                CCLOGWARN(@"cocos2d: WARNING: originalWidth/Height not found on the CCSpriteFrame. AnchorPoint won't work as expected. Regenerate the .plist");
            
            // abs ow/oh
            ow = abs(ow);
            oh = abs(oh);
            
            // set frame info
            rectInPixels = CGRectMake(x, y, w, h);
            isRotated = NO;
            frameOffset = CGPointMake(ox, oy);
            originalSize = CGSizeMake(ow, oh);
        } else if(format == 1 || format == 2) {
            CGRect frame = CCRectFromString([frameDict objectForKey:@"frame"]);
            BOOL rotated = NO;
            
            // rotation
            if(format == 2)
                rotated = [[frameDict objectForKey:@"rotated"] boolValue];
            
            CGPoint offset = CCPointFromString([frameDict objectForKey:@"offset"]);
            CGSize sourceSize = CCSizeFromString([frameDict objectForKey:@"sourceSize"]);
            
            // set frame info
            rectInPixels = frame;
            isRotated = rotated;
            frameOffset = offset;
            originalSize = sourceSize;
        } else if(format == 3) {
            // get values
            CGSize spriteSize = CCSizeFromString([frameDict objectForKey:@"spriteSize"]);
            CGPoint spriteOffset = CCPointFromString([frameDict objectForKey:@"spriteOffset"]);
            CGSize spriteSourceSize = CCSizeFromString([frameDict objectForKey:@"spriteSourceSize"]);
            CGRect textureRect = CCRectFromString([frameDict objectForKey:@"textureRect"]);
            BOOL textureRotated = [[frameDict objectForKey:@"textureRotated"] boolValue];
            
            // get aliases
            NSArray *aliases = [frameDict objectForKey:@"aliases"];
            for(NSString *alias in aliases) {
                if( [spriteFramesAliases_ objectForKey:alias] )
                    CCLOGWARN(@"cocos2d: WARNING: an alias with name %@ already exists",alias);
                
                [spriteFramesAliases_ setObject:frameDictKey forKey:alias];
            }
            
            // set frame info
            rectInPixels = CGRectMake(textureRect.origin.x, textureRect.origin.y, spriteSize.width, spriteSize.height);
            isRotated = textureRotated;
            frameOffset = spriteOffset;
            originalSize = spriteSourceSize;
        }
        
        NSString *textureFileName = nil;
        CCTexture2D * texture = nil;
        
        if ( [textureReference isKindOfClass:[NSString class]] )
        {
            textureFileName	= textureReference;
        }
        else if ( [textureReference isKindOfClass:[CCTexture2D class]] )
        {
            texture = textureReference;
        }
        
        if ( textureFileName )
        {
            spriteFrame = [[CCSpriteFrame alloc] initWithTextureFilename:textureFileName rectInPixels:rectInPixels rotated:isRotated offset:frameOffset originalSize:originalSize];
        }
        else
        {
            spriteFrame = [[CCSpriteFrame alloc] initWithTexture:texture rectInPixels:rectInPixels rotated:isRotated offset:frameOffset originalSize:originalSize];
        }
        
        // add sprite frame
        [spriteFrames_ setObject:spriteFrame forKey:frameDictKey];
        [spriteFrame release];
    }
}
@end
