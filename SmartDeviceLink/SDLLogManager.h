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

@interface SDLLogManager : NSObject

@property (copy, nonatomic, readonly) NSSet<SDLLogFileModule *> *logModules;
@property (copy, nonatomic, readonly) NSSet<id<SDLLogTarget>> *logTargets;
@property (copy, nonatomic, readonly) NSSet<SDLLogFilterBlock> *logFilters;

@property (assign, nonatomic, readonly, getter=isAsynchronous) BOOL asynchronous;
@property (assign, nonatomic, readonly, getter=areErrorsAsynchronous) BOOL errorsAsynchronous;

// Any modules that do not have an explicitly specified level will by default use the global log level;
@property (assign, nonatomic, readonly) SDLLogLevel globalLogLevel;

+ (SDLLogManager *)sharedManager;

// These are automatically sent to the sharedManager
#pragma mark - Singleton Methods

+ (void)startWithConfiguration:(SDLLogConfiguration *)configuration;

// This would be used internally to send out a log to the loggers
+ (void)logWithLevel:(SDLLogLevel)level
                file:(NSString *)file
        functionName:(NSString *)functionName
                line:(NSInteger)line
       formatMessage:(NSString *)message, ... NS_FORMAT_FUNCTION(5, 6);

// This would be used internally for the Swift extension to send out a fully formed message
+ (void)logWithLevel:(SDLLogLevel)level
                file:(NSString *)file
        functionName:(NSString *)functionName
                line:(NSInteger)line
             message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
