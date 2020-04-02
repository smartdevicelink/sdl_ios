//
//  SDLCacheFileManager.m
//  SmartDeviceLink
//
//  Created by James Lapinski on 3/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "SDLCacheFileManager.h"
#import "SDLError.h"
#import "SDLIconArchiveFile.h"
#import "SDLLogMacros.h"
#import "SDLOnSystemRequest.h"

NS_ASSUME_NONNULL_BEGIN

static float DefaultConnectionTimeout = 45.0;
NSString *const SDLErrorDomainCacheManager = @"com.sdl.cacheManager";

@interface SDLCacheFileManager()

@property (nonatomic, strong) NSURLSession *urlSession;
@property (strong, nonatomic, readonly) NSString *cacheFileBaseDirectory;
@property (strong, nonatomic, readonly) NSString *archiveFilePath;
@property (strong, nonatomic, nullable) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSFileManager *fileManager;

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
    _fileManager = [NSFileManager defaultManager];

    return self;
}

- (void)retrieveImageForRequest:(SDLOnSystemRequest *)request withCompletionHandler:(ImageRetrievalCompletionHandler)completion {
    NSError *error = nil;
    UIImage *icon = nil;

    // Check if the directory already exists; if it does not, create it
    if (![self.fileManager fileExistsAtPath:self.cacheFileBaseDirectory]) {
        [self.fileManager createDirectoryAtPath:self.cacheFileBaseDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error != nil) {
            SDLLogE(@"Could not create directory at specified path: %@; we will attempt to download and return image anyway", error);
        }
    }
    
    // Attempt to retrieve archive file from directory cache
    SDLIconArchiveFile *iconArchiveFile = nil;
    @try {
        iconArchiveFile = [NSKeyedUnarchiver unarchiveObjectWithFile:self.archiveFilePath];
    } @catch (NSException *exception) {
        SDLLogE(@"Unable to retrieve archive file from file path: %@", exception);
    }

    // Check if there's no archive file in the directory. If there isn't clear the entire directory
    if (iconArchiveFile == nil || iconArchiveFile.lockScreenIconCaches.count == 0) {
        [self.class sdl_clearDirectoryWithPath:self.cacheFileBaseDirectory fileManager:self.fileManager];
        iconArchiveFile = [[SDLIconArchiveFile alloc] init];
    }

    // Loop through the icons in the cache file copy and check if it's the file we're looking for
    NSArray *iconCachesCopy = [iconArchiveFile.lockScreenIconCaches copy];
    for (SDLLockScreenIconCache *iconCache in iconCachesCopy) {
        // The icon isn't the one we're looking for
        if (![iconCache.iconUrl isEqualToString:request.url]) { continue; }

        // The icon we're looking for has expired
        if ([self.class numberOfDaysFromDateCreated:iconCache.lastModifiedDate] >= 30) { break; }

        // Create the file path for the image by hashing the URL which creates a guaranteed unique path name
        NSString *imageFilePath = [self.cacheFileBaseDirectory stringByAppendingPathComponent:[self.class sdl_md5HashFromString:request.url]];
        icon = [UIImage imageWithContentsOfFile:imageFilePath];

        // If we fail to get icon at path, break loop early to download new icon
        if (icon == nil) {
            SDLLogW(@"No icon was found at the path, we need to download a new icon");
            [self.class sdl_clearDirectoryWithPath:self.cacheFileBaseDirectory fileManager:self.fileManager];
            iconArchiveFile = [[SDLIconArchiveFile alloc] init];
            break;
        }
        
        return completion(icon, nil);
    }
    
    // If we got to this point, retrieving the icon failed for some reason. We will download the image and try to store it instead.
    [self sdl_downloadIconFromRequestURL:request.url withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogE(@"Downloading the lock screen icon failed with error: %@", error);
            return completion(nil, error);
        }
        
        // Save lock screen icon to file path
        NSString *iconFilePath = [self.class sdl_writeImage:image toFilePath:self.cacheFileBaseDirectory imageURL:request.url];
        if (iconFilePath == nil) {
            SDLLogE(@"Could not save lock screen icon to path with error: %@; we will return the image anyway", error);
            return completion(image, nil);
        }

        // Update archive file with icon
        BOOL writeSuccess = [self updateArchiveFileWithIconURL:request.url iconFilePath:iconFilePath archiveFile:iconArchiveFile error:&error];
        if (error != nil || !writeSuccess) {
            SDLLogE(@"Could not update archive file with error: %@; we will return the image anyway", error);
        }
        
        return completion(image, nil);
    }];
}


