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
typedef void (^ClearDirectoryCompletionHandler)(NSError * _Nullable error);

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
    
    // Check if the directory already exists; if it does not, create it
    if (![fileManager fileExistsAtPath:self.sdl_cacheFileBaseDirectory]) {
        // Create the directory including any intermediate directories if necessary
        [fileManager createDirectoryAtPath:self.sdl_cacheFileBaseDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        
        [self downloadIconAndSetPathFromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (error != nil) {
                return completion(nil, error);
            }
            return completion(image, nil);
        }];
        
    } else {
        // Directory exists, attempt to grab icon
        [self sdl_retrieveIconAtPath:self.sdl_cacheFileBaseDirectory fromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (error != nil) {
                return completion(nil, error);
            }
            return completion(image, nil);
        }];
    }
}

#pragma mark - Cache Saving, Retrieving, Deletion Methods

- (void)sdl_retrieveIconAtPath:(NSString *)path fromRequest:(SDLOnSystemRequest *)request withCompletionHandler:(ImageRetrievalCompletionHandler)completion {
    
    // Retrieve the archive file if possible
    SDLIconArchiveFile *iconArchiveFile = [self sdl_retrieveArchiveFileFromPath:path];
    if (iconArchiveFile == nil || iconArchiveFile.lockScreenIconCaches.count == 0) {
        // If retrieving the archive fails, clear the directory and re-download icon
        // james to do need to redownload icon
        [self sdl_clearLockScreenDirectoryWithCompletionHandler:^(NSError * _Nullable error) {
            if (error != nil) {
                return completion(nil, error);
            }
            // james to do handle download and return
//            return completion(image, nil);
        }];
    }
        
    for (SDLLockScreenIconCache *iconCache in iconArchiveFile.lockScreenIconCaches) {
        if ([iconCache.iconUrl isEqualToString:request.url] && [self.class numberOfDaysFromDateCreated:iconCache.lastModifiedDate] < 30) {
            // The icon exists and is not expired
            NSString *imageFilePath = [path stringByAppendingPathComponent:[self.class sdl_md5HashFromString:request.url]];
            UIImage *icon = [UIImage imageWithContentsOfFile:imageFilePath];
            
            if (icon == nil) {
                // If grabbing the icon from the path failed
                // james to do need to redownload icon
                [self sdl_clearLockScreenDirectoryWithCompletionHandler:^(NSError * _Nullable error) {
                    if (error != nil) {
                        return completion(nil, error);
                    }
                    // james to do handle download and return
//                    return completion(image, nil);
                }];
            }
            
            return completion(icon, nil);
            break;
        } else if ([iconCache.iconUrl isEqualToString:request.url] && [self.class numberOfDaysFromDateCreated:iconCache.lastModifiedDate] >= 30)  {
            // If the icon is more than 30 days old, we want to re-download the icon.
            [self updateExpiredIconFromRequest:request archiveFile:iconArchiveFile withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                if (error != nil) {
                    return completion(nil, error);
                }
                return completion(image, nil);
            }];
        } else {
            // Edge Case 3: Handle unique icon
            
            [self downloadNewIconFromRequest:request withArchiveFile:iconArchiveFile andCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                if (error != nil) {
                    return completion(nil, error);
                }
                return completion(image, nil);
            }];
        }
    }
}

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

- (void)sdl_clearLockScreenDirectoryWithCompletionHandler:(ClearDirectoryCompletionHandler)completion {
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

// Called on first download or to re-download after cache is cleared
- (void)downloadIconAndSetPathFromRequest:(SDLOnSystemRequest *)request withCompletionHandler:(ImageRetrievalCompletionHandler)completion {
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:request.url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error.localizedDescription);
            return completion(nil, error);
        }
        
        UIImage *icon = [UIImage imageWithData:data];
        NSString *iconFilePath = [self sdl_writeImage:icon toFileFromURL:request.url];
        
        // If we fail to save the icon, use the downloaded icon anyways
        if (iconFilePath == nil) {
            return completion(icon, nil);
        }
        
        [self sdl_saveArchiveFileWithIconURLString:request.url iconFilePath:iconFilePath];
        return completion(icon, nil);
    }];
}

// Called when we recieve request for unique icon
- (void)downloadNewIconFromRequest:(SDLOnSystemRequest *)request
                   withArchiveFile:(SDLIconArchiveFile *)archiveFile
              andCompletionHandler:(ImageRetrievalCompletionHandler)completion {
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:request.url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error.localizedDescription);
            return completion(nil, error);
        }
        
        UIImage *icon = [UIImage imageWithData:data];
        NSString *iconFilePath = [self sdl_writeImage:icon toFileFromURL:request.url];
        
        // If we fail to set the icon file path, try to use downloaded icon anyways
        if (iconFilePath == nil) {
            return completion(icon, nil);
        }
        
        [self updateArchiveFile:archiveFile fromRequest:request andIconFilePath:iconFilePath withNewIcon:YES];
        return completion(icon, nil);
    }];
}

- (void)downloadIconFromRequest:(SDLOnSystemRequest *)request withCompletionHandler:(ImageRetrievalCompletionHandler)completion {
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
