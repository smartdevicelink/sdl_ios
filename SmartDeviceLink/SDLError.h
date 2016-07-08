//
//  SDLErrorConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SDLManagerError) {
    SDLManagerErrorRPCRequestFailed = -1,
    SDLManagerErrorNotConnected = -2,
    SDLManagerErrorNotReady = -3,
    SDLManagerErrorUnknownRemoteError = -4
};

typedef NS_ENUM(NSInteger, SDLFileManagerError) {
    SDLFileManagerErrorCannotOverwrite = -1,
    SDLFileManagerErrorNoKnownFile = -2
};

typedef NS_ENUM(NSInteger, SDLStateMachineError) {
    SDLStateMachineErrorInvalidTransitionOccurred = -1
};

#pragma mark Error Domains
extern NSString *const SDLManagerErrorDomain;
extern NSString *const SDLFileManagerErrorDomain;

@interface NSError (SDLErrors)

#pragma mark SDLManager

+ (NSError *)sdl_lifecycle_rpcErrorWithDescription:(NSString *)description andReason:(NSString *)reason;
+ (NSError *)sdl_lifecycle_notConnectedError;
+ (NSError *)sdl_lifecycle_notReadyError;
+ (NSError *)sdl_lifecycle_unknownRemoteErrorWithDescription:(NSString *)description andReason:(NSString *)reason;

#pragma mark SDLFileManager

+ (NSError *)sdl_fileManager_cannotOverwriteError;
+ (NSError *)sdl_fileManager_noKnownFileError;

@end

@interface NSException (SDLExceptions)

+ (NSException *)sdl_missingHandlerException;
+ (NSException *)sdl_missingIdException;

@end

NS_ASSUME_NONNULL_END