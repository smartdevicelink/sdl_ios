//
//  SDLLogTarget.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLLogModel;


NS_ASSUME_NONNULL_BEGIN

/**
 A protocol describing a place logs from SDLLogManager are logged to
 */
@protocol SDLLogTarget <NSObject>

/**
 A simple convenience initializer to create the object. This *should not* start up the logger.

 @return An instance of the logger.
 */
+ (id<SDLLogTarget>)logger;

/**
 A call to setup the logger in whatever manner it needs to do so.

 @return Whether or not the logger set up correctly.
 */
- (BOOL)setupLogger;

/**
 Log a particular log using the model and the formatted log message to the target.

 @param log The log model, if you can log additional data, such as the log level, use this
 @param stringLog The formatted message
 */
- (void)logWithLog:(SDLLogModel *)log formattedLog:(NSString *)stringLog;

/**
 The log target should be torn down. e.g. file handles should be closed
 */
- (void)teardownLogger;

@end

NS_ASSUME_NONNULL_END
