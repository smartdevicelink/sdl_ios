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
#import "SDLLogMacros.h"
#import <CommonCrypto/CommonDigest.h>

typedef void (^URLSessionTaskCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);

static float DefaultConnectionTimeout = 45.0;

@interface SDLCacheFileManager()
@property (nonatomic, strong) NSURLSession* urlSession;
@end

@implementation SDLCacheFileManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = DefaultConnectionTimeout;
    configuration.timeoutIntervalForResource = DefaultConnectionTimeout;
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    _urlSession = [NSURLSession sessionWithConfiguration:configuration];
    
    return self;
}

- (void)handleLockScreenIconRequest:(SDLOnSystemRequest *)request
              withCompletionHandler: (void (^)(UIImage * __nullable image, NSError * __nullable error))completion {
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    UIImage *icon;
    
    if (![fileManager fileExistsAtPath:[self sdl_cacheFileBaseDirectory]]) {
        BOOL success = [fileManager createDirectoryAtPath:[self sdl_cacheFileBaseDirectory] withIntermediateDirectories:YES attributes:nil error:&error];
        if (!success) {
            // creating directory failed try to download image and return it to proxy
        }
        
        [self downloadImageAndSetPathFromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (error != nil) {
                // handle error
            }
            completion(icon, nil);
        }];
        
    } else {
        // search for icon at path
        icon = [self checkIfIconExistsAtPath:[self sdl_cacheFileBaseDirectory] fromRequest:request];
        completion(icon, nil);
    }
}


#pragma mark - Cache Saving, Retrieving, Deletion Methods

- (nullable UIImage *)checkIfIconExistsAtPath:(NSString *)path fromRequest:(SDLOnSystemRequest *)request {
    // search for file
    SDLIconArchiveFile *iconArchiveFile = [self retrieveArchiveFileFromPath:path];
    for (SDLLockScreenIconCache *iconCache in iconArchiveFile.lockScreenIconCaches) {
        if ([iconCache.iconUrl isEqualToString:request.url]) {
            NSString *imageFilePath = [path stringByAppendingPathComponent:[self.class sdl_md5HashFromString:request.url]];
            UIImage *icon = [UIImage imageWithContentsOfFile:imageFilePath];
            return icon;
        } else {
            // icon not found, download it
        }
    }
    
    return nil;
}

- (void)createAndSaveArchiveFileFromRequest:(SDLOnSystemRequest *)request andIconFilePath:(NSString *)iconFilePath {
    NSError *error;
    
    SDLLockScreenIconCache *lockScreenIconCache = [[SDLLockScreenIconCache alloc] init];
    lockScreenIconCache.iconUrl = request.url;
    lockScreenIconCache.iconFilePath = iconFilePath;
    lockScreenIconCache.lastModifiedDate = [NSDate date];
    
    SDLIconArchiveFile *iconArchiveFile = [[SDLIconArchiveFile alloc] init];
    iconArchiveFile.lockScreenIconCaches = [NSArray arrayWithObject:lockScreenIconCache];

    NSString *archiveFilePath = [self sdl_archiveFileDirectory];
    
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:iconArchiveFile requiringSecureCoding:YES error:&error];
        BOOL writeSuccess = [data writeToFile:archiveFilePath atomically:YES];
        if (!writeSuccess) {
            // Error writing to file
        }
    } else {
        [NSKeyedArchiver archiveRootObject:iconArchiveFile toFile:archiveFilePath];
    }
}

- (SDLIconArchiveFile *)retrieveArchiveFileFromPath:(NSString *)path {
    NSString *archiveObjectPath = [path stringByAppendingPathComponent:@"archiveCacheFile"];
    SDLIconArchiveFile *iconArchiveFile = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveObjectPath];
    
    return iconArchiveFile;
}

- (void)printFileNamesFromPath:(NSString *)path {
    NSError *error;

    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&error];
    if (files == nil) {
        NSLog(@"FILES ARE NIL %@", [error localizedDescription]);
    }
    
    for (id filename in files) {
        NSLog(@"File name: %@", filename);
    }
}

- (NSString *)saveIconToCache:(UIImage *)icon withRequestUrl:(NSString *)urlString {
    NSError *error;

    NSData *iconPngData = UIImagePNGRepresentation(icon);
    NSString *iconStorageName = [self.class sdl_md5HashFromString:urlString];
    
    NSString *imageFilePath = [[self sdl_cacheFileBaseDirectory] stringByAppendingPathComponent:iconStorageName];
    BOOL writeSuccess = [iconPngData writeToFile:imageFilePath atomically:YES];
    if (!writeSuccess) {
        NSLog(@"Error writing to file: %@", [error localizedDescription]);
        // james to do handle error
    }
    
    [self printFileNamesFromPath:[self sdl_cacheFileBaseDirectory]];
    return imageFilePath;
}

#pragma mark - Directories

- (NSString *)sdl_cacheFileBaseDirectory {
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    return [cacheDirectory stringByAppendingPathComponent:@"/sdl/lockScreenIcon/"];
}

- (NSString *)sdl_archiveFileDirectory {
    return [[self sdl_archiveFileDirectory] stringByAppendingPathComponent:@"archiveCacheFile"];
}

#pragma mark - Download Image

- (void)downloadImageAndSetPathFromRequest:(SDLOnSystemRequest *)request withCompletionHandler: (void (^)(UIImage * __nullable image, NSError * __nullable error))completion {
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:request.url]
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error.localizedDescription);
            return;
        }

        UIImage *icon = [UIImage imageWithData:data];
        NSString *iconFilePath = [self saveIconToCache:icon withRequestUrl:request.url];
        [self createAndSaveArchiveFileFromRequest:request andIconFilePath:iconFilePath];
        completion(icon, nil);
    }];
    
}

- (void)sdl_sendDataTaskWithURL:(NSURL*)url completionHandler:(URLSessionTaskCompletionHandler)completionHandler {
    if ([url.scheme isEqualToString:@"http"]) {
        url = [NSURL URLWithString:[url.absoluteString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"https"]];
    }
    
    [[self.urlSession dataTaskWithURL:url completionHandler:completionHandler] resume];
}

#pragma mark - Helper Methods

+ (NSString *)sdl_md5HashFromString:(NSString *)string {
    
    const char* str = [string UTF8String];
    unsigned char hash[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), hash);
    NSMutableString *formattedHash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    // HAX: To shorten the string to 16 characters, the loop has been shortened to 8 fom 16.
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH / 2; i += 1) {
        [formattedHash appendFormat:@"%02x", hash[i]];
    }
    return formattedHash;
}

@end
