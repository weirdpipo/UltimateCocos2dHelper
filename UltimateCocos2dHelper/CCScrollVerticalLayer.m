//
//  CCScrollVerticalLayer.m
//  Potatoss-5
//
//  Created by Phillipe Casorla Sagot on 6/20/12.
//  Copyright (c) 2012 Sabor Studio. All rights reserved.
//

#import "CCScrollVerticalLayer.h"
#import "CCGL.h"
#import "CCTouchDispatcher+Optimize.h"

enum 
{
	kCCScrollLayerStateIdle,
	kCCScrollLayerStateSliding,
};

@interface CCScrollVerticalLayer ()

- (int) pageNumberForPosition: (CGPoint) position;

@end

@implementation CCScrollVerticalLayer

@synthesize delegate = delegate_;
@synthesize minimumTouchLengthToSlide = minimumTouchLengthToSlide_;
@synthesize minimumTouchLengthToChangePage = minimumTouchLengthToChangePage_;
@synthesize marginOffset = marginOffset_;
@synthesize currentScreen = currentScreen_;
@synthesize showPagesIndicator = showPagesIndicator_;
@synthesize pagesIndicatorPosition = pagesIndicatorPosition_;
@synthesize pagesIndicatorNormalColor = pagesIndicatorNormalColor_;
@synthesize pagesIndicatorSelectedColor = pagesIndicatorSelectedColor_;
@synthesize pagesheightOffset = pagesheightOffset_;
@synthesize pages = layers_;
@synthesize stealTouches = stealTouches_;

@dynamic totalScreens;
- (int) totalScreens
{
	return [layers_ count];
}

+(id) nodeWithLayers:(NSArray *)layers heightOffset: (int) heightOffset
{
	return [[[self alloc] initWithLayers: layers heightOffset:heightOffset] autorelease];
}

-(id) initWithLayers:(NSArray *)layers heightOffset: (int) heightOffset
{
	if ( (self = [super init]) )
	{
		NSAssert([layers count], @"CCScrollLayer#initWithLayers:heightOffset: you must provide at least one layer!");
		
		// Enable Touches/Mouse.
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
		self.isTouchEnabled = YES;
#elif defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
        self.isMouseEnabled = YES;
#endif
		
		self.stealTouches = YES;
		
		// Set default minimum touch length to scroll.
		self.minimumTouchLengthToSlide = 30.0f;
		self.minimumTouchLengthToChangePage = 100.0f;
		
		self.marginOffset = [[CCDirector sharedDirector] winSize].height;
		
		// Show indicator by default.
		self.showPagesIndicator = YES;
		self.pagesIndicatorPosition = ccp(0.5f * self.contentSize.height, ceilf ( self.contentSize.height / 8.0f ));
		self.pagesIndicatorNormalColor = ccc4(0x96,0x96,0x96,0xFF);
        self.pagesIndicatorSelectedColor = ccc4(0xFF,0xFF,0xFF,0xFF);
        
		// Set up the starting variables
		currentScreen_ = 0;	
		
		// Save offset.
		self.pagesheightOffset = heightOffset;			
		
		// Save array of layers.
		layers_ = [[NSMutableArray alloc] initWithArray:layers copyItems:NO];
        
		[self updatePages];			
		
	}
	return self;
}

- (void) dealloc
{
	self.delegate = nil;
	
	[layers_ release];
	layers_ = nil;
	
	[super dealloc];
}

- (void) updatePages
{
	// Loop through the array and add the screens if needed.
	int i = 0;
	for (CCLayer *l in layers_)
	{
		l.anchorPoint = ccp(0,0);
		l.contentSize = [CCDirector sharedDirector].winSize;
		l.position = ccp(0, (i * (self.contentSize.height - self.pagesheightOffset)));
		if (!l.parent)
			[self addChild:l];
		i++;
	}
}

#pragma mark CCLayer Methods ReImpl

- (void) visit
{
	[super visit];//< Will draw after glPopScene. 
	
	if (self.showPagesIndicator)
	{
		int totalScreens = [layers_ count];
		
		// Prepare Points Array
		CGFloat n = (CGFloat)totalScreens; //< Total points count in CGFloat.
		CGFloat pY = self.pagesIndicatorPosition.y; //< Points y-coord in parent coord sys.
		CGFloat d = 16.0f; //< Distance between points.
		CGPoint points[totalScreens];	
		for (int i=0; i < totalScreens; ++i)
		{
			CGFloat pX = self.pagesIndicatorPosition.y + d * ( (CGFloat)i - 0.5f*(n-1.0f) );
			points[i] = ccp (pX, pY);
		}
		
		// Set GL Values
		ccGLEnable(CC_GL_BLEND);
		
        ccGLBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
		ccPointSize( 6.0 * CC_CONTENT_SCALE_FACTOR() );
		
		// Draw Gray Points
		ccDrawColor4B(pagesIndicatorNormalColor_.r,
                   pagesIndicatorNormalColor_.g,
                   pagesIndicatorNormalColor_.b,
                   pagesIndicatorNormalColor_.a);
		ccDrawPoints( points, totalScreens );
		
		// Draw White Point for Selected Page	
		ccDrawColor4B(pagesIndicatorSelectedColor_.r,
                   pagesIndicatorSelectedColor_.g,
                   pagesIndicatorSelectedColor_.b,
                   pagesIndicatorSelectedColor_.a);
		ccDrawPoint(points[currentScreen_]);
		
		// Restore GL Values
		ccPointSize(1.0f);
		//glDisable(GL_POINT_SMOOTH);
	}
}

#pragma mark Moving To / Selecting Pages

- (void) moveToPageEnded
{
    if (prevScreen_ != currentScreen_)
    {
        if ([self.delegate respondsToSelector:@selector(scrollLayer:scrolledToPageNumber:)])
            [self.delegate scrollLayer: self scrolledToPageNumber: currentScreen_];
    }
    
    prevScreen_ = currentScreen_ = [self pageNumberForPosition:self.position];
}

- (int) pageNumberForPosition: (CGPoint) position
{
	CGFloat pageFloat = - self.position.y / (self.contentSize.height - self.pagesheightOffset);
	int pageNumber = ceilf(pageFloat);
	if ( (CGFloat)pageNumber - pageFloat  >= 0.5f)
		pageNumber--;
	
	
	pageNumber = MAX(0, pageNumber);
	pageNumber = MIN([layers_ count] - 1, pageNumber);
	
	return pageNumber;
}


- (CGPoint) positionForPageWithNumber: (int) pageNumber
{
	return ccp(0.0f, - pageNumber * (self.contentSize.height - self.pagesheightOffset));
}

-(void) moveToPage:(int)page
{	
    if (page < 0 || page >= [layers_ count]) {
        //CCLOGERROR(@"CCScrollLayer#moveToPage: %d - wrong page number, out of bounds. ", page);
		return;
    }
    
	id changePage = [CCMoveTo actionWithDuration:0.3 position: [self positionForPageWithNumber: page]];
	changePage = [CCSequence actions: changePage,[CCCallFunc actionWithTarget:self selector:@selector(moveToPageEnded)], nil];
    [self runAction:changePage];
    currentScreen_ = page;
    
}

-(void) selectPage:(int)page
{
    if (page < 0 || page >= [layers_ count]) {
        //CCLOGERROR(@"CCScrollLayer#selectPage: %d - wrong page number, out of bounds. ", page);
		return;
    }
	
    self.position = [self positionForPageWithNumber: page];
    prevScreen_ = currentScreen_;
    currentScreen_ = page;
	
}

#pragma mark Dynamic Pages Control

- (void) addPage: (CCLayer *) aPage
{
	[self addPage: aPage withNumber: [layers_ count]];
}

- (void) addPage: (CCLayer *) aPage withNumber: (int) pageNumber
{
	pageNumber = MIN(pageNumber, [layers_ count]);
	pageNumber = MAX(pageNumber, 0);
	
	[layers_ insertObject: aPage atIndex: pageNumber];
	
	[self updatePages];
	
	[self moveToPage: currentScreen_];
}

