//
//  SDLCacheFileManager.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLCacheFileManager.h"
#import "SDLLockScreenIconCache.h"
#import "SDLIconArchiveFile.h"

@implementation SDLCacheFileManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)handleLockScreenIconRequest:(SDLOnSystemRequest *)request
              withCompletionHandler: (void (^)(UIImage * __nullable image, NSError * __nullable error))completion {
    // create and save archive file to path
    BOOL archiveExists = NO;
    if (!archiveExists) {
        // download image
        [self createAndSaveArchiveFileFromRequest:request];
    }
}

- (void)createAndSaveArchiveFileFromRequest:(SDLOnSystemRequest *)request {
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (![fileManager fileExistsAtPath:[self sdl_cacheFileDirectory]]) {
        [fileManager createDirectoryAtPath:[self sdl_cacheFileDirectory] withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    SDLLockScreenIconCache *lockScreenIconCache = [[SDLLockScreenIconCache alloc] init];
    lockScreenIconCache.iconUrl = request.url;
    lockScreenIconCache.iconFilePath = [[self sdl_cacheFileDirectory] stringByAppendingPathComponent:@"test.png"];
    lockScreenIconCache.lastModifiedDate = [NSDate date];
    
    SDLIconArchiveFile *iconArchiveFile = [[SDLIconArchiveFile alloc] init];
    iconArchiveFile.lockScreenIconCaches = [NSArray arrayWithObject:lockScreenIconCache];

    NSString *archiveFilePath = [[self sdl_cacheFileDirectory] stringByAppendingPathComponent:@"archiveCacheFile"];
    
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:iconArchiveFile requiringSecureCoding:YES error:&error];
        BOOL writeSuccess = [data writeToFile:archiveFilePath atomically:YES];
        if (!writeSuccess) {
            NSLog(@"Error writing to file: %@", [error localizedDescription]);
        }
        [self printFileNamesFromPath:[self sdl_cacheFileDirectory]];
        [self retrieveArchiveFileFromPath:[self sdl_cacheFileDirectory]];
    } else {
        [NSKeyedArchiver archiveRootObject:iconArchiveFile toFile:archiveFilePath];
    }
}

- (void)retrieveArchiveFileFromPath:(NSString *)path {
    NSString *archiveObjectPath = [path stringByAppendingPathComponent:@"archiveCacheFile"];
    SDLIconArchiveFile *iconArchiveFile = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveObjectPath];
    for (SDLLockScreenIconCache *iconCache in iconArchiveFile.lockScreenIconCaches) {
        NSLog(@"%@", iconCache.iconUrl);
    }
}

- (void)printFileNamesFromPath:(NSString *)path {
    NSError *error;

    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    if (files == nil) {
        NSLog(@"FILES ARE NIL %@", [error localizedDescription]);
    }
    
    for (id filename in files) {
        NSLog(@"%@", filename);
    }
}

#pragma mark - Cache Files

- (NSString *)sdl_cacheFileDirectory {
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    return [cacheDirectory stringByAppendingPathComponent:@"/sdl/lockScreenIcon/"];
}

@end
