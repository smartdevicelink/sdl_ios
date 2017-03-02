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

typedef NS_OPTIONS(NSUInteger, SDLLogFlag) {
    SDLLogFlagVerbose = 1 << 0,
    SDLLogFlagDebug = 1 << 1,
    SDLLogFlagWarning = 1 << 2,
    SDLLogFlagError = 1 << 3
};

typedef NS_ENUM(NSInteger, SDLLogLevel) {
    SDLLogLevelDefault = -1,
    SDLLogLevelOff = 0,
    SDLLogLevelError = SDLLogFlagError,
    SDLLogLevelWarning = (SDLLogFlagError | SDLLogFlagWarning),
    SDLLogLevelDebug = (SDLLogFlagWarning | SDLLogFlagDebug),
    SDLLogLevelVerbose = (SDLLogFlagDebug | SDLLogFlagVerbose)
};

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

#define SDLLogV(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelVerbose fileName:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];
#define SDLLogD(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelDebug fileName:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];

#else

#define SDLLogV(msg, ...)
#define SDLLogD(msg, ...)

#endif


#pragma mark Release Logs

#define SDLLogW(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelWarning fileName:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];
#define SDLLogE(msg, ...) [SDLLogManager logWithLevel:SDLLogLevelError fileName:SDLLOG_FILE functionName:SDLLOG_FUNC line:__LINE__ message:msg, ##__VA_ARGS__];

NS_ASSUME_NONNULL_END
