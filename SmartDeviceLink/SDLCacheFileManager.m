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
typedef void (^CacheImageReturnCompletionHandler)(UIImage * _Nullable image, NSError * _Nullable error);

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

- (void)handleLockScreenIconRequest:(SDLOnSystemRequest *)request withCompletionHandler:(nonnull void (^)(UIImage * _Nullable, NSError * _Nullable))completion {
    
    NSError *error;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    UIImage *icon;
    
    if (![fileManager fileExistsAtPath:[self sdl_cacheFileBaseDirectory]]) {
        [fileManager createDirectoryAtPath:[self sdl_cacheFileBaseDirectory] withIntermediateDirectories:YES attributes:nil error:&error];
        
        // Edge case 4
        [self downloadIconAndSetPathFromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (error != nil) {
                return;
            }
            completion(icon, nil);
        }];
        
    } else {
        // search for icon at path
        [self printFileNamesFromPath:[self sdl_cacheFileBaseDirectory]];
        
        [self getIconAtPath:[self sdl_cacheFileBaseDirectory] fromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (image != nil) {
                completion(image, nil);
            } else {
                completion(nil, error);
            }
        }];
    }
}


#pragma mark - Cache Saving, Retrieving, Deletion Methods

- (void)getIconAtPath:(NSString *)path fromRequest:(SDLOnSystemRequest *)request withCompletionHandler:(CacheImageReturnCompletionHandler)completion {
    UIImage *icon;
    
    SDLIconArchiveFile *iconArchiveFile = [self retrieveArchiveFileFromPath:path];
    // Edge case 5 need to check if no archive file exists, COVERED
    if (iconArchiveFile == nil) {
        [self clearIconDirectoryAndDownloadIconFromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
            if (error != nil) {
                return;
            }
            return completion(image, nil);
        }];
    }
    
    for (SDLLockScreenIconCache *iconCache in iconArchiveFile.lockScreenIconCaches) {
        if ([iconCache.iconUrl isEqualToString:request.url] && [self.class numberOfDaysFromDateCreated:iconCache.lastModifiedDate] < 30) {
            // Edge case 2 COVERED
            NSString *imageFilePath = [path stringByAppendingPathComponent:[self.class sdl_md5HashFromString:request.url]];
            icon = [UIImage imageWithContentsOfFile:imageFilePath];
            
            // Edge case 6 if icon is nil at path then we need to delete everything COVERED
            if (icon == nil) {
                [self clearIconDirectoryAndDownloadIconFromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
                    if (error != nil) {
                        return;
                    }
                    return completion(image, nil);
                }];
            }
            
            return completion(icon, nil);
        } else if ([iconCache.iconUrl isEqualToString:request.url] && [self.class numberOfDaysFromDateCreated:iconCache.lastModifiedDate] >= 30)  {
            // Edge case 1
            // icon found but expired
            
            // Redownload icon and update values at path
            // return icon;
        } else {
            // Edge case 3
            // icon not in path
            // download, save to path, and add new object to archive file array
            // return icon;
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
            // Error writing to file
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

- (void)clearIconDirectoryAndDownloadIconFromRequest:(SDLOnSystemRequest *)request withCompletionHandler:(CacheImageReturnCompletionHandler)completion {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = [self sdl_cacheFileBaseDirectory];
    NSError *error;
    
    for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) {
        BOOL success = [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
        if (!success || error) {
            NSLog(@"Could not delete file: %@", error);
        }
    }
    
    [self printFileNamesFromPath:directory];
    
    [self downloadIconAndSetPathFromRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (image != nil) {
            return completion(image, nil);
        }
    }];
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

- (nullable NSString *)setFilePathWithImage:(UIImage *)icon andRequestUrl:(NSString *)urlString {
    NSError *error;

    NSData *iconPngData = UIImagePNGRepresentation(icon);
    NSString *iconStorageName = [self.class sdl_md5HashFromString:urlString];
    
    NSString *imageFilePath = [[self sdl_cacheFileBaseDirectory] stringByAppendingPathComponent:iconStorageName];
    BOOL writeSuccess = [iconPngData writeToFile:imageFilePath atomically:YES];
    if (!writeSuccess) {
        NSLog(@"Error writing to file: %@", [error localizedDescription]);
        // image fails to save
        // need to send back image to proxy anyways
    }
    
    return imageFilePath;
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

- (void)downloadIconAndSetPathFromRequest:(SDLOnSystemRequest *)request withCompletionHandler:(CacheImageReturnCompletionHandler)completion {
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:request.url]
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error.localizedDescription);
            completion(nil, error);
        }

        UIImage *icon = [UIImage imageWithData:data];
        NSString *iconFilePath = [self setFilePathWithImage:icon andRequestUrl:request.url];
        
        // If we fail to set the icon file path, try to use icon anyways
        if (iconFilePath == nil) {
            completion(icon, nil);
        }
        
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

+ (NSInteger)numberOfDaysFromDateCreated:(NSDate *)date {
    NSDateComponents *components;
    components = [[NSCalendar currentCalendar] components: NSCalendarUnitDay fromDate: date toDate: [NSDate date] options: 0];
    
    return [components day];
}

@end
