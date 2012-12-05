//
//  TextureLoader.m
//  UltimateCocos2dHelper
//
//  Created by Phillipe Casorla Sagot on 10/31/12.
//  Copyright (c) 2012 Phillipe Casorla Sagot. All rights reserved.
//

#import "TextureLoader.h"
#import <Parse/Parse.h>
#import "cocos2d.h"
#import "SuperReachability.h"
@implementation TextureLoader
-(id) initWithNotificationName:(NSString*)name{
    if (self = [super init]) {
        self.notificationName = name;
    }
    return self;
}
-(BOOL) savePFFile:(PFFile*)file withPath:(NSString*)path{
    if(file != NULL && ![file isKindOfClass:[NSNull class]]){
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
            NSData *plistData = [file getData];
            BOOL write =  [plistData writeToFile:path atomically:YES];
            if (write) {
                //create a url from the string path and marked it as non-backed on icloud
                NSURL *urlPath = [NSURL fileURLWithPath:path isDirectory:NO];
                NSError *error = nil;
                BOOL success = [urlPath setResourceValue: [NSNumber numberWithBool: YES]
                                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
                if(!success){
                    NSLog(@"Error excluding %@ from backup %@", [urlPath lastPathComponent], error);
                }
                CCLOG(@"------FILES YES %@",file.name);
            } else {
                CCLOG(@"------FILES NO %@",file.name);
            }
            return write;
        }
        return YES;
    }
    return NO;
}

-(void) bringTexturesASYNC:(id)cacheObj{
    
    NSString *textureName = (NSString*)cacheObj;
    //ABSOLUTE FILE NAMES
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* texturePlist = [applicationDocumentsDir stringByAppendingPathComponent:TEXTURE_NAME_FULL(textureName,YES)];
    NSString* textureNameFile = [applicationDocumentsDir stringByAppendingPathComponent:TEXTURE_CCZ(textureName)];
    
    //Download the texture/plist files from Parse 
    PFQuery *queryForTexture = [PFQuery queryWithClassName:@"Texture"];
    NSString *textureDeviceName = LOCATE_FILE(textureName);
    [queryForTexture whereKey:@"TextureName" equalTo:textureDeviceName];
    queryForTexture.cachePolicy = kPFCachePolicyCacheElseNetwork;
    PFObject *object = [queryForTexture getFirstObject];
    if (object != nil) {
        //Save the pListFile
        PFFile *plistFileL = [object objectForKey:@"PListFile"];
        BOOL plistOKL = [self savePFFile:plistFileL withPath:texturePlist];
        //Save the texture
        PFFile *textureFileL = [object objectForKey:@"TextureFile"];
        BOOL textureOKL = [self savePFFile:textureFileL withPath:textureNameFile];

        if (plistOKL && textureOKL) {
            //FINISHED GETTING AND SAVING ALL THE FILES
            [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:@(YES)];
        } else {
            //error downloading levels
            [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:@(NO)];
        }
    } else {
        //error downloading levels
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:@(NO)];
    }
    
}
-(void) loadTexture:(NSString*)textureName {
    if ([[SuperReachability sharedPotatossReachability] isReachable]) {
        NSOperationQueue *queue = [NSOperationQueue new];
        // create an invocation operation
        NSInvocationOperation *invocationOp = [[NSInvocationOperation alloc]  initWithTarget:self
                                                                                    selector:@selector(bringTexturesASYNC:)
                                                                                      object:textureName];
        [queue addOperation:invocationOp]; // Add the operation to the queue
        [invocationOp release];
    } else {
        //no connection
        [[NSNotificationCenter defaultCenter] postNotificationName:_notificationName object:@(NO)];
    }
}
@end
