//
//  PotatossReachability.h
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 7/2/12.
//  Copyright (c) 2012 Sabor Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface SuperReachability : NSObject
{
    Reachability *reachability;
    BOOL          connected;
}
-(BOOL) isReachable;
+(SuperReachability*) sharedPotatossReachability;
@end
