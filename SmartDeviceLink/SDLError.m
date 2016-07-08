//
//  SDLErrorConstants.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLError.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark Error Domains

NSString *const SDLManagerErrorDomain = @"com.sdl.manager";
NSString *const SDLFileManagerErrorDomain = @"com.sdl.filemanager";

@implementation NSError (SDLErrors)

#pragma mark - SDLManager

+ (NSError *)sdl_lifecycle_rpcErrorWithDescription:(NSString *)description andReason:(NSString *)reason {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    return [NSError errorWithDomain:SDLManagerErrorDomain
                               code:SDLManagerErrorRPCRequestFailed
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_notConnectedError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Could not find a connection", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The SDL library could not find a current connection to an SDL hardware device", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    
    return [NSError errorWithDomain:SDLManagerErrorDomain
                               code:SDLManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_notReadyError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Lifecycle manager not ready", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The SDL library is not finished setting up the connection, please wait until the lifecycleState is SDLLifecycleStateReady", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    
    return [NSError errorWithDomain:SDLManagerErrorDomain
                               code:SDLManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_unknownRemoteErrorWithDescription:(NSString *)description andReason:(NSString *)reason {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    return [NSError errorWithDomain:SDLManagerErrorDomain
                               code:SDLManagerErrorUnknownRemoteError
                           userInfo:userInfo];
}


#pragma mark SDLFileManager

+ (NSError *)sdl_fileManager_cannotOverwriteError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Cannot overwrite remote file", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The remote file system already has a file of this name, and the file manager is set to not automatically overwrite files", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Set SDLFileManager autoOverwrite to YES, or call forceUploadFile:completion:", nil)
                               };
    return [NSError errorWithDomain:SDLFileManagerErrorDomain code:SDLFileManagerErrorCannotOverwrite userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_noKnownFileError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"No such remote file is currently known", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The remote file is not currently known by the file manager. It could be that this file does not exist on the remote system or that the file manager has not completed its initialization and received a list of files from the remote system.", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure a file with this name is present on the remote system and that the file manager has finished its initialization.", nil)
                               };
    return [NSError errorWithDomain:SDLFileManagerErrorDomain code:SDLFileManagerErrorNoKnownFile userInfo:userInfo];
}

@end


@implementation NSException (SDLExceptions)

+ (NSException *)sdl_missingHandlerException {
    return [NSException
            exceptionWithName:@"MissingHandlerException"
            reason:@"This request requires a handler to be specified using the <RPC>WithHandler class"
            userInfo:nil];
}

+ (NSException *)sdl_missingIdException {
    return [NSException
            exceptionWithName:@"MissingIdException"
            reason:@"This request requires an ID (command, softbutton, etc) to be specified"
            userInfo:nil];
}

@end

NS_ASSUME_NONNULL_END