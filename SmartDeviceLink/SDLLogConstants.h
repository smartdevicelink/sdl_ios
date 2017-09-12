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

/**
 A block that takes in a log model and returns whether or not the log passes the filter and should therefore be logged.

 @param log The log model describing the log.
 @return    Whether or not the log should be logged.
 */
typedef BOOL (^SDLLogFilterBlock)(SDLLogModel *log);

typedef NS_ENUM(NSUInteger, SDLLogBytesDirection) {
    SDLLogBytesDirectionTransmit,
    SDLLogBytesDirectionReceive
};

/**
 Flags used for SDLLogLevel to provide correct enum values. This is purely for internal use.

 - SDLLogFlagVerbose:   Verbose level logging
 - SDLLogFlagDebug:     Debug level logging
 - SDLLogFlagWarning:   Warning level logging
 - SDLLogFlagError:     Error level logging.
 */
typedef NS_OPTIONS(NSUInteger, SDLLogFlag) {
    SDLLogFlagError = 1 << 0,
    SDLLogFlagWarning = 1 << 1,
    SDLLogFlagDebug = 1 << 2,
    SDLLogFlagVerbose = 1 << 3,
};

/**
 An enum describing a level of logging.

 - SDLLogLevelDefault:  This is used to describe that a "specific" logging will instead use the global log level, for example, a module may use the global log level instead of its own by specifying this level.
 - SDLLogLevelOff:      This is used to describe a level that involves absolutely no logs being output.
 - SDLLogLevelError:    Only error level logs will be output.
 - SDLLogLevelWarning:  Both error and warning level logs will be output.
 - SDLLogLevelDebug:    Error, warning, and debug level logs will be output. This level will never be output in RELEASE environments.
 - SDLLogLevelVerbose:  All level logs will be output. This level will never be output in RELEASE environments.
 */
typedef NS_ENUM(NSInteger, SDLLogLevel) {
    SDLLogLevelDefault = -1,
    SDLLogLevelOff = 0,
    SDLLogLevelError = SDLLogFlagError,
    SDLLogLevelWarning = (SDLLogFlagError | SDLLogFlagWarning),
    SDLLogLevelDebug = (SDLLogFlagWarning | SDLLogFlagDebug),
    SDLLogLevelVerbose = (SDLLogFlagDebug | SDLLogFlagVerbose)
};

/**
 The output format of logs; how they will appear when printed out into a string.

 - SDLLogFormatTypeSimple:      A bare-bones log format: `09:52:07:324 🔹 (SDL)Protocol – a random test i guess`
 - SDLLogFormatTypeDefault:     A middle detail default log format: `09:52:07:324 🔹 (SDL)Protocol:SDLV2ProtocolHeader:25 – Some log message`
 - SDLLogFormatTypeDetailed:    A very detailed log format: `09:52:07:324 🔹 DEBUG com.apple.main-thread:(SDL)Protocol:[SDLV2ProtocolHeader parse:]:74 – Some log message`
 */
typedef NS_ENUM(NSUInteger, SDLLogFormatType) {
    SDLLogFormatTypeSimple,
    SDLLogFormatTypeDefault,
    SDLLogFormatTypeDetailed,
};

NS_ASSUME_NONNULL_END
