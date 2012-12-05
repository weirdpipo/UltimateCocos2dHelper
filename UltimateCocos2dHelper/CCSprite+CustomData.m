//
//  CCSprite+CustomData.m
//  Potatoss
//
//  Created by Phillipe Casorla Sagot on 10/25/12.
//
//

#import "CCSprite+CustomData.h"
#import <objc/runtime.h>
static char const * const CustomNodeTag = "CustomNodeTag";
@implementation CCSprite (CCSprite_CustomData)
@dynamic customData;
// Faking instance variables in Objective-C categories with Associative References
- (id)objectTag {
    return objc_getAssociatedObject(self, CustomNodeTag);
}
/*
 By specifying OBJC_ASSOCIATION_RETAIN_NONATOMIC, we tell the runtime to retain the value for us. Other possible values are OBJC_ASSOCIATION_ASSIGN, OBJC_ASSOCIATION_COPY_NONATOMIC, OBJC_ASSOCIATION_RETAIN, OBJC_ASSOCIATION_COPY, corresponding to the familiar property declaration attributes.
 */
- (void)setObjectTag:(id)newObjectTag {
    objc_setAssociatedObject(self, CustomNodeTag, newObjectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
