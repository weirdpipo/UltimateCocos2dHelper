//
//  AppDelegate.m
//  UltimateCocos2dHelper
//
//  Created by Phillipe Casorla Sagot on 10/31/12.
//  Copyright (c) 2012 Phillipe Casorla Sagot. All rights reserved.
//

#import "AppDelegate.h"
#import "ExampleScene.h"
#import <Parse/Parse.h>
#import "SuperReachability.h"

@implementation AppDelegate


-(void) startCocos{
    
    //Set current screen
    SET_SCREEN();
	// Init the window
	_window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	
	_director = (CCDirectorIOS*)[CCDirector sharedDirector];
    [_director setDisplayStats:NO];
	[_director setAnimationInterval:1.0/60];
	
	// GL View
	CCGLView *__glView = [CCGLView viewWithFrame:[_window bounds]
									 pixelFormat:kEAGLColorFormatRGB565
									 depthFormat:0 /* GL_DEPTH_COMPONENT24_OES */
							  preserveBackbuffer:NO
									  sharegroup:nil
								   multiSampling:NO
								 numberOfSamples:0
						  ];
	
	[_director setView:__glView];
	[_director setDelegate:self];
	_director.wantsFullScreenLayout = YES;
    
	// Retina Display ?
	[_director enableRetinaDisplay:YES];
	// Navigation Controller
	_viewController = [[UINavigationController alloc] initWithRootViewController:_director];
	_viewController.navigationBarHidden = YES;
	
	// AddSubView doesn't work on iOS6
	//[window_ addSubview:navController_.view];
    [_window setRootViewController:_viewController];
	
	[_window makeKeyAndVisible];
	
}
-(void) startParse{
    [Parse setApplicationId:@"INtH6Wh97oeR4amySoucmZmI65TofFNeJw3QXTde"
                  clientKey:@"hMzSCYZDrLSYBSe7LsXtTdO3rByAhFwdQUmBqlTS"];
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //init reachability
    [SuperReachability sharedPotatossReachability];    
    [self startParse];
    [self startCocos];
    [_director pushScene:[ExampleScene example]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	if( [_viewController visibleViewController] == _director )
		[_director pause];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	if( [_viewController visibleViewController] == _director )
		[_director stopAnimation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	if( [_viewController visibleViewController] == _director )
		[_director startAnimation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	if( [_viewController visibleViewController] == _director )
		[_director resume];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //end cocos2d director
    CC_DIRECTOR_END();
}
- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[_director setNextDeltaTimeZero:YES];
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [_director purgeCachedData];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}
- (void)dealloc
{
    [_viewController release];
    [_window release];
    [super dealloc];
}
@end
