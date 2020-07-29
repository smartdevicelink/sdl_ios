//
//  SDLErrorConstants.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLError.h"

#import "SDLChoiceSetManager.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark Error Domains

SDLErrorDomain *const SDLErrorDomainLifecycleManager = @"com.sdl.lifecyclemanager.error";
SDLErrorDomain *const SDLErrorDomainEncryptionLifecycleManager = @"com.sdl.encryptionlifecyclemanager.error";
SDLErrorDomain *const SDLErrorDomainFileManager = @"com.sdl.filemanager.error";
SDLErrorDomain *const SDLErrorDomainTextAndGraphicManager = @"com.sdl.textandgraphicmanager.error";
SDLErrorDomain *const SDLErrorDomainSoftButtonManager = @"com.sdl.softbuttonmanager.error";
SDLErrorDomain *const SDLErrorDomainSubscribeButtonManager = @"com.sdl.subscribebuttonmanager.error";
SDLErrorDomain *const SDLErrorDomainMenuManager = @"com.sdl.menumanager.error";
SDLErrorDomain *const SDLErrorDomainChoiceSetManager = @"com.sdl.choicesetmanager.error";
SDLErrorDomain *const SDLErrorDomainSystemCapabilityManager = @"com.sdl.systemcapabilitymanager.error";
SDLErrorDomain *const SDLErrorDomainTransport = @"com.sdl.transport.error";
SDLErrorDomain *const SDLErrorDomainRPCStore = @"com.sdl.rpcStore.error";
SDLErrorDomain *const SDLErrorDomainCacheFileManager = @"com.sdl.cachefilemanager.error";
SDLErrorDomain *const SDLErrorDomainAudioStreamManager = @"com.sdl.extension.pcmAudioStreamManager";

@implementation NSError (SDLErrors)

#pragma mark - SDLEncryptionLifecycleManager
+ (NSError *)sdl_encryption_lifecycle_notReadyError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Encryption Lifecycle manager not ready",
                                                       NSLocalizedFailureReasonErrorKey: @"The SDL library is not finished setting up the connection, please wait until the encryption lifecycleState is SDLEncryptionLifecycleStateReady",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure HMI is not NONE and at least one RPC requires encryption in permissions?"
                                                       };
    
    return [NSError errorWithDomain:SDLErrorDomainEncryptionLifecycleManager
                               code:SDLEncryptionLifecycleManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_encryption_lifecycle_encryption_off {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Encryption Lifecycle received a ACK with encryption bit = 0",
                                                       NSLocalizedFailureReasonErrorKey: @"The SDL library received ACK with encryption = OFF.",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure you are on a supported remote head unit with proper policies and your app id is approved."
                                                       };
    
    return [NSError errorWithDomain:SDLErrorDomainEncryptionLifecycleManager
                               code:SDLEncryptionLifecycleManagerErrorEncryptionOff
                           userInfo:userInfo];
}

+ (NSError *)sdl_encryption_lifecycle_nak {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Encryption Lifecycle received a negative acknowledgement",
                                                       NSLocalizedFailureReasonErrorKey: @"The remote head unit sent a NAK.  Encryption service failed to start due to NAK.",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure your certificates are valid."
                                                       };
    
    return [NSError errorWithDomain:SDLErrorDomainEncryptionLifecycleManager
                               code:SDLEncryptionLifecycleManagerErrorNAK
                           userInfo:userInfo];

}

#pragma mark - SDLManager

+ (NSError *)sdl_lifecycle_rpcErrorWithDescription:(nullable NSString *)description andReason:(nullable NSString *)reason {
    NSString *descriptionString = description ?: @"";
    NSString *reasonString = reason ?: @"";
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: descriptionString,
                                                       NSLocalizedFailureReasonErrorKey: reasonString
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorRPCRequestFailed
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_notConnectedError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Could not find a connection",
                                                       NSLocalizedFailureReasonErrorKey: @"The SDL library could not find a current connection to an SDL hardware device"
                                                       };

    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_notReadyError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Lifecycle manager not ready",
                                                       NSLocalizedFailureReasonErrorKey: @"The SDL library is not finished setting up the connection, please wait until the lifecycleState is SDLLifecycleStateReady"
                                                       };

    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_unknownRemoteErrorWithDescription:(nullable NSString *)description andReason:(nullable NSString *)reason {
    NSString *descriptionString = description ?: @"";
    NSString *reasonString = reason ?: @"";
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: descriptionString,
                                                       NSLocalizedFailureReasonErrorKey: reasonString
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

+ (NSError *)sdl_lifecycle_startedWithBadResult:(nullable SDLResult)result info:(nullable NSString *)info {
    NSString *resultString = result ?: @"";
    NSString *infoString = info ?: @"";
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: resultString,
                                                       NSLocalizedFailureReasonErrorKey: infoString
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorRegistrationFailed
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_startedWithWarning:(nullable SDLResult)result info:(nullable NSString *)info {
    NSString *resultString = result ?: @"";
    NSString *infoString = info ?: @"";
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: resultString,
                                                       NSLocalizedFailureReasonErrorKey: infoString
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorRegistrationSuccessWithWarning
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_failedWithBadResult:(nullable SDLResult)result info:(nullable NSString *)info {
    NSString *resultString = result ?: @"";
    NSString *infoString = info ?: @"";
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: resultString,
                                                       NSLocalizedFailureReasonErrorKey: infoString
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorRegistrationFailed
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_multipleRequestsCancelled {
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorCancelled
                           userInfo:nil];
}


#pragma mark SDLFileManager

+ (NSError *)sdl_fileManager_cannotOverwriteError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Cannot overwrite remote file",
                                                       NSLocalizedFailureReasonErrorKey: @"The remote file system already has a file of this name, and the file manager is set to not automatically overwrite files",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Set SDLFileManager autoOverwrite to YES, or call forceUploadFile:completion:"
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorCannotOverwrite userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_noKnownFileError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"No such remote file is currently known",
                                                       NSLocalizedFailureReasonErrorKey: @"The remote file is not currently known by the file manager. It could be that this file does not exist on the remote system or that the file manager has not completed its initialization and received a list of files from the remote system.",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure a file with this name is present on the remote system and that the file manager has finished its initialization."
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorNoKnownFile userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_unableToStartError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"The file manager was unable to start",
                                                       NSLocalizedFailureReasonErrorKey: @"This may be because files are not supported on this unit and / or LISTFILES returned an error",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure that the system is sending back a proper LIST FILES response"
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorUnableToStart userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_unableToUploadError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"The file manager was unable to send this file",
                                                       NSLocalizedFailureReasonErrorKey: @"This could be because the file manager has not started, or the head unit does not support files",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure that the system is sending back a proper LIST FILES response and check the file manager's state"
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorUnableToUpload userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_unableToUpload_ErrorWithUserInfo:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerMultipleFileUploadTasksFailed userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_unableToDelete_ErrorWithUserInfo:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerMultipleFileDeleteTasksFailed userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_fileUploadCanceled {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"The file upload was canceled",
                                                       NSLocalizedFailureReasonErrorKey: @"The file upload transaction was canceled before it could be completed",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"The file upload was canceled"
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerUploadCanceled userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_dataMissingError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"The file upload was canceled",
                                                       NSLocalizedFailureReasonErrorKey: @"The data for the file is missing",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure the data used to create the file is valid"
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorFileDataMissing userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_staticIconError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"The file upload was canceled",
                                                       NSLocalizedFailureReasonErrorKey: @"The file is a static icon, which cannot be uploaded",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Stop trying to upload a static icon, set it via the screen manager or create an SDLImage instead"
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorStaticIcon userInfo:userInfo];
}

#pragma mark SDLUploadFileOperation

+ (NSError *)sdl_fileManager_fileDoesNotExistError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"The file manager was unable to send the file",
                                                       NSLocalizedFailureReasonErrorKey: @"This could be because the file does not exist at the specified file path or that passed data is invalid",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure that the the correct file path is being set and that the passed data is valid"
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorFileDoesNotExist userInfo:userInfo];
}

#pragma mark Screen Managers

+ (NSError *)sdl_textAndGraphicManager_pendingUpdateSuperseded {
    return [NSError errorWithDomain:SDLErrorDomainTextAndGraphicManager code:SDLTextAndGraphicManagerErrorPendingUpdateSuperseded userInfo:nil];
}

+ (NSError *)sdl_softButtonManager_pendingUpdateSuperseded {
    return [NSError errorWithDomain:SDLErrorDomainSoftButtonManager code:SDLSoftButtonManagerErrorPendingUpdateSuperseded userInfo:nil];
}

+ (NSError *)sdl_subscribeButtonManager_notSubscribed {
    NSDictionary<NSString *, NSString *> *userInfo = @{
        NSLocalizedDescriptionKey: @"Subscribe Button Manager error",
        NSLocalizedFailureReasonErrorKey: @"The subscribe button manager has not yet subscribed to the button being unsubscribed.",
        NSLocalizedRecoverySuggestionErrorKey: @"Make sure you have used the Subscribe Button Manager to subscribe to the button name that you are attempting to unsubscribe."
    };
    return [NSError errorWithDomain:SDLErrorDomainSubscribeButtonManager code:SDLSubscribeButtonManagerErrorNotSubscribed userInfo:userInfo];
}

#pragma mark Menu Manager

+ (NSError *)sdl_menuManager_failedToUpdateWithDictionary:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:SDLErrorDomainMenuManager code:SDLMenuManagerErrorRPCsFailed userInfo:userInfo];
}

#pragma mark Choice Set Manager

+ (NSError *)sdl_choiceSetManager_choicesDeletedBeforePresentation:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorPendingPresentationDeleted userInfo:userInfo];
}

+ (NSError *)sdl_choiceSetManager_choiceDeletionFailed:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorDeletionFailed userInfo:userInfo];
}

+ (NSError *)sdl_choiceSetManager_choiceUploadFailed:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorUploadFailed userInfo:userInfo];
}

+ (NSError *)sdl_choiceSetManager_failedToCreateMenuItems {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Choice Set Manager error",
                                                       NSLocalizedFailureReasonErrorKey: @"Choice set manager failed to create menu items due to menuName being empty.",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"If you are setting the menuName, it is possible that the head unit is sending incorrect displayCapabilities."
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorFailedToCreateMenuItems userInfo:userInfo];
}

+ (NSError *)sdl_choiceSetManager_incorrectState:(SDLChoiceManagerState *)state {
    NSString *errorString = [NSString stringWithFormat:@"Choice Set Manager error invalid state: %@", state];
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: errorString,
                                                       NSLocalizedFailureReasonErrorKey: @"The choice set manager could be in an invalid state because the head unit doesn't support choice sets or the manager failed to set up correctly.",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"If you are setting the menuName, it is possible that the head unit is sending incorrect displayCapabilities."
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorInvalidState userInfo:userInfo];
}

#pragma mark System Capability Manager

+ (NSError *)sdl_systemCapabilityManager_moduleDoesNotSupportSystemCapabilities {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Module does not understand system capabilities",
                                                       NSLocalizedFailureReasonErrorKey: @"The connected module does not support system capabilities",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Use isCapabilitySupported to find out if the feature is supported on the head unit, but no more information about the feature is available on this module"
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainSystemCapabilityManager code:SDLSystemCapabilityManagerErrorModuleDoesNotSupportSystemCapabilities userInfo:userInfo];
}

+ (NSError *)sdl_systemCapabilityManager_cannotUpdateInHMINONE {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"System capabilities cannot be updated in HMI NONE.",
                                                       NSLocalizedFailureReasonErrorKey: @"The system capability manager attempted to subscribe or update a system capability in HMI NONE, which is not allowed.",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Wait until you are in HMI BACKGROUND, LIMITED, OR FULL before subscribing or updating a capability."
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainSystemCapabilityManager code:SDLSystemCapabilityManagerErrorHMINone userInfo:userInfo];
}

+ (NSError *)sdl_systemCapabilityManager_cannotUpdateTypeDISPLAYS {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"System capability type DISPLAYS cannot be updated.",
                                                       NSLocalizedFailureReasonErrorKey: @"The system capability manager attempted to update system capability type DISPLAYS, which is not allowed.",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Subscribe to DISPLAYS to automatically receive updates or retrieve a cached display capability value directly from the SystemCapabilityManager."
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainSystemCapabilityManager code:SDLSystemCapabilityManagerErrorCannotUpdateTypeDisplays userInfo:userInfo];
}

#pragma mark Transport

+ (NSError *)sdl_transport_unknownError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"TCP connection error",
                                                       NSLocalizedFailureReasonErrorKey: @"TCP connection cannot be established due to unknown error.",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure that correct IP address and TCP port number are specified, and the phone is connected to the correct Wi-Fi network."
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainTransport code:SDLTransportErrorUnknown userInfo:userInfo];
}

+ (NSError *)sdl_transport_connectionRefusedError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"TCP connection cannot be established",
                                                       NSLocalizedFailureReasonErrorKey: @"The TCP connection is refused by head unit. Possible causes are that the specified TCP port number is not correct, or SDL Core is not running properly on the head unit.",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure that correct IP address and TCP port number are specified. Also, make sure that SDL Core on the head unit enables TCP transport."
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainTransport code:SDLTransportErrorConnectionRefused userInfo:userInfo];
}

