//
//  PTDirector.h
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 3/7/12.
//  Copyright (c) 2012 Sabor Studio. All rights reserved.
//
#import "cocos2d.h"
static CGSize currentPTPSize;
static inline void SET_SCREEN(){
	CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    currentPTPSize = CGSizeMake(screenBounds.size.height * screenScale, screenBounds.size.width * screenScale);    
}
static inline CGPoint
PTP(const CGFloat x, const CGFloat y)
{
    SET_SCREEN();
    if(currentPTPSize.width == 1024){
        return ccp(x *2.15,y * 2.3);//(768/320) );
    } else if(currentPTPSize.width == 2048){
        return ccp(x *2.15,y * 2.3);//(768/320) );//return ccp(x*4.2,y* 4.8);//(1536/320));
    }
    return ccp(x,y);
}
static inline CGSize PTPSIZE(){
    return CGSizeMake(480, 320);
}
static inline BOOL IF_IPAD(){
    SET_SCREEN();
    if(currentPTPSize.width >= 1024 && currentPTPSize.width != 1136){
        return TRUE;
    }
    return FALSE;
}
static inline BOOL IF_IPAD3(){
    SET_SCREEN();
    if(currentPTPSize.width >= 2048){
        return TRUE;
    }
    return FALSE;
}
static inline NSString* TEXTURE_NAME_FULL(NSString *name,BOOL plist){
    SET_SCREEN();
    NSString *ext;
    if (plist) {
        ext = @".plist";
    } else {
        ext = @".pvr.ccz";
    }
    if (currentPTPSize.width == 960 || currentPTPSize.width == 1136) {
        return [name stringByAppendingFormat:@"%@%@",@"-hd",ext];
    } else if(currentPTPSize.width == 1024){//ipad2
        return [name stringByAppendingFormat:@"%@%@",@"-ipad",ext];//-ipad
    } else if(currentPTPSize.width == 2048){//ipad3
        return [name stringByAppendingFormat:@"%@%@",@"-ipad3",ext];//-ipad-hd
    }
    return [name stringByAppendingString:ext];
}
static inline NSString* LOCATE_FILE(NSString *name){
    SET_SCREEN();
    if (currentPTPSize.width == 960 || currentPTPSize.width == 1136) {
        return [name stringByAppendingString:@"-hd"];
    } else if(currentPTPSize.width == 1024){//ipad2
        return [name stringByAppendingString:@"-ipad"];//-ipad
    } else if(currentPTPSize.width == 2048){//ipad3
        return [name stringByAppendingString:@"-ipad3"];//-ipad-hd
    }
    return name;
}
static inline NSString* TEXTURE_CCZ(NSString *name){
    SET_SCREEN();
    NSString *ext = @".pvr.ccz";
    if (currentPTPSize.width == 960 || currentPTPSize.width == 1136) {
        return [name stringByAppendingFormat:@"%@%@",@"-hd",ext];
    } else if(currentPTPSize.width == 1024){//ipad2
        return [name stringByAppendingFormat:@"%@%@",@"-ipad",ext];//-ipad
    } else if(currentPTPSize.width == 2048){//ipad3
        return [name stringByAppendingFormat:@"%@%@",@"-ipad3",ext];//-ipad-hd
    }
    return [name stringByAppendingString:ext];
}