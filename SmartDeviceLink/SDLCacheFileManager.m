//
//  SDLCacheFileManager.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "SDLCacheFileManager.h"
#import "SDLIconArchiveFile.h"
#import "SDLLockScreenIconCache.h"
#import "SDLLogMacros.h"

typedef void (^URLSessionTaskCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);
//typedef void (^ClearDirectoryCompletionHandler)(NSError * _Nullable error);

static float DefaultConnectionTimeout = 45.0;

@interface SDLCacheFileManager()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (copy, nonatomic, readonly, nullable) NSString *sdl_cacheFileBaseDirectory;
@property (copy, nonatomic, readonly, nullable) NSString *sdl_archiveFileDirectory;

@end

@implementation SDLCacheFileManager

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = DefaultConnectionTimeout;
    configuration.timeoutIntervalForResource = DefaultConnectionTimeout;
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    _urlSession = [NSURLSession sessionWithConfiguration:configuration];
    
    return self;
}

- (void)retrieveImageForRequest:(SDLOnSystemRequest *)request withCompletionHandler:(ImageRetrievalCompletionHandler)completion {
    
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL newlyCreatedDirectory = NO;
    
    // Check if the directory already exists; if it does not, create it
    if (![fileManager fileExistsAtPath:self.sdl_cacheFileBaseDirectory]) {
        // Create the directory including any intermediate directories if necessary
        [fileManager createDirectoryAtPath:self.sdl_cacheFileBaseDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        newlyCreatedDirectory = YES;
    }
    
    // Attempt to retrieve archive file from directory cache
    SDLIconArchiveFile *iconArchiveFile = [self sdl_retrieveArchiveFileFromPath:self.sdl_cacheFileBaseDirectory];
    
    // Check that archive file is not nil and if new directory was created
    if ((iconArchiveFile == nil || iconArchiveFile.lockScreenIconCaches.count == 0) && !newlyCreatedDirectory) {
        [self sdl_clearLockScreenDirectory];
    } else {
        // Check lockscreen icon cache array in archive file
        for (SDLLockScreenIconCache *iconCache in iconArchiveFile.lockScreenIconCaches) {
            // The icon exists and is not expired
            if ([iconCache.iconUrl isEqualToString:request.url] && [self.class numberOfDaysFromDateCreated:iconCache.lastModifiedDate] < 30) {
                
                NSString *imageFilePath = [self.sdl_cacheFileBaseDirectory stringByAppendingPathComponent:[self.class sdl_md5HashFromString:request.url]];
                UIImage *icon = [UIImage imageWithContentsOfFile:imageFilePath];
                
                if (icon == nil) {
                    [self sdl_clearLockScreenDirectory];
                }
                
                return completion(icon, nil);
            } else if ([iconCache.iconUrl isEqualToString:request.url] && [self.class numberOfDaysFromDateCreated:iconCache.lastModifiedDate] >= 30)  {
                // update archive
            }
        }
    }
    
    // Download Icon
    [self sdl_downloadIconFromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (error != nil) {
            completion (nil, error);
        }
        return completion(image, nil);
    }];
    
    // Update Archive File
    
    //        UIImage *icon = [UIImage imageWithData:data];
    //        NSString *iconFilePath = [self sdl_writeImage:icon toFileFromURL:request.url];

}

#pragma mark - Cache Saving, Retrieving, Deletion Methods

- (void)sdl_saveArchiveFileWithIconURLString:(NSString *)urlString iconFilePath:(NSString *)iconFilePath {
    NSError *error;
    
    SDLLockScreenIconCache *lockScreenIconCache = [[SDLLockScreenIconCache alloc] initWithIconUrl:urlString iconFilePath:iconFilePath lastModifiedDate:[NSDate date]];
    
    SDLIconArchiveFile *iconArchiveFile = [[SDLIconArchiveFile alloc] init];
    iconArchiveFile.lockScreenIconCaches = @[lockScreenIconCache];
    
    NSString *archiveFilePath = self.sdl_archiveFileDirectory;
    
    // HAX: Update this when we are iOS 11.0+
    BOOL writeSuccess = [NSKeyedArchiver archiveRootObject:iconArchiveFile toFile:archiveFilePath];
    if (!writeSuccess) {
        SDLLogE(@"Could not write file to specified path: %@", error);
    }
}

- (nullable SDLIconArchiveFile *)sdl_retrieveArchiveFileFromPath:(NSString *)path {
    NSString *archiveObjectPath = self.sdl_archiveFileDirectory;
    SDLIconArchiveFile *iconArchiveFile = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveObjectPath];
    
    return iconArchiveFile;
}

- (void)sdl_clearLockScreenDirectory {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = self.sdl_cacheFileBaseDirectory;
    NSError *error = nil;
    
    for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) {
        if (error != nil) {
            SDLLogE(@"Failed retrieving contents of directory: %@ with error: %@", directory, error);
        }
        BOOL success = [fileManager removeItemAtPath:[directory stringByAppendingPathComponent:file] error:&error];
        if (!success || error != nil) {
            SDLLogE(@"Could not delete file: %@", error);
            break;
        }
    }
}

- (nullable NSString *)sdl_writeImage:(UIImage *)icon toFileFromURL:(NSString *)urlString {
    NSData *iconJPEGData = UIImageJPEGRepresentation(icon, 1.0);
    NSString *iconStorageName = [self.class sdl_md5HashFromString:urlString];
    
    NSString *imageFilePath = [self.sdl_cacheFileBaseDirectory stringByAppendingPathComponent:iconStorageName];
    [iconJPEGData writeToFile:imageFilePath atomically:YES];
    
    return imageFilePath;
}

#pragma mark - Handle Expired Icon

- (void)updateExpiredIconFromRequest:(SDLOnSystemRequest *)request archiveFile:(SDLIconArchiveFile *)archiveFile withCompletionHandler:(ImageRetrievalCompletionHandler)completion {
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:request.url]
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error.localizedDescription);
            completion(nil, error);
        }
        
        UIImage *icon = [UIImage imageWithData:data];
        NSString *iconFilePath = [self sdl_writeImage:icon toFileFromURL:request.url];
        
        // Edge Case 7/8: If we fail to set the icon file path, try to use downloaded icon anyways
        if (iconFilePath == nil) {
            completion(icon, nil);
        }
        
        [self updateArchiveFile:archiveFile fromRequest:request andIconFilePath:iconFilePath withNewIcon:NO];
        completion(icon, nil);
    }];
}

- (void)updateArchiveFile:(SDLIconArchiveFile *)archiveFile
              fromRequest:(SDLOnSystemRequest *)request
          andIconFilePath:(NSString *)filePath
              withNewIcon:(BOOL)isNewIcon {
    NSError *error = nil;
    NSString *archiveFilePath = self.sdl_archiveFileDirectory;
    NSMutableArray *archiveArray = [archiveFile.lockScreenIconCaches mutableCopy];
    
    if (!isNewIcon) {
        // Find the icon we need to update; remove it, then replace it.
        for (SDLLockScreenIconCache *iconCacheCopy in archiveArray) {
            if ([iconCacheCopy.iconUrl isEqualToString:request.url]) {
                [archiveArray removeObject:iconCacheCopy];
            }
        }
        
        SDLLockScreenIconCache *updatedIconCache = [[SDLLockScreenIconCache alloc] initWithIconUrl:filePath iconFilePath:request.url lastModifiedDate:[NSDate date]];
        [archiveArray addObject:updatedIconCache];
        
        archiveFile.lockScreenIconCaches = archiveArray;
    } else {
        // Add New Icon Cache to array
        SDLLockScreenIconCache *newIconCache = [[SDLLockScreenIconCache alloc] initWithIconUrl:filePath iconFilePath:request.url lastModifiedDate:[NSDate date]];
        [archiveArray addObject:newIconCache];
        
        archiveFile.lockScreenIconCaches = archiveArray;
    }
    
    // HAX: Update this when we are iOS 11.0+
    BOOL writeSuccess = [NSKeyedArchiver archiveRootObject:archiveFile toFile:archiveFilePath];
    if (!writeSuccess) {
        SDLLogE(@"Could not write file to specified path: %@", error);
    }
}

#pragma mark - Directory Getters

- (NSString *)sdl_cacheFileBaseDirectory {
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    return [cacheDirectory stringByAppendingPathComponent:@"/sdl/lockScreenIcon/"];
}

- (NSString *)sdl_archiveFileDirectory {
    return [self.sdl_cacheFileBaseDirectory stringByAppendingPathComponent:@"archiveCacheFile"];
}

#pragma mark - Download Image

- (void)sdl_downloadIconFromRequest:(SDLOnSystemRequest *)request withCompletionHandler:(ImageRetrievalCompletionHandler)completion {
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:request.url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error.localizedDescription);
            return completion(nil, error);
        }
        
        UIImage *icon = [UIImage imageWithData:data];
        
        return completion(icon, nil);
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

+ (NSInteger)numberOfDaysFromDateCreated:(NSDate *)date {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:kNilOptions];
    
    return components.day;
}

@end
