//
//  SDLCacheFileManager.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLCacheFileManager.h"
#import "SDLLockScreenIconCache.h"

@implementation SDLCacheFileManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (BOOL)sdlCacheDirectoryExists {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL fileExists = [fileManager fileExistsAtPath:[self sdl_cacheFileDirectory] isDirectory:&isDirectory];
    
    if (fileExists && isDirectory) {
        return YES;
    }
    
    return NO;
}

- (void)handleLockScreenIconRequest:(SDLOnSystemRequest *)request {

}

- (void)cacheIconFromImage:(UIImage *)image {
    [NSKeyedArchiver archiveRootObject:image toFile:[self sdl_cacheFileDirectory]];
    [self cacheLockScreenIconCacheWithImagePath];
}

- (void)cacheLockScreenIconCacheWithImagePath {
    
}

#pragma mark - Cache Files

- (NSString *)sdl_cacheFileDirectory {
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    [cacheDirectory stringByAppendingPathExtension:@"SDL"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cacheDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cacheDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return cacheDirectory;
}

@end
