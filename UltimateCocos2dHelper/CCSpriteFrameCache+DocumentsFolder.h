//
//  CCSpriteFrameCache+DocumentsFolder.h
//  Potatoss
//
//  Created by Phillipe Casorla Sagot on 10/25/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@interface CCSpriteFrameCache (CCSpriteFrameCache_DocumentsFolder)
/** Adds multiple Sprite Frames from a plist file that was saved on the documents folder, useful when downloading textures from a server instead of having them on the bundle path
 */
-(void) addSpriteFramesWithFileAtDocumentFolder:(NSString*)plist;
//enable to call directly the addSpriteFramesWithDictionaryPublic, in cocos2d 2.0 this method is private
-(void) addSpriteFramesWithDictionaryPublic:(NSDictionary*)dictionary textureReference:(id)textureReference;
@end
