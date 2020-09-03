//
//  SDLLogConfiguration.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLogConstants.h"
#import "SDLLogFilter.h"
#import "SDLLogTarget.h"

@class SDLLogFileModule;


NS_ASSUME_NONNULL_BEGIN

/// Information about the current logging configuration
@interface SDLLogConfiguration : NSObject <NSCopying>

/**
 Any custom logging modules used by the developer's code. Defaults to none.
 */
@property (copy, nonatomic) NSSet<SDLLogFileModule *> *modules;

/**
 Where the logs will attempt to output. Defaults to Console.
 */
@property (copy, nonatomic) NSSet<id<SDLLogTarget>> *targets;

/**
 What log filters will run over this session. Defaults to none.
 */
@property (copy, nonatomic) NSSet<SDLLogFilter *> *filters;

/**
 How detailed of logs will be output. Defaults to Default.
 */
@property (assign, nonatomic) SDLLogFormatType formatType;

/**
 Whether or not logs will be run on a separate queue, asynchronously, allowing the following code to run before the log completes. Or if it will occur synchronously, which will prevent logs from being missed, but will slow down surrounding code. Defaults to YES.
 */
@property (assign, nonatomic, getter=isAsynchronous) BOOL asynchronous;

/**
 Whether or not error logs will be dispatched to loggers asynchronously. Defaults to NO.
 */
@property (assign, nonatomic, getter=areErrorsAsynchronous) BOOL errorsAsynchronous;

/**
 Whether or not assert logs will fire assertions in DEBUG mode. Assertions are always disabled in RELEASE builds. If assertions are disabled, only an error log will fire instead. Defaults to NO.
 */
@property (assign, nonatomic, getter=areAssertionsDisabled) BOOL disableAssertions;

/**
 Any modules that do not have an explicitly specified level will by default use the global log level. Defaults to Error.
 Do not specify Default for this parameter.
 */
@property (assign, nonatomic) SDLLogLevel globalLogLevel;


/**
 A default logger for production. This sets the format type to Default, the log level to Error, and the target to SDLLogTargetOSLog.

 @return A default configuration that may be customized.
 */
+ (instancetype)defaultConfiguration;

/**
 A debug logger for use in development. This sets the format type to Detailed, the log level to Debug, and enables the Console and ASL loggers.

 @return A debug configuration that may be customized.
 */
+ (instancetype)debugConfiguration;

@end

NS_ASSUME_NONNULL_END
