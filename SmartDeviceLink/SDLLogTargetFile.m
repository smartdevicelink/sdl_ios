//
//  SDLLogTargetFile.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/28/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLLogTargetFile.h"

#import "SDLLogModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLogTargetFile ()

@property (assign, nonatomic) NSUInteger maxFiles;
@property (strong, nonatomic, nullable) NSFileHandle *logFileHandle;

@end


@implementation SDLLogTargetFile

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _maxFiles = 3;

    return self;
}

+ (id<SDLLogTarget>)logger {
    return [[self alloc] init];
}

- (BOOL)setupLogger {
    self.logFileHandle = [self sdl_createFile];
    if (self.logFileHandle == nil) {
        return NO;
    }

    [self.logFileHandle seekToEndOfFile];

    return YES;
}

- (void)logWithLog:(SDLLogModel *)log formattedLog:(NSString *)stringLog {
    [self.logFileHandle writeData:[stringLog dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)teardownLogger {
    [self.logFileHandle synchronizeFile];
    [self.logFileHandle closeFile];
}

- (void)dealloc {
    [_logFileHandle synchronizeFile];
    [_logFileHandle closeFile];
}


#pragma mark - File handling

+ (NSString *)sdl_logDirectory {
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;

    return [documentsDirectory stringByAppendingPathComponent:@"/smartdevicelink/log/"];
}


#pragma mark File creation

- (NSFileHandle *)sdl_createFile {
    NSString *newFilePath = [[self.class sdl_logDirectory] stringByAppendingPathComponent:[self.class sdl_newFileName]];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:[self.class sdl_logDirectory]]) {
        [fileManager createDirectoryAtPath:[self.class sdl_logDirectory] withIntermediateDirectories:YES attributes:nil error:nil];
    }

    if ([fileManager fileExistsAtPath:newFilePath]) {
        [fileManager removeItemAtPath:newFilePath error:nil];
    }

    [fileManager createFileAtPath:newFilePath contents:nil attributes:nil];
    [self.class sdl_cleanupLogFilesWithMaxFiles:self.maxFiles];

    return [NSFileHandle fileHandleForWritingAtPath:newFilePath];
}

+ (NSString *)sdl_newFileName {
    // Grab the name of the app if available, or just use 'smartdevicelink' if it's not
    NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    if (appName == nil) {
        appName = @"smartdevicelink";
    }

    NSDateFormatter *fileDateFormatter = [[NSDateFormatter alloc] init];
    fileDateFormatter.dateFormat = @"yyyy-MM-dd-HH:mm:ss";

    return [NSString stringWithFormat:@"%@-%@.log", [fileDateFormatter stringFromDate:[NSDate date]], appName];
}


#pragma mark File cleanup

+ (void)sdl_cleanupLogFilesWithMaxFiles:(NSUInteger)maxFiles {
    NSArray<NSString *> *sortedLogFilePaths = [self sdl_sortedLogFilePaths];

    // If we have more files now than the max, remove the oldest ones
    NSUInteger filesToRemove = sortedLogFilePaths.count - maxFiles;
    for (NSUInteger i = 0; i < filesToRemove; i++) {
        NSString *path = [[self sdl_logDirectory] stringByAppendingPathComponent:sortedLogFilePaths[i]];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

/**
 Return the sorted file paths in order from oldest to newest (based on the file names).

 @return An array of file paths from oldest to newest
 */
+ (NSArray<NSString *> *)sdl_sortedLogFilePaths {
    NSArray *logFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[self sdl_logDirectory] error:nil];
    return [logFiles sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}


#pragma mark - NSObject

- (NSUInteger)hash {
    return NSStringFromClass(self.class).hash;
}

// For the target classes, we're going to assume that if they're the same class, they're the same. The reason for this is so that NSSet, for instance, will only allow one of each target type in a set.
- (BOOL)isEqual:(id)object {
    return [object isMemberOfClass:self.class];
}

@end

NS_ASSUME_NONNULL_END
