//
//  CCAnimationHelper.m
//  SpriteBatches
//
//  Created by Steffen Itterheim on 06.08.10.
//  Copyright 2010 Steffen Itterheim. All rights reserved.
//

#import "CCAnimationHelper.h"

@implementation CCAnimation (Helper)


// Creates an animation from sprite frames.
+(CCAnimation*) animationWithFrame:(NSString*)frame frameCount:(int)frameCount delay:(float)delay
{
	// load the ship's animation frames as textures and create a sprite frame
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
	for (int i = 1; i < frameCount; i++)
	{
		NSString* file = [NSString stringWithFormat:@"%@%i.png", frame, i];
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
		[frames addObject:frame];
	}
	
	// return an animation object from all the sprite animation frames
	return [CCAnimation animationWithSpriteFrames:frames delay:delay];
}
+(CCAnimation*) animationAutoCompleteIDWithFrame:(NSString*)frame frameCount:(int)frameCount delay:(float)delay{
	// load the ship's animation frames as textures and create a sprite frame
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
	for (int i = 1; i < frameCount; i++)
	{
        NSString *index;
        if (i <= 9) {
            index = [@"" stringByAppendingFormat:@"0%i",i];
        } else {
            index = [@"" stringByAppendingFormat:@"%i",i];
        }
		NSString* file = [NSString stringWithFormat:@"%@%@.png", frame, index];
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
		[frames addObject:frame];
	}
	
	// return an animation object from all the sprite animation frames
	return [CCAnimation animationWithSpriteFrames:frames delay:delay];  
}
+(CCAnimation*) animationAutoCompleteIDWithFrame:(NSString*)frame frameCount:(int)frameCount delay:(float)delay andInitialFrame:(int)start{
	// load the ship's animation frames as textures and create a sprite frame
	NSMutableArray* frames = [NSMutableArray arrayWithCapacity:frameCount];
	for (int i = start; i < frameCount; i++)
	{
        NSString *index;
        if (i <= 9) {
            index = [@"" stringByAppendingFormat:@"0%i",i];
        } else {
            index = [@"" stringByAppendingFormat:@"%i",i];
        }
		NSString* file = [NSString stringWithFormat:@"%@%@.png", frame, index];
		CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
		CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
		[frames addObject:frame];
	}
	
	// return an animation object from all the sprite animation frames
	return [CCAnimation animationWithSpriteFrames:frames delay:delay];  
}    

@end
