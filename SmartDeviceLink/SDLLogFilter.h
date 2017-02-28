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

@interface SDLLogFilter : NSObject

/**
 Returns a filter that only allows logs not containing the passed string within their message.

 @param string The string, which, if present in the message of the log, will prevent the log from being logged.
 @param caseSensitive Whether or not `string` should be checked as case sensitive against the log's message.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilterBlock)filterByDisallowingString:(NSString *)string caseSensitive:(BOOL)caseSensitive;

/**
 Returns a filter that only allows logs containing the passed string within their message.

 @param string The string, which, if present in the message of the log, will allow the log to be logged.
 @param caseSensitive Whether or not `string` should be checked as case sensitive against the log's message.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilterBlock)filterByAllowingString:(NSString *)string caseSensitive:(BOOL)caseSensitive;

/**
 Returns a filter that only allows logs not passing the passed regex against their message.

 @param regex The regex, which, if it matches the message of the log, will prevent the log from being logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilterBlock)filterByDisallowingRegex:(NSRegularExpression *)regex;

/**
 Returns a filter that only allows logs passing the passed regex against their message.

 @param regex The regex, which, if it matches the message of the log, will allow the log to be logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilterBlock)filterByAllowingRegex:(NSRegularExpression *)regex;

/**
 Returns a filter that only allows logs not within the specified file modules to be logged.

 @param modules If a log matches any of the passed modules, the log will not be logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilterBlock)filterByDisallowingModules:(NSSet<SDLLogFileModule *> *)modules;

/**
 Returns a filter that only allows logs of the specified file modules to be logged.

 @param modules If a log matches any of the passed modules, the log will be logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilterBlock)filterByAllowingModules:(NSSet<SDLLogFileModule *> *)modules;

/**
 Returns a filter that only allows logs not within the specified files to be logged.

 @param fileNames If a log matches any of the passed files, the log will not be logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilterBlock)filterByDisallowingFileNames:(NSSet<NSString *> *)fileNames;

/**
 Returns a filter that only allows logs within the specified files to be logged.

 @param fileNames If a log matches any of the passed files, the log will be logged.
 @return A filter that may be passed into the `logConfiguration`.
 */
+ (SDLLogFilterBlock)filterByAllowingFileNames:(NSSet<NSString *> *)fileNames;

@end

NS_ASSUME_NONNULL_END
