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
#import "SDLLogMacros.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^URLSessionTaskCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);

static float DefaultConnectionTimeout = 45.0;

@interface SDLCacheFileManager()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (strong, nonatomic, readonly, nullable) NSString *sdl_cacheFileBaseDirectory;
@property (strong, nonatomic, readonly, nullable) NSString *sdl_archiveFileDirectory;
@property (weak, nonatomic) NSURLSessionDataTask *sdl_dataTask;

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
    BOOL isNewDirectory = NO;

    // Check if the directory already exists; if it does not, create it
    if (![fileManager fileExistsAtPath:self.sdl_cacheFileBaseDirectory]) {
        // Create the directory including any intermediate directories if necessary
        [fileManager createDirectoryAtPath:self.sdl_cacheFileBaseDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        isNewDirectory = YES;
        
        if (error != nil) {
            SDLLogE(@"Could not create directory at specified path: %@", error);
        }
    }
    
    // Attempt to retrieve archive file from directory cache
    SDLIconArchiveFile *iconArchiveFile = [self sdl_retrieveArchiveFileFromPath:self.sdl_archiveFileDirectory];
    
    if (iconArchiveFile == nil || iconArchiveFile.lockScreenIconCaches.count == 0) {
        // Check if new directory was just created, if no, clear lock screen cache directory and create empty archive file
        if (!isNewDirectory) {
            [self sdl_clearLockScreenDirectory];
            iconArchiveFile = [[SDLIconArchiveFile alloc] init];
        } else {
            iconArchiveFile = [[SDLIconArchiveFile alloc] init];
        }
    } else {
        for (SDLLockScreenIconCache *iconCache in iconArchiveFile.lockScreenIconCaches) {
            // The icon exists and is not expired
            if ([iconCache.iconUrl isEqualToString:request.url] && [self.class numberOfDaysFromDateCreated:iconCache.lastModifiedDate] < 30) {
                
                NSString *imageFilePath = [self.sdl_cacheFileBaseDirectory stringByAppendingPathComponent:[self.class sdl_md5HashFromString:request.url]];
                UIImage *icon = [UIImage imageWithContentsOfFile:imageFilePath];
                
                // If we fail to get icon at path, break loop early to download new icon
                if (icon == nil) {
                    [self sdl_clearLockScreenDirectory];
                    iconArchiveFile = [[SDLIconArchiveFile alloc] init];
                    break;
                }
                
                return completion(icon, nil);
            }
        }
    }
    
    // Download Icon
    [self sdl_downloadIconFromRequestURL:request.url withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (error != nil) {
            return completion (nil, error);
        }
        
        // Save lock screen icon to file path
        NSString *iconFilePath = [self sdl_writeImage:image toFileFromURL:request.url];
        
        if (iconFilePath == nil) {
            SDLLogE(@"Could not save lockscreen icon to path: %@", error);
        }
        
        // Update archive file with icon
        [self updateArchiveFileFromRequest:request iconFilePath:iconFilePath archiveFile:iconArchiveFile];
        
        return completion(image, nil);
    }];
}

#pragma mark - Cache Helper Methods

/**
 * Handles request to retrieve lock screen archive file from specified path.
 *
 * @param path The directory where the archive file is held
 * @return The archive file at path
*/
- (nullable SDLIconArchiveFile *)sdl_retrieveArchiveFileFromPath:(NSString *)path {
    NSString *archiveObjectPath = self.sdl_archiveFileDirectory;
    SDLIconArchiveFile *iconArchiveFile = [NSKeyedUnarchiver unarchiveObjectWithFile:archiveObjectPath];
    
    return iconArchiveFile;
}

/**
 * Handles the request to clear all files from lock screen icon directory in cache.
*/
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

/**
 * Handles request to save icon image to cache.
 *
 * @param icon The icon to be saved to the cache
 * @param urlString The url of the icon to be hashed and used as file name
 * @return A string representation of the directory the icon was saved to
*/
- (nullable NSString *)sdl_writeImage:(UIImage *)icon toFileFromURL:(NSString *)urlString {
    NSData *iconPNGData = UIImagePNGRepresentation(icon);
    NSString *iconStorageName = [self.class sdl_md5HashFromString:urlString];
    
    NSString *imageFilePath = [self.sdl_cacheFileBaseDirectory stringByAppendingPathComponent:iconStorageName];
    [iconPNGData writeToFile:imageFilePath atomically:YES];
    
    return imageFilePath;
}