#pragma mark - Cache Directory and Files

/**
 * Handles the request to clear all files from lock screen icon directory in cache.
*/
+ (void)sdl_clearDirectoryWithPath:(NSString *)path fileManager:(NSFileManager *)fileManager {
    NSError *error = nil;
    for (NSString *file in [fileManager contentsOfDirectoryAtPath:path error:&error]) {
        if (error != nil) {
            SDLLogE(@"Cannot clear directory; failed retrieving contents of directory: %@ with error: %@", path, error);
            break;
        }

        BOOL success = [fileManager removeItemAtPath:[path stringByAppendingPathComponent:file] error:&error];
        if (!success || error != nil) {
            SDLLogE(@"Could not clear directory at path: %@; Could not delete file: %@", path, error);
            break;
        }
    }
}

/**
 * Handles request to save icon image to cache.
 *
 * @param icon The icon to be saved to the cache
 * @param filePath The directory location to save the icon at
 * @param urlString The url of the icon to be hashed and used as file name
 * @return A string representation of the directory the icon was saved to
*/
+ (nullable NSString *)sdl_writeImage:(UIImage *)icon toFilePath:(NSString *)filePath imageURL:(NSString *)urlString {
    NSError *error = nil;

    NSData *iconPNGData = UIImagePNGRepresentation(icon);
    NSString *iconStorageName = [self.class sdl_md5HashFromString:urlString];
    NSString *imageFilePath = [filePath stringByAppendingPathComponent:[iconStorageName stringByAppendingString:@".png"]];

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
 * @param error An error that occurs if the archiver fails to archive the object to file
*/
- (BOOL)updateArchiveFileWithIconURL:(NSString *)iconURL
                        iconFilePath:(NSString *)iconFilePath
                         archiveFile:(SDLIconArchiveFile *)archiveFile
                               error:(NSError **)error {
    NSMutableArray *archiveArray = [archiveFile.lockScreenIconCaches mutableCopy];
    
    // Need to remove duplicate SDLLockScreenIconCache object if handling expired icon
    for (SDLLockScreenIconCache *iconCacheCopy in archiveArray) {
        if ([iconCacheCopy.iconUrl isEqualToString:iconURL]) {
            [archiveArray removeObject:iconCacheCopy];
            break;
        }
    }
    
    // Add the new file to the archive
    [archiveArray addObject:[[SDLLockScreenIconCache alloc] initWithIconUrl:iconURL iconFilePath:iconFilePath]];
    archiveFile.lockScreenIconCaches = archiveArray;
    
    // HAX: Update this when we are iOS 11.0+. You will need to create a data object using 'archivedDataWithRootObject:requiringSecureCoding:error:', and write it to file using 'writeToFile:options:error:'
    // Write the new archive to disk
    BOOL writeSuccess = [NSKeyedArchiver archiveRootObject:archiveFile toFile:self.archiveFilePath];
    if (!writeSuccess) {
        if (!*error) {
            *error = [NSError errorWithDomain:SDLErrorDomainCacheFileManager code:SDLCacheManagerErrorUpdateIconArchiveFileFailure userInfo:nil];
            SDLLogE(@"Error attempting to write archive file to cache: %@", *error);
        }

        return NO;
    }

    return YES;
}


#pragma mark - Directory Getters

- (NSString *)cacheFileBaseDirectory {
    NSString *cacheDirectory = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    return [cacheDirectory stringByAppendingPathComponent:@"/sdl/lockScreenIcon/"];
}

- (NSString *)archiveFilePath {
    return [self.cacheFileBaseDirectory stringByAppendingPathComponent:@"archiveCacheFile.plist"];
}


#pragma mark - Download Image

/**
 * Handles request to download icon from request
 *
 * @param requestURL The System request URL used to download icon
 * @param completion The completion handler is called when the icon download succeeds or fails with error
*/
- (void)sdl_downloadIconFromRequestURL:(NSString *)requestURL withCompletionHandler:(ImageRetrievalCompletionHandler)completion {
    NSURL *url = [NSURL URLWithString:requestURL];
    if ([url.scheme isEqualToString:@"http"]) {
        url = [NSURL URLWithString:[requestURL stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"https"]];
    }

    self.dataTask = [self.urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogW(@"Lock screen icon download task failed: %@", error);
            return completion(nil, error);
        }

        UIImage *icon = [UIImage imageWithData:data];
        if (icon == nil) {
            SDLLogW(@"Returned data conversion to image failed: %@", error);
            return completion(nil, error);
        }

        return completion(icon, nil);
    }];

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