+ (NSError *)sdl_transport_connectionTimedOutError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"TCP connection timed out",
                                                       NSLocalizedFailureReasonErrorKey: @"The TCP connection cannot be established within a given time. Possible causes are that the specified IP address is not correct, or the connection is blocked by a firewall.",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure that correct IP address and TCP port number are specified. Also, make sure that the head unit's system configuration accepts TCP connections."
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainTransport code:SDLTransportErrorConnectionTimedOut userInfo:userInfo];
}

+ (NSError *)sdl_transport_networkDownError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Network is not available",
                                                       NSLocalizedFailureReasonErrorKey: @"TCP connection cannot be established because the phone is not connected to the network. Possible causes are: Wi-Fi being disabled on the phone or the phone is connected to a wrong Wi-Fi network.",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure that the phone is connected to the Wi-Fi network that has the head unit on it. Also, make sure that correct IP address and TCP port number are specified."
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainTransport code:SDLTransportErrorNetworkDown userInfo:userInfo];
}

#pragma mark Store

+ (NSError *)sdl_rpcStore_invalidObjectErrorWithObject:(id)wrongObject expectedType:(Class)type {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Type of stored value doesn't match with requested",
                                                       NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"Requested %@ but returned %@", NSStringFromClass(type), NSStringFromClass([wrongObject class])],
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Check the object type returned from the head unit system"
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainRPCStore code:SDLRPCStoreErrorGetInvalidObject userInfo:userInfo];
}

#pragma mark Cache File Manager

+ (NSError *)sdl_cacheFileManager_updateIconArchiveFileFailed {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Failed to update the icon archive file",
                                                       NSLocalizedFailureReasonErrorKey: @"Unable to archive icon archive file to file path",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Make sure that file path is valid"
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainCacheFileManager code:SDLCacheManagerErrorUpdateIconArchiveFileFailure userInfo:userInfo];
}

#pragma mark Audio Stream Manager
+ (NSError *)sdl_audioStreamManager_notConnected {
    NSDictionary<NSString *, NSString *> *userInfo = @{
        NSLocalizedDescriptionKey: @"Couldn't send audio data, the audio service is not connected",
        NSLocalizedFailureReasonErrorKey: @"The audio service must be connected before sending audio data",
        NSLocalizedRecoverySuggestionErrorKey: @"Make sure that a connection has been established, you are a NAVIGATION app and have the NAVIGATION app type in your configuration, and you are the active NAVIGATION app"
    };

    return [NSError errorWithDomain:SDLErrorDomainAudioStreamManager code:SDLAudioStreamManagerErrorNotConnected userInfo:userInfo];
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

+ (NSException *)sdl_missingFilesException {
    return [NSException
            exceptionWithName:@"MissingFilesNames"
            reason:@"This request requires that the array of files not be empty"
            userInfo:nil];
}

+ (NSException *)sdl_invalidSoftButtonStateException {
    return [NSException exceptionWithName:@"InvalidSoftButtonState" reason:@"Attempting to transition to a state that does not exist" userInfo:nil];
}

+ (NSException *)sdl_carWindowOrientationException {
    return [NSException exceptionWithName:@"com.sdl.carwindow.orientationException"
                                   reason:@"SDLCarWindow rootViewController must support only a single interface orientation"
                                 userInfo:nil];
}

+ (NSException *)sdl_invalidLockscreenSetupException {
    return [NSException exceptionWithName:@"com.sdl.lockscreen.setupException"
                                   reason:@"SDL must be setup _after_ your app's window already exists"
                                 userInfo:nil];
}

+ (NSException *)sdl_invalidSystemCapabilitySelectorExceptionWithSelector:(SEL)selector {
    return [NSException exceptionWithName:@"com.sdl.systemCapabilityManager.selectorException"
                                   reason:[NSString stringWithFormat:@"Capability observation selector: %@ does not match possible selectors, which must have between 0 and 3 parameters, or is not a selector on the observer object. Check that your selector is formatted correctly, and that your observer is not nil. You should unsubscribe an observer before it goes to nil.", NSStringFromSelector(selector)]
                                 userInfo:nil];
}

+ (NSException *)sdl_invalidSubscribeButtonSelectorExceptionWithSelector:(SEL)selector {
    return [NSException exceptionWithName:@"com.sdl.subscribeButtonManager.selectorException"
                                   reason:[NSString stringWithFormat:@"Subscribe button observation selector: %@ does not match possible selectors, which must have between 0 and 4 parameters, or is not a selector on the observer object. Check that your selector is formatted correctly, and that your observer is not nil. You should unsubscribe an observer before it goes to nil.", NSStringFromSelector(selector)]
                                 userInfo:nil];
}

@end

NS_ASSUME_NONNULL_END
