//
//  SDLLogConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLLogModel;

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^SDLLogFilterBlock)(SDLLogModel *log);
typedef NSString * __nonnull (^SLLogFormatBlock)(SDLLogModel *log,  NSDateFormatter *dateFormatter);

typedef NS_OPTIONS(NSUInteger, SDLLogLevel) {
    SDLLogLevelVerbose = 1 << 0,
    SDLLogLevelDebug = 1 << 1,
    SDLLogLevelWarning = 1 << 2,
    SDLLogLevelError = 1 << 3
};

/**
 *  When used with a file module, this will use the global log level instead of a module specific log level
 */
extern const NSInteger SDLLogLevelDefault;

typedef NS_ENUM(NSUInteger, SDLLogFormatType) {
    SDLLogFormatTypeSimple,
    SDLLogFormatTypeDefault,
    SDLLogFormatTypeDetailed,
};

#pragma mark - Macros

#pragma mark - General Macros
#define SDLLOG_FILE   [[[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lastPathComponent] stringByDeletingPathExtension]
#define SDLLOG_FUNC   [NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding]

#pragma mark Debug Logs

#if DEBUG

#define SDLLogV(msg, ...) [SDLLogManager logWithLevel:SLLogLevelVerbose fileName:SLOG_FILE functionName:SLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];
#define SDLLogD(msg, ...) [SDLLogManager logWithLevel:SLLogLevelDebug fileName:SLOG_FILE functionName:SLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];

#else

#define SDLLogV(msg, ...)
#define SDLLogD(msg, ...)

#endif


#pragma mark Release Logs

#define SDLLogR(msg, ...) [SDLLogManager logWithLevel:SLLogLevelRelease fileName:SLOG_FILE functionName:SLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];
#define SDLLogE(msg, ...) [SDLLogManager logWithLevel:SLLogLevelError fileName:SLOG_FILE functionName:SLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];

NS_ASSUME_NONNULL_END
