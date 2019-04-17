//
//  SDLLogMacros.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 3/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLogManager.h"

#pragma mark - Macros

#pragma mark - General Macros

/**
 Used to get a string value of the current line's file name in Obj-C

 @warning Internal use only
 */
#define SDLLOG_FILE     [[[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent] stringByDeletingPathExtension]

/**
 Used to get a string value of the current line's function in Obj-C

 @warning Internal use only
 */
#define SDLLOG_FUNC     [NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]

/**
 Used to get a string value of the current line's dispatch queue in Obj-C

 @warning Internal use only
 */
#define SDLLOG_QUEUE    [NSString stringWithUTF8String:dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)]

#pragma mark Debug Logs

#if DEBUG

/**
 Log data bytes coming or going from SDL and the remote system to the console in verbose logging mode

 @warning Internal use only
 */
#define SDLLogBytes(bytes, transmissionDirection) [SDLLogManager logBytes:bytes direction:transmissionDirection timestamp:[NSDate date] file:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ queue:SDLLOG_QUEUE]

/**
 Log a verbose log

 @param msg The format string to log
 @param ... The format arguments to log
 */
#define SDLLogV(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelVerbose timestamp:[NSDate date] file:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ queue:SDLLOG_QUEUE formatMessage:msg, ##__VA_ARGS__]

/**
 Log a debug log

 @param msg The format string to log
 @param ... The format arguments to log
 */
#define SDLLogD(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelDebug timestamp:[NSDate date] file:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ queue:SDLLOG_QUEUE formatMessage:msg, ##__VA_ARGS__]

#else

/**
 A stub for logging data bytes, does not exist in RELEASE builds
 */
#define SDLLogBytes(bytes, transmissionDirection)

/**
 A stub for verbose logs, does not exist in RELEASE builds
 */
#define SDLLogV(msg, ...)

/**
 A stub for debug logs, does not exist in DEBUG builds
 */
#define SDLLogD(msg, ...)

#endif


#pragma mark Release Logs

/**
 Log a warning log

 @param msg The format string to log
 @param ... The format arguments to log
 */
#define SDLLogW(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelWarning timestamp:[NSDate date] file:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ queue:SDLLOG_QUEUE formatMessage:msg, ##__VA_ARGS__]

/**
 Log an error log

 @param msg The format string to log
 @param ... The format arguments to log
 */
#define SDLLogE(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelError timestamp:[NSDate date] file:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ queue:SDLLOG_QUEUE formatMessage:msg, ##__VA_ARGS__]

/**
 Log an assertion log. This will log an error, and assert by default in DEBUG (but this can be disabled in the SDLLogConfiguration).

 @param msg The format string to log
 @param ... The format arguments to log
 */
#define SDLLogAssert(msg, ...) [SDLLogManager logAssertWithTimestamp:[NSDate date] file:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ queue:SDLLOG_QUEUE formatMessage:msg, ##__VA_ARGS__]
