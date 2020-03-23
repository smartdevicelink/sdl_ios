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
#import "SDLOnSystemRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^URLSessionTaskCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);

static float DefaultConnectionTimeout = 45.0;

@interface SDLCacheFileManager()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (class, strong, nonatomic, readonly, nullable) NSString *cacheFileBaseDirectory;
@property (class, strong, nonatomic, readonly, nullable) NSString *archiveFileDirectory;
@property (weak, nonatomic, nullable) NSURLSessionDataTask *dataTask;

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
    if (![fileManager fileExistsAtPath:self.class.cacheFileBaseDirectory]) {
        // Create the directory including any intermediate directories if necessary
        [fileManager createDirectoryAtPath:self.class.cacheFileBaseDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error != nil) {
            SDLLogE(@"Could not create directory at specified path: %@; we will attempt to download and return image anyway", error);
        }
    }
    
    // Attempt to retrieve archive file from directory cache
    SDLIconArchiveFile *iconArchiveFile = [NSKeyedUnarchiver unarchiveObjectWithFile:self.class.archiveFileDirectory];
    if (iconArchiveFile == nil || iconArchiveFile.lockScreenIconCaches.count == 0) {
        // If there's no archive file in the directory, clear it, just in case
        [self.class sdl_clearDirectoryWithPath:self.class.archiveFileDirectory];
        iconArchiveFile = [[SDLIconArchiveFile alloc] init];
    }

    // Loop through the icons in the cache file and check if its the file we're looking for
    for (SDLLockScreenIconCache *iconCache in iconArchiveFile.lockScreenIconCaches) {
        // The icon isn't the one we're looking for
        if ([iconCache.iconUrl isEqualToString:request.url]) { continue; }
        // The icon we're looking for has expired
        if ([self.class numberOfDaysFromDateCreated:iconCache.lastModifiedDate] >= 30) { break; }
        NSString *imageFilePath = [self.class.cacheFileBaseDirectory stringByAppendingPathComponent:[self.class sdl_md5HashFromString:request.url]];
        UIImage *icon = [UIImage imageWithContentsOfFile:imageFilePath];
        
        // If we fail to get icon at path, break loop early to download new icon
        if (icon == nil) {
            [self.class sdl_clearDirectoryWithPath:self.class.archiveFileDirectory];
            iconArchiveFile = [[SDLIconArchiveFile alloc] init];
            break;
        }
        
        return completion(icon, nil);
    }

    
    [self sdl_downloadIconFromRequestURL:request.url withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (error != nil) {
            return completion(nil, error);
        }
        
        // Save lock screen icon to file path
        NSString *iconFilePath = [self.class sdl_writeImage:image toFileFromURL:request.url];
        if (iconFilePath == nil) {
            SDLLogE(@"Could not save lockscreen icon to path: %@; we will attempt to download and return image anyway", error);
        }
        
        // Update archive file with icon
        [self updateArchiveFileWithIconURL:request.url iconFilePath:iconFilePath archiveFile:iconArchiveFile];
        
        return completion(image, nil);
    }];
}


#pragma mark - Cache Directory and Files

/**
 * Handles the request to clear all files from lock screen icon directory in cache.
*/
+ (void)sdl_clearDirectoryWithPath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directory = self.cacheFileBaseDirectory;
    NSError *error = nil;
    
    for (NSString *file in [fileManager contentsOfDirectoryAtPath:directory error:&error]) {
        if (error != nil) {
            SDLLogE(@"Failed retrieving contents of directory: %@ with error: %@", directory, error);
            break;
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
+ (nullable NSString *)sdl_writeImage:(UIImage *)icon toFileFromURL:(NSString *)urlString {
    NSError *error = nil;

    NSData *iconPNGData = UIImagePNGRepresentation(icon);
    NSString *iconStorageName = [self.class sdl_md5HashFromString:urlString];
    
    NSString *imageFilePath = [self.class.cacheFileBaseDirectory stringByAppendingPathComponent:iconStorageName];
    BOOL writeSuccess = [iconPNGData writeToFile:imageFilePath atomically:YES];
    if (!writeSuccess) {
        SDLLogE(@"Could not write image file to specified path: %@", error);
        return nil;
    }
    
    return imageFilePath;
}

/**
 * Handles request to update archive file. Will create a new archive file if one is not present.
 *
 * @param iconURL The System request URL used to retrieve the icon
 * @param iconFilePath The directory path where the icon file is held
 * @param archiveFile Current archive file to update
*/
- (void)updateArchiveFileWithIconURL:(NSString *)iconURL iconFilePath:(NSString *)iconFilePath archiveFile:(SDLIconArchiveFile *)archiveFile {
    NSError *error = nil;
    NSMutableArray *archiveArray = [archiveFile.lockScreenIconCaches mutableCopy];
    
    // Need to remove duplicate SDLLockScreenIconCache object if handling expired icon
    for (SDLLockScreenIconCache *iconCacheCopy in archiveArray) {
        if (![iconCacheCopy.iconUrl isEqualToString:iconURL]) { continue; }

        [archiveArray removeObject:iconCacheCopy];
        break;
    }
    
    // Add the new file to the archive
    [archiveArray addObject:[[SDLLockScreenIconCache alloc] initWithIconUrl:iconURL iconFilePath:iconFilePath]];
    archiveFile.lockScreenIconCaches = archiveArray;
    
    // HAX: Update this when we are iOS 11.0+
    // Write the new archive to disk
    BOOL writeSuccess = [NSKeyedArchiver archiveRootObject:archiveFile toFile:self.class.archiveFileDirectory];
    if (!writeSuccess) {
        SDLLogE(@"Could not write archive file to specified path: %@", error);
    }
}

#pragma mark - Directory Getters

+ (nullable NSString *)cacheFileBaseDirectory {
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [cacheDirectory stringByAppendingPathComponent:@"/sdl/lockScreenIcon/"];
}

+ (nullable NSString *)archiveFileDirectory {
    return [self.cacheFileBaseDirectory stringByAppendingPathComponent:@"archiveCacheFile"];
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
            SDLLogW(@"OnSystemRequest (lock screen icon) HTTP download task failed: %@", error);
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
    // Due to iOS requirements, the connection has to be HTTPS. Upgrade the URL to HTTPS automatically. If it fails, then oh well.
    if ([url.scheme isEqualToString:@"http"]) {
        url = [NSURL URLWithString:[url.absoluteString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"https"]];
    }
    
    self.dataTask = [self.urlSession dataTaskWithURL:url completionHandler:completionHandler];
    [self.dataTask resume];
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
