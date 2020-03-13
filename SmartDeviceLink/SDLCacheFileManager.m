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
              withCompletionHandler:(CacheImageReturnCompletionHandler)completion {
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // Edge Case 4: Directory Doesn't Exist, Create It
    if (![fileManager fileExistsAtPath:[self sdl_cacheFileBaseDirectory]]) {
        [fileManager createDirectoryAtPath:[self sdl_cacheFileBaseDirectory] withIntermediateDirectories:YES attributes:nil error:&error];
        
        [self downloadIconAndSetPathFromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (error != nil) {
                return completion(nil, error);
            }
            return completion(image, nil);
        }];
        
    } else {
        // Directory exists, attempt to grab icon
        [self getIconAtPath:[self sdl_cacheFileBaseDirectory] fromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (error != nil) {
                return completion(nil, error);
            }
            return completion(image, nil);
        }];
    }
}

#pragma mark - Cache Saving, Retrieving, Deletion Methods

- (void)getIconAtPath:(NSString *)path
          fromRequest:(SDLOnSystemRequest *)request
withCompletionHandler:(CacheImageReturnCompletionHandler)completion {
    
    // Edge Case 5: Check if no archive file exists
    SDLIconArchiveFile *iconArchiveFile = [self retrieveArchiveFileFromPath:path];
    if (iconArchiveFile == nil || iconArchiveFile.lockScreenIconCaches.count == 0) {
        // Clear directory and re-download icon
        [self clearLockScreenDirectoryAndDownloadIconFromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (error != nil) {
                return completion(nil, error);
            }
            return completion(image, nil);
        }];
    }
        
    for (SDLLockScreenIconCache *iconCache in iconArchiveFile.lockScreenIconCaches) {
        if ([iconCache.iconUrl isEqualToString:request.url] && [self.class numberOfDaysFromDateCreated:iconCache.lastModifiedDate] < 30) {
            // Edge Case 2: Icon exists and is not expired
            NSString *imageFilePath = [path stringByAppendingPathComponent:[self.class sdl_md5HashFromString:request.url]];
            UIImage *icon = [UIImage imageWithContentsOfFile:imageFilePath];
            
            // Edge Case 6: Check if icon is nil at path
            if (icon == nil) {
                // Clear directory and re-download icon
                [self clearLockScreenDirectoryAndDownloadIconFromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                    if (error != nil) {
                        return;
                    }
                    return completion(image, nil);
                }];
            }
            
            return completion(icon, nil);
        } else if ([iconCache.iconUrl isEqualToString:request.url] && [self.class numberOfDaysFromDateCreated:iconCache.lastModifiedDate] >= 30)  {
            // Handle Expired Icon: Edge Case 1
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
            NSLog(@"Could not write file to specified path: %@", error);
        }
    } else {
        [NSKeyedArchiver archiveRootObject:iconArchiveFile toFile:archiveFilePath];
    }
}

- (nullable SDLIconArchiveFile *)retrieveArchiveFileFromPath:(NSString *)path {
    NSString *archiveObjectPath = [self sdl_archiveFileDirectory];
    SDLIconArchiveFile *iconArchiveFile = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveObjectPath];
    
    return iconArchiveFile;
}

- (void)clearLockScreenDirectoryAndDownloadIconFromRequest:(SDLOnSystemRequest *)request
                               withCompletionHandler:(CacheImageReturnCompletionHandler)completion {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [self sdl_cacheFileBaseDirectory];
    NSError *error;
    
    for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) {
        BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
        if (!success || error) {
            NSLog(@"Could not delete file: %@", error);
        }
    }
    
    [self downloadIconAndSetPathFromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (error != nil) {
            return completion(nil, error);
        }
        return completion(image, nil);
    }];
}

- (nullable NSString *)setFilePathWithImage:(UIImage *)icon andRequestUrl:(NSString *)urlString {
    NSData *iconPngData = UIImagePNGRepresentation(icon);
    NSString *iconStorageName = [self.class sdl_md5HashFromString:urlString];
    
    NSString *imageFilePath = [[self sdl_cacheFileBaseDirectory] stringByAppendingPathComponent:iconStorageName];
    [iconPngData writeToFile:imageFilePath atomically:YES];
    
    return imageFilePath;
}

#pragma mark - Handle Expired Icon

