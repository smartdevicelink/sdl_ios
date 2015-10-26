//
//  SDLErrorConstants.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLError.h"

#pragma mark Error Domains

NSString *const SDLManagerErrorDomain = @"com.sdl.manager";
NSString *const SDLFileManagerErrorDomain = @"com.sdl.filemanager";

@implementation NSError (SDLErrors)

#pragma mark - SDLManager

+ (NSError *)sdl_manager_rpcErrorWithDescription:(NSString *)description andReason:(NSString *)reason {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    return [NSError errorWithDomain:SDLManagerErrorDomain
                               code:SDLManagerErrorRPCRequestFailed
                           userInfo:userInfo];
}

+ (NSError *)sdl_manager_notConnectedError {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(@"Could not find a connection", nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The SDL library could not find a current connection to an SDL hardware device", nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    
    return [NSError errorWithDomain:SDLManagerErrorDomain
                               code:SDLManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_manager_unknownHeadUnitErrorWithDescription:(NSString *)description andReason:(NSString *)reason {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Have you tried turning it off and on again?", nil)
                               };
    return [NSError errorWithDomain:SDLManagerErrorDomain
                               code:SDLManagerErrorUnknownHeadUnitError
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

@end