- (void) removePage: (CCLayer *) aPage
{
	[layers_ removeObject: aPage];
	[self removeChild: aPage cleanup: YES];
	
	[self updatePages];
	
    prevScreen_ = currentScreen_;
	currentScreen_ = MIN(currentScreen_, [layers_ count] - 1);
	[self moveToPage: currentScreen_];
}

- (void) removePageWithNumber: (int) page
{
	if (page >= 0 && page < [layers_ count])
		[self removePage:[layers_ objectAtIndex: page]];
}

#pragma mark Touches
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED

/** Register with more priority than CCMenu's but don't swallow touches. */
-(void) registerWithTouchDispatcher
{
	CCTouchDispatcher *dispatcher = [[CCDirector sharedDirector] touchDispatcher];    
	[dispatcher addTargetedDelegate:self priority:kCCMenuHandlerPriority - 1 swallowsTouches:NO];
}

/** Hackish stuff - stole touches from other CCTouchDispatcher targeted delegates. 
 Used to claim touch without receiving ccTouchBegan. */
- (void) claimTouch: (UITouch *) aTouch
{
	CCTouchDispatcher *dispatcher = [[CCDirector sharedDirector] touchDispatcher];    
	// Enumerate through all targeted handlers.
	for ( CCTargetedTouchHandler *handler in [dispatcher targetedHandlers] )
	{
		// Only our handler should claim the touch.
		if (handler.delegate == self)
		{
			if (![handler.claimedTouches containsObject: aTouch])
			{
				[handler.claimedTouches addObject: aTouch];
			}
			return;
		}
	}
}

- (void) cancelAndStoleTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Throw Cancel message for everybody in TouchDispatcher and do not react on this.
	stealingTouchInProgress_ = YES;
    [[CCDirector sharedDirector].touchDispatcher touchesCancelled: [NSSet setWithObject: touch] withEvent:event];
	stealingTouchInProgress_ = NO;
	
    //< after doing this touch is already removed from all targeted handlers
	
    // Squirrel away the touch
    [self claimTouch: touch];
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event 
{
    // Do not cancel touch, if this method is called from cancelAndStoleTouch:
    if (stealingTouchInProgress_)
		return;
	
    if( scrollTouch_ == touch ) {
        scrollTouch_ = nil;
        [self selectPage: currentScreen_];
    }
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( scrollTouch_ == nil ) {
		scrollTouch_ = touch;
	} else {
		return NO;
	}
	
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	startSwipe_ = touchPoint.y;
	state_ = kCCScrollLayerStateIdle;
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( scrollTouch_ != touch ) {
		return;
	}
	
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	
	// If finger is dragged for more distance then minimum - start sliding and cancel pressed buttons.
	// Of course only if we not already in sliding mode
	if ( (state_ != kCCScrollLayerStateSliding) 
		&& (fabsf(touchPoint.y-startSwipe_) >= self.minimumTouchLengthToSlide) )
	{
		state_ = kCCScrollLayerStateSliding;
		
		// Avoid jerk after state change.
		startSwipe_ = touchPoint.y;
		
		if (self.stealTouches)
			[self cancelAndStoleTouch: touch withEvent: event];
		
		if ([self.delegate respondsToSelector:@selector(scrollLayerScrollingStarted:)])
		{
			[self.delegate scrollLayerScrollingStarted: self];
		}
	}
	
	if (state_ == kCCScrollLayerStateSliding)
	{
		CGFloat desiredX = (- currentScreen_ * (self.contentSize.height - self.pagesheightOffset)) + touchPoint.y - startSwipe_;
		int page = [self pageNumberForPosition:ccp(0,desiredX)];
		CGFloat offset = desiredX - [self positionForPageWithNumber:page].y; 
		if ((page == 0 && offset > 0) || (page == [layers_ count] - 1 && offset < 0))
			offset -= marginOffset_ * offset / [[CCDirector sharedDirector] winSize].height;
		else
			offset = 0;
		self.position = ccp(0,desiredX - offset);
	}
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	if( scrollTouch_ != touch )
		return;
	scrollTouch_ = nil;
	
	CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
	
	int selectedPage = currentScreen_;
	CGFloat delta = touchPoint.y - startSwipe_;
	if (fabsf(delta) >= self.minimumTouchLengthToChangePage)
	{
		selectedPage = [self pageNumberForPosition:self.position];
		if (selectedPage == currentScreen_)
		{
			if (delta < 0.f && selectedPage < [layers_ count] - 1)
				selectedPage++;
			else if (delta > 0.f && selectedPage > 0)
				selectedPage--;
		}
	}
	[self moveToPage:selectedPage];	
}

