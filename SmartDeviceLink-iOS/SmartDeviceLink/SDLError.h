//
//  SDLErrorConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SDLManagerError) {
    SDLManagerErrorRPCRequestFailed = -1,
    SDLManagerErrorNotConnected = -2,
    SDLManagerErrorUnknownHeadUnitError = -3
};

typedef NS_ENUM(NSInteger, SDLFileManagerError) {
    SDLFileManagerErrorCannotOverwrite = -1
};

#pragma mark Error Domains
extern NSString *const SDLManagerErrorDomain;
extern NSString *const SDLFileManagerErrorDomain;

@interface NSError (SDLErrors)

#pragma mark SDLManager

+ (NSError *)sdl_manager_rpcErrorWithDescription:(NSString *)description andReason:(NSString *)reason;
+ (NSError *)sdl_manager_notConnectedError;
+ (NSError *)sdl_manager_unknownHeadUnitErrorWithDescription:(NSString *)description andReason:(NSString *)reason;

#pragma mark SDLFileManager

+ (NSError *)sdl_fileManager_cannotOverwriteError;

@end
