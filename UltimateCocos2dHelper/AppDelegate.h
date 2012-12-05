//
//  AppDelegate.h
//  UltimateCocos2dHelper
//
//  Created by Phillipe Casorla Sagot on 10/31/12.
//  Copyright (c) 2012 Phillipe Casorla Sagot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,CCDirectorDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController	*viewController;
@property (readonly) CCDirectorIOS *director;
@end