- (void)updateExpiredIconFromRequest:(SDLOnSystemRequest *)request
                         archiveFile:(SDLIconArchiveFile *)archiveFile
               withCompletionHandler:(CacheImageReturnCompletionHandler)completion {
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:request.url]
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error.localizedDescription);
            completion(nil, error);
        }
        
        UIImage *icon = [UIImage imageWithData:data];
        NSString *iconFilePath = [self setFilePathWithImage:icon andRequestUrl:request.url];
        
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
    NSError *error;
    NSString *archiveFilePath = [self sdl_archiveFileDirectory];
    NSMutableArray *archiveArray = [archiveFile.lockScreenIconCaches mutableCopy];
    
    // Check if we are receiving a unique icon
    if (isNewIcon == NO) {
        // Update Icon Cache in Archive File
        for (SDLLockScreenIconCache *iconCacheCopy in archiveArray) {
            if ([iconCacheCopy.iconUrl isEqualToString:request.url]) {
                [archiveArray removeObject:iconCacheCopy];
            }
        }
        
        SDLLockScreenIconCache *updatedIconCache = [[SDLLockScreenIconCache alloc] init];
        updatedIconCache.iconFilePath = filePath;
        updatedIconCache.iconUrl = request.url;
        updatedIconCache.lastModifiedDate = [NSDate date];
        [archiveArray addObject:updatedIconCache];
        
        archiveFile.lockScreenIconCaches = archiveArray;
    } else {
        // Add New Icon Cache to array
        SDLLockScreenIconCache *newIconCache = [[SDLLockScreenIconCache alloc] init];
        newIconCache.iconFilePath = filePath;
        newIconCache.iconUrl = request.url;
        newIconCache.lastModifiedDate = [NSDate date];
        [archiveArray addObject:newIconCache];
        
        archiveFile.lockScreenIconCaches = archiveArray;
    }
    
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:archiveFile requiringSecureCoding:YES error:&error];
        [data writeToFile:archiveFilePath atomically:YES];
    } else {
        [NSKeyedArchiver archiveRootObject:archiveFile toFile:archiveFilePath];
    }
}

#pragma mark - Directories

- (NSString *)sdl_cacheFileBaseDirectory {
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    return [cacheDirectory stringByAppendingPathComponent:@"/sdl/lockScreenIcon/"];
}

- (nullable NSString *)sdl_archiveFileDirectory {
    return [[self sdl_cacheFileBaseDirectory] stringByAppendingPathComponent:@"archiveCacheFile"];
}

#pragma mark - Download Image

// Called on first download or to re-download after cache is cleared
- (void)downloadIconAndSetPathFromRequest:(SDLOnSystemRequest *)request withCompletionHandler:(CacheImageReturnCompletionHandler)completion {
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:request.url]
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error.localizedDescription);
            completion(nil, error);
        }
        
        UIImage *icon = [UIImage imageWithData:data];
        NSString *iconFilePath = [self setFilePathWithImage:icon andRequestUrl:request.url];
        
        // Edge Case 7: If we fail to set the icon file path, try to use downloaded icon anyways
        if (iconFilePath == nil) {
            completion(icon, nil);
        }
        
        [self createAndSaveArchiveFileFromRequest:request andIconFilePath:iconFilePath];
        completion(icon, nil);
    }];
}

// Called when we recieve request for unique icon
- (void)downloadNewIconFromRequest:(SDLOnSystemRequest *)request
                   withArchiveFile:(SDLIconArchiveFile *)archiveFile
              andCompletionHandler:(CacheImageReturnCompletionHandler)completion {
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:request.url] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error.localizedDescription);
            completion(nil, error);
        }
        
        UIImage *icon = [UIImage imageWithData:data];
        NSString *iconFilePath = [self setFilePathWithImage:icon andRequestUrl:request.url];
        
        // Edge Case 7/8: If we fail to set the icon file path, try to use downloaded icon anyways
        if (iconFilePath == nil) {
            completion(icon, nil);
        }
        
        [self updateArchiveFile:archiveFile fromRequest:request andIconFilePath:iconFilePath withNewIcon:YES];
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

+ (NSInteger)numberOfDaysFromDateCreated:(NSDate *)date {
    NSDateComponents *components;
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: date toDate: [NSDate date] options: 0];
    
    return [components day];
}

@end