/**
 * Handles request to update archive file. Will create a new archive file if one is not present.
 *
 * @param request The System request used to retrieve the icon
 * @param iconFilePath The directory path where the icon file is held
 * @param archiveFile Current archive file to update
*/
- (void)updateArchiveFileFromRequest:(SDLOnSystemRequest *)request iconFilePath:(NSString *)iconFilePath archiveFile:(SDLIconArchiveFile *)archiveFile {
    NSError *error = nil;
    NSMutableArray *archiveArray = [NSMutableArray new];
    
    if (archiveFile.lockScreenIconCaches != nil) {
        archiveArray = [archiveFile.lockScreenIconCaches mutableCopy];
    }
    
    // Need to remove duplicate SDLLockScreenIconCache object if handling expired icon
    for (SDLLockScreenIconCache *iconCacheCopy in archiveArray) {
        if ([iconCacheCopy.iconUrl isEqualToString:request.url]) {
            [archiveArray removeObject:iconCacheCopy];
            break;
        }
    }
    
    SDLLockScreenIconCache *newIconCache = [[SDLLockScreenIconCache alloc] initWithIconUrl:request.url iconFilePath:iconFilePath];
    [archiveArray addObject:newIconCache];
    
    archiveFile.lockScreenIconCaches = archiveArray;
    
    // HAX: Update this when we are iOS 11.0+
    BOOL writeSuccess = [NSKeyedArchiver archiveRootObject:archiveFile toFile:self.sdl_archiveFileDirectory];
    if (!writeSuccess) {
        SDLLogE(@"Could not write file to specified path: %@", error);
    }
}

#pragma mark - Directory Getters

- (nullable NSString *)sdl_cacheFileBaseDirectory {
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    return [cacheDirectory stringByAppendingPathComponent:@"/sdl/lockScreenIcon/"];
}

- (nullable NSString *)sdl_archiveFileDirectory {
    return [self.sdl_cacheFileBaseDirectory stringByAppendingPathComponent:@"archiveCacheFile"];
}

#pragma mark - Download Image

/**
 * Handles request to download icon from request
 *
 * @param requestURL The System request URL used to download icon
 * @param completion The completion handler is called when the icon download succeeds or fails with error
*/
- (void)sdl_downloadIconFromRequestURL:(NSString *)requestURL withCompletionHandler:(ImageRetrievalCompletionHandler)completion {
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:requestURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error.localizedDescription);
            return completion(nil, error);
        }
        
        UIImage *icon = [UIImage imageWithData:data];
        
        return completion(icon, nil);
    }];
}

/**
 * Sends data task to retrieve icon at specified URL.
 *
 * @param url The URL to retrieve data from
 * @param completionHandler The completion handler is called when the data task succeeds or fails
*/
- (void)sdl_sendDataTaskWithURL:(NSURL*)url completionHandler:(URLSessionTaskCompletionHandler)completionHandler {
    if ([url.scheme isEqualToString:@"http"]) {
        url = [NSURL URLWithString:[url.absoluteString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"https"]];
    }
    
    self.sdl_dataTask = [self.urlSession dataTaskWithURL:url completionHandler:completionHandler];
    [self.sdl_dataTask resume];
}

#pragma mark - Helper Methods

/**
 * Creates a directory friendly string representation of a URL string by hashing the URL using the MD5 hash function.
 *
 * HAX: A MD5 hash always creates a string with 32 characters (128-bits). Due to some implementations of Core not following the spec, file names that are too long are being rejected. To try to accommodate this setup, hashed file names are being truncated to 16 characters.
 *
 * @param string The string to hash
 * @return A MD5 hash of the string
 */
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

/**
 * Determines the number of days from a spicified date.
 *
 * @param date The date to be compared against
 * @return Integer representing number of days
 */
+ (NSInteger)numberOfDaysFromDateCreated:(NSDate *)date {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:date toDate:[NSDate date] options:kNilOptions];
    
    return components.day;
}

@end

NS_ASSUME_NONNULL_END
