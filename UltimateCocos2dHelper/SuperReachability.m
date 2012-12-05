//
//  PotatossReachability.m
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 7/2/12.
//  Copyright (c) 2012 Sabor Studio. All rights reserved.
//

#import "SuperReachability.h"

@implementation SuperReachability
-(BOOL) isReachable{
    return connected;
}
-(void) reachabilityChanged:(NSNotification *)notification{
    if ([reachability isReachable]) {
        connected = YES;
    } else {
        connected = NO;        
    }
}
#pragma mark Singleton stuff
static SuperReachability *instanceOfPotatossReachability;
+(id) alloc
{
	@synchronized(self)	
	{
		NSAssert(instanceOfPotatossReachability == nil, @"Attempted to allocate a second instance of the singleton: PotatossReachability");
		instanceOfPotatossReachability = [[super alloc] retain];
		return instanceOfPotatossReachability;
	}
	
	// to avoid compiler warning
	return nil;
}
-(id) init
{
	if ((self = [super init]))
	{ 
        reachability = [Reachability reachabilityWithHostname:@"www.google.com"]; 
        //reachibility notification
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];         
        [reachability startNotifier];
    }
    return self;
}
+(SuperReachability*) sharedPotatossReachability
{
	@synchronized(self)
	{
		if (instanceOfPotatossReachability == nil)
		{
			[[SuperReachability alloc] init];
		}
		
		return instanceOfPotatossReachability;
	}
	
	// to avoid compiler warning
	return nil;
}
-(void) dealloc
{	
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];        
    [reachability stopNotifier];
	[instanceOfPotatossReachability release];
	instanceOfPotatossReachability = nil;
	[super dealloc];
}
@end
