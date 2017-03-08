//
//  SDLLogManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLogConstants.h"
#import "SDLLogTarget.h"

@class SDLLogConfiguration;
@class SDLLogFileModule;


NS_ASSUME_NONNULL_BEGIN

/**
 This is the central manager of logging. A developer should not have to interact with this class, it is exclusively used internally.
 */
@interface SDLLogManager : NSObject

@property (copy, nonatomic, readonly) NSSet<SDLLogFileModule *> *logModules;
@property (copy, nonatomic, readonly) NSSet<id<SDLLogTarget>> *logTargets;
@property (copy, nonatomic, readonly) NSSet<SDLLogFilterBlock> *logFilters;

/// Any modules that do not have an explicitly specified level will by default use this log level
@property (assign, nonatomic, readonly) SDLLogLevel globalLogLevel;
@property (assign, nonatomic, readonly) SDLLogFormatType formatType;

@property (assign, nonatomic, readonly, getter=isAsynchronous) BOOL asynchronous;
@property (assign, nonatomic, readonly, getter=areErrorsAsynchronous) BOOL errorsAsynchronous;

+ (SDLLogManager *)sharedManager;

// These are automatically sent to the sharedManager
#pragma mark - Singleton Methods

/**
 Sets a configuration to be used by the log manager's sharedManager. This is generally for internal use and you should set your configuration using SDLManager's startWithConfiguration: method.

 @param configuration The configuration to be used.
 */
+ (void)setConfiguration:(SDLLogConfiguration *)configuration;

/**
 Sets a configuration to be used by the log manager. This is generally for internal use and you should set your configuration using SDLManager's startWithConfiguration: method.

 @param configuration The configuration to be used.
 */
- (void)setConfiguration:(SDLLogConfiguration *)configuration;

/**
 Log to the sharedManager's active log targets. This is used internally to log. If you want to create a log, you should use macros such as `SDLLogD`.

 @param level The level of the log
 @param file The file the log originated from
 @param functionName The function the log originated from
 @param line The line the log originated from
 @param message The message of the log with a format
 */
+ (void)logWithLevel:(SDLLogLevel)level
                file:(NSString *)file
        functionName:(NSString *)functionName
                line:(NSInteger)line
               queue:(NSString *)queueLabel
       formatMessage:(NSString *)message, ... NS_FORMAT_FUNCTION(6, 7);

/**
 Log to this log manager's active log targets. This is used internally to log. If you want to create a log, you should use macros such as `SDLLogD`.

 @param level The level of the log
 @param file The file the log originated from
 @param functionName The function the log originated from
 @param line The line the log originated from
 @param message The message of the log with a format
 */
- (void)logWithLevel:(SDLLogLevel)level
                file:(NSString *)file
        functionName:(NSString *)functionName
                line:(NSInteger)line
               queue:(NSString *)queueLabel
       formatMessage:(NSString *)message, ... NS_FORMAT_FUNCTION(6, 7);

/**
 Log to this sharedManager's active log targets. This is used internally to log. If you want to create a log, you should use macros such as `SDLLogD`.

 @param level The level of the log
 @param file The file the log originated from
 @param functionName The function the log originated from
 @param line The line the log originated from
 @param message The message of the log
 */
+ (void)logWithLevel:(SDLLogLevel)level
                file:(NSString *)file
        functionName:(NSString *)functionName
                line:(NSInteger)line
               queue:(NSString *)queueLabel
             message:(NSString *)message;

/**
 Log to this log manager's active log targets. This is used internally to log. If you want to create a log, you should use macros such as `SDLLogD`.

 @param level The level of the log
 @param file The file the log originated from
 @param functionName The function the log originated from
 @param line The line the log originated from
 @param message The message of the log
 */
- (void)logWithLevel:(SDLLogLevel)level
                file:(NSString *)file
        functionName:(NSString *)functionName
                line:(NSInteger)line
               queue:(NSString *)queueLabel
             message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