#endif

#pragma mark Mouse
#ifdef __MAC_OS_X_VERSION_MAX_ALLOWED

- (NSInteger) mouseDelegatePriority
{
	return kCCMenuMousePriority - 1;
}

-(BOOL) ccMouseDown:(NSEvent*)event
{
	CGPoint touchPoint = [[CCDirector sharedDirector] convertEventToGL: event];
	
	startSwipe_ = touchPoint.y;
	state_ = kCCScrollLayerStateIdle;
	
	return NO;
}

-(BOOL) ccMouseDragged:(NSEvent*)event
{
	CGPoint touchPoint = [[CCDirector sharedDirector] convertEventToGL:event];
	
	// If mouse is dragged for more distance then minimum - start sliding.
	if ( (state_ != kCCScrollLayerStateSliding) 
		&& (fabsf(touchPoint.y-startSwipe_) >= self.minimumTouchLengthToSlide) )
	{
		state_ = kCCScrollLayerStateSliding;
		
		// Avoid jerk after state change.
		startSwipe_ = touchPoint.y;
		
		if ([self.delegate respondsToSelector:@selector(scrollLayerScrollingStarted:)])
		{
			[self.delegate scrollLayerScrollingStarted: self];
		}
	}
	
	if (state_ == kCCScrollLayerStateSliding)
    {
        CGFloat desiredX = (- currentScreen_ * (self.contentSize.height - self.pagesheightOffset)) + touchPoint.y - startSwipe_;
        int page = [self pageNumberForPosition:ccp(0,desiredX)]; 		
        CGFloat offset = desiredX - [self positionForPageWithNumber:page].y;  		
        if ((page == 0 && offset > 0) || (page == [layers_ count] - 1 && offset < 0))        	
            offset -= marginOffset_ * offset / [[CCDirector sharedDirector] winSize].height;
        else        
            offset = 0;
 		
        self.position = ccp(0,desiredX - offset);
    }
	
	return NO;
}

- (BOOL)ccMouseUp:(NSEvent *)event
{
	CGPoint touchPoint = [[CCDirector sharedDirector] convertEventToGL:event];
	
	int selectedPage = currentScreen_;
	CGFloat delta = touchPoint.y - startSwipe_;
	if (fabsf(delta) >= self.minimumTouchLengthToChangePage)
	{
		selectedPage = [self pageNumberForPosition:self.position];
		if (selectedPage == currentScreen_)
		{
			if (delta < 0.f && selectedPage < [layers_ count] - 1)
				selectedPage++;
			else if (delta > 0.f && selectedPage > 0)
				selectedPage--;
		}
	}
	[self moveToPage:selectedPage];		
	
	return NO;
}

- (BOOL)ccScrollWheel:(NSEvent *)theEvent
{
	CGFloat deltaX = [theEvent deltaX];
	
	CGPoint newPos = ccpAdd( self.position, ccp(0.0f,deltaX) );
	newPos.y = MIN(newPos.y, [self positionForPageWithNumber: 0].y);
	newPos.y = MAX(newPos.y, [self positionForPageWithNumber: [layers_ count] - 1].y);
	
	self.position = newPos;
    prevScreen_ = currentScreen_;
	currentScreen_ = [self pageNumberForPosition:self.position];
    
    // Inform delegate about new currentScreen.
    if (prevScreen_ != currentScreen_)
    {
        if ([self.delegate respondsToSelector:@selector(scrollLayer:scrolledToPageNumber:)])
            [self.delegate scrollLayer: self scrolledToPageNumber: currentScreen_];
    }
    
    prevScreen_ = currentScreen_;
	
	return NO;
	
}

#endif

@end
