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

/// An enum describing log bytes direction
typedef NS_ENUM(NSUInteger, SDLLogBytesDirection) {
    /// Transmit from the app
    SDLLogBytesDirectionTransmit,

    /// Receive from the module
    SDLLogBytesDirectionReceive
};

/**
 Flags used for SDLLogLevel to provide correct enum values. This is purely for internal use.
 */
typedef NS_OPTIONS(NSUInteger, SDLLogFlag) {
    /// Error level logging
    SDLLogFlagError = 1 << 0,

    /// Warning level logging
    SDLLogFlagWarning = 1 << 1,

    /// Debug level logging
    SDLLogFlagDebug = 1 << 2,

    /// Verbose level logging
    SDLLogFlagVerbose = 1 << 3,
};

/**
 An enum describing a level of logging.
 */
typedef NS_ENUM(NSInteger, SDLLogLevel) {
    /// This is used to describe that a "specific" logging will instead use the global log level, for example, a module may use the global log level instead of its own by specifying this level.
    SDLLogLevelDefault = -1,

    /// This is used to describe a level that involves absolutely no logs being output.
    SDLLogLevelOff = 0,

    /// Only error level logs will be output
    SDLLogLevelError = SDLLogFlagError,

    /// Both error and warning level logs will be output
    SDLLogLevelWarning = (SDLLogFlagError | SDLLogFlagWarning),

    /// Error, warning, and debug level logs will be output. This level will never be output in RELEASE environments
    SDLLogLevelDebug = (SDLLogFlagWarning | SDLLogFlagDebug),

    /// All level logs will be output. This level will never be output in RELEASE environments
    SDLLogLevelVerbose = (SDLLogFlagDebug | SDLLogFlagVerbose)
};

/**
 The output format of logs; how they will appear when printed out into a string.
 */
typedef NS_ENUM(NSUInteger, SDLLogFormatType) {
    /// A bare-bones log format: `09:52:07:324 🔹 (SDL)Protocol – a random test i guess`
    SDLLogFormatTypeSimple,

    ///  A middle detail default log format: `09:52:07:324 🔹 (SDL)Protocol:SDLV2ProtocolHeader:25 – Some log message`
    SDLLogFormatTypeDefault,

    /// A very detailed log format: `09:52:07:324 🔹 DEBUG com.apple.main-thread:(SDL)Protocol:[SDLV2ProtocolHeader parse:]:74 – Some log message`
    SDLLogFormatTypeDetailed,
};

NS_ASSUME_NONNULL_END
