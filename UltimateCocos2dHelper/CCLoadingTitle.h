//
//  CCLoadingTitle.h
//  Potatoss-5
//
//  Created by darkslave on 8/24/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
typedef  enum{
    _L = 0,
    _O = 1,
    _A = 2,
    _D = 3,
    _I = 4,
    _N = 5,
    _G = 6
}LoadingLetters;
//Beautiful HUD to use anywhere you need to Load something
@interface CCLoadingTitle : CCNode

+(id) loadingNode:(CGPoint)position;
+(id) loadingNode:(CGPoint)position andColor:(ccColor3B)color;
+(id) loadingNode:(CGPoint)position andColor:(ccColor3B)color andFont:(NSString*)fontName;
-(id) initLoadingNode:(CGPoint)position andColor:(ccColor3B)color andFont:(NSString*)fontName;
@end
