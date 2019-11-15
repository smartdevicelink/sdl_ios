//
//  SDLLogFilter.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLogConstants.h"

@class SDLLogFileModule;
@class SDLLogModel;


NS_ASSUME_NONNULL_BEGIN

/// Represents a filter over which SDL logs should be logged
@interface SDLLogFilter : NSObject

/// A block that takes in a log model and returns whether or not the log passes the filter and should therefore be logged.
@property (strong, nonatomic, readonly) SDLLogFilterBlock filter;

/// Initializer unavailable
- (instancetype)init NS_UNAVAILABLE;

/**
 Create a new filter with a custom filter block. The filter block will take a log model and return a BOOL of pass / fail.

 @param filter The custom filter to be used
 @return An instance of SDLLogFilter
 */
- (instancetype)initWithCustomFilter:(SDLLogFilterBlock)filter NS_DESIGNATED_INITIALIZER;

/**
 Returns a filter that only allows logs not containing the passed string within their message.

 @param string The string, which, if present in the message of the log, will prevent the log from being logged.
 @param caseSensitive Whether or not `string` should be checked as case sensitive against the log's message.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilter *)filterByDisallowingString:(NSString *)string caseSensitive:(BOOL)caseSensitive;

/**
 Returns a filter that only allows logs containing the passed string within their message.

 @param string The string, which, if present in the message of the log, will allow the log to be logged.
 @param caseSensitive Whether or not `string` should be checked as case sensitive against the log's message.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilter *)filterByAllowingString:(NSString *)string caseSensitive:(BOOL)caseSensitive;

/**
 Returns a filter that only allows logs not passing the passed regex against their message.

 @param regex The regex, which, if it matches the message of the log, will prevent the log from being logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilter *)filterByDisallowingRegex:(NSRegularExpression *)regex;

/**
 Returns a filter that only allows logs passing the passed regex against their message.

 @param regex The regex, which, if it matches the message of the log, will allow the log to be logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilter *)filterByAllowingRegex:(NSRegularExpression *)regex;

/**
 Returns a filter that only allows logs not within the specified file modules to be logged.

 @param modules A set of module names. If any match, they will not be logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilter *)filterByDisallowingModules:(NSSet<NSString *> *)modules;

/**
 Returns a filter that only allows logs of the specified file modules to be logged.

 @param modules A set of module names. If any match, they will not be logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilter *)filterByAllowingModules:(NSSet<NSString *> *)modules;

/**
 Returns a filter that only allows logs not within the specified files to be logged.

 @param fileNames If a log matches any of the passed files, the log will not be logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilter *)filterByDisallowingFileNames:(NSSet<NSString *> *)fileNames;

/**
 Returns a filter that only allows logs within the specified files to be logged.

 @param fileNames If a log matches any of the passed files, the log will be logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilter *)filterByAllowingFileNames:(NSSet<NSString *> *)fileNames;

@end

NS_ASSUME_NONNULL_END
