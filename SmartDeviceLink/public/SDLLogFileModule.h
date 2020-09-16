//
//  SDLLogFileModule.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLogConstants.h"


NS_ASSUME_NONNULL_BEGIN

/// A log file module is a collection of source code files that form a cohesive unit and that logs can all use to describe themselves. E.g. a "transport" module, or a "Screen Manager" module.
@interface SDLLogFileModule : NSObject

/**
 The name of the this module, e.g. "Transport"
 */
@property (copy, nonatomic, readonly) NSString *name;

/**
 All of the files contained within this module. When a log is logged, the `__FILE__` (in Obj-C) or `#file` (in Swift) is automatically captured and checked to see if any module has a file in this set that matches. If it does, it will be logged using the module's log level and the module's name will be printed in the formatted log.
 */
@property (copy, nonatomic, readonly) NSSet<NSString *> *files;

/**
 The custom level of the log. This is `SDLLogLevelDefault` (whatever the current global log level is) by default.
 */
@property (assign, nonatomic) SDLLogLevel logLevel;

/**
 This method is unavailable and may not be used.

 @return Always returns nil
 */
- (instancetype)init NS_UNAVAILABLE;

/**
 Returns an initialized `SDLLogFileModule` that contains a custom name, set of files, and associated log level.

 @param name The name of this module. This will be used when printing a formatted log for a file within this module e.g. "Transport".
 @param files The files this module covers. This should correspond to a `__FILE__` or `#file` call for use when comparing a log to this module. Any log originating in a file contained in this set will then use this module's log level and print the module name.
 @param level The custom logging level logs originating in files contained in this log module will use. For example, if the global level is `SDLLogLevelError` and this module is configured to `SDLLogLevelVerbose`, all logs originating from files within this module will be logged, not merely error logs.
 @return An initialized `SDLLogFileModule`
 */
- (instancetype)initWithName:(NSString *)name files:(NSSet<NSString *> *)files level:(SDLLogLevel)level NS_DESIGNATED_INITIALIZER;

/**
 Returns an initialized `SDLLogFileModule` that contains a custom name and set of files. The logging level is the same as the current global logging file by using `SDLLogLevelDefault`.

 @param name The name of this module. This will be used when printing a formatted log for a file within this module e.g. "Transport".
 @param files The files this module covers. This should correspond to a `__FILE__` or `#file` call for use when comparing a log to this module. Any log originating in a file contained in this set will then use this module's log level and print the module name.
 @return An initialized `SDLLogFileModule`
 */
- (instancetype)initWithName:(NSString *)name files:(NSSet<NSString *> *)files;

/**
 Returns an initialized `SDLLogFileModule` that contains a custom name and set of files. The logging level is the same as the current global logging file by using `SDLLogLevelDefault`.

 @param name The name of this module. This will be used when printing a formatted log for a file within this module e.g. "Transport".
 @param files The files this module covers. This should correspond to a `__FILE__` or `#file` call for use when comparing a log to this module. Any log originating in a file contained in this set will then use this module's log level and print the module name.
 @return An initialized `SDLLogFileModule`
 */
+ (instancetype)moduleWithName:(NSString *)name files:(NSSet<NSString *> *)files;

/**
 Returns whether or not this module contains a given file.

 @param fileName The file name to check
 @return A BOOL, YES if this module contains the given file.
 */
- (BOOL)containsFile:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
