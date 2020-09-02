//
//  SDLLogModel.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/27/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLLogConstants.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLLogModel : NSObject <NSCopying>

/**
 The log message written by the developer. This is the resolved format message if one was used.
 */
@property (copy, nonatomic, readonly) NSString *message;

/**
 The raw timestamp collected by the logging framework when the log triggered.
 */
@property (copy, nonatomic, readonly) NSDate *timestamp;

/**
 The log level of this individual log. If it's a debug log, and triggered because the global level is verbose, this will be debug.
 */
@property (assign, nonatomic, readonly) SDLLogLevel level;

/**
 The label of the dispatch_queue, for example "com.apple.main-queue".
 */
@property (copy, nonatomic, readonly) NSString *queueLabel;

/**
 A module name if one exists for the file name, or `""` if one does not.
 */
@property (copy, nonatomic, null_resettable, readonly) NSString *moduleName;

/**
 The file name from which the log was triggered.
 */
@property (copy, nonatomic, readonly) NSString *fileName;

/**
 The function name from which the log was triggered.
 */
@property (copy, nonatomic, readonly) NSString *functionName;

/**
 The line number of the file from which the log was triggered.
 */
@property (assign, nonatomic, readonly) NSInteger line;

/**
 Returns a fully initialized log message.

 @param message The log message written by the developer. This is the resolved format message if one was used.
 @param timestamp The raw timestamp collected by the logging framework when the log triggered.
 @param level The log level of this individual log. If it's a debug log, and triggered because the global level is verbose, this will be debug.
 @param fileName The file name from which the log was triggered.
 @param moduleName A module name if one exists for the file name, or `""` if one does not.
 @param functionName The function name from which the log was triggered.
 @param line The line number of the file from which the log was triggered.
 @param queueLabel The label of the dispatch_queue, for example "com.apple.main-queue".
 @return a fully initialized log message.
 */
- (instancetype)initWithMessage:(NSString *)message
                      timestamp:(NSDate *)timestamp
                          level:(SDLLogLevel)level
                       fileName:(NSString *)fileName
                     moduleName:(nullable NSString *)moduleName
                   functionName:(NSString *)functionName
                           line:(NSInteger)line
                     queueLabel:(NSString *)queueLabel;

@end

NS_ASSUME_NONNULL_END
