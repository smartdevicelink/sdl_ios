//
//  SDLErrorConstants.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLError.h"

#import "SDLResult.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark Error Domains

SDLErrorDomain *const SDLErrorDomainLifecycleManager = @"com.sdl.lifecyclemanager.error";
SDLErrorDomain *const SDLErrorDomainFileManager = @"com.sdl.filemanager.error";

@implementation NSError (SDLErrors)

#pragma mark - SDLManager

+ (NSError *)sdl_lifecycle_rpcErrorWithDescription:(NSString *)description andReason:(NSString *)reason {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
    };
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorRPCRequestFailed
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_notConnectedError {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(@"Could not find a connection", nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The SDL library could not find a current connection to an SDL hardware device", nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
    };

    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_notReadyError {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(@"Lifecycle manager not ready", nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The SDL library is not finished setting up the connection, please wait until the lifecycleState is SDLLifecycleStateReady", nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
    };

    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_unknownRemoteErrorWithDescription:(NSString *)description andReason:(NSString *)reason {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
    };
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorUnknownRemoteError
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_managersFailedToStart {
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorManagersFailedToStart
                           userInfo:nil];
}

+ (NSError *)sdl_lifecycle_startedWithBadResult:(SDLResult *)result info:(NSString *)info {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(result.value, nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(info, nil)
    };
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorRegistrationFailed
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_failedWithBadResult:(SDLResult *)result info:(NSString *)info {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(result.value, nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(info, nil)
    };
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorRegistrationFailed
                           userInfo:userInfo];
}


#pragma mark SDLFileManager

+ (NSError *)sdl_fileManager_cannotOverwriteError {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(@"Cannot overwrite remote file", nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The remote file system already has a file of this name, and the file manager is set to not automatically overwrite files", nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Set SDLFileManager autoOverwrite to YES, or call forceUploadFile:completion:", nil)
    };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorCannotOverwrite userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_noKnownFileError {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(@"No such remote file is currently known", nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The remote file is not currently known by the file manager. It could be that this file does not exist on the remote system or that the file manager has not completed its initialization and received a list of files from the remote system.", nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure a file with this name is present on the remote system and that the file manager has finished its initialization.", nil)
    };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorNoKnownFile userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_unableToStartError {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(@"The file manager was unable to start", nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"This may be because files are not supported on this unit and / or LISTFILES returned an error", nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that the system is sending back a proper LIST FILES response", nil)
    };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorUnableToStart userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_unableToUploadError {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: NSLocalizedString(@"The file manager was unable to send this file", nil),
        NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"This could be because the file manager has not started, or the head unit does not support files", nil),
        NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that the system is sending back a proper LIST FILES response and check the file manager's state", nil)
    };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorUnableToUpload userInfo:userInfo];
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
