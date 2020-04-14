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
SDLErrorDomain *const SDLErrorDomainMenuManager = @"com.sdl.menumanager.error";
SDLErrorDomain *const SDLErrorDomainChoiceSetManager = @"com.sdl.choicesetmanager.error";
SDLErrorDomain *const SDLErrorDomainSystemCapabilityManager = @"com.sdl.systemcapabilitymanager.error";
SDLErrorDomain *const SDLErrorDomainTransport = @"com.sdl.transport.error";
SDLErrorDomain *const SDLErrorDomainRPCStore = @"com.sdl.rpcStore.error";
SDLErrorDomain *const SDLErrorDomainCacheFileManager = @"com.sdl.cachefilemanager.error";

@implementation NSError (SDLErrors)

#pragma mark - SDLEncryptionLifecycleManager
+ (NSError *)sdl_encryption_lifecycle_notReadyError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Encryption Lifecycle manager not ready", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The SDL library is not finished setting up the connection, please wait until the encryption lifecycleState is SDLEncryptionLifecycleStateReady", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure HMI is not NONE and at least one RPC requires encryption in permissions?", nil)
                                                       };
    
    return [NSError errorWithDomain:SDLErrorDomainEncryptionLifecycleManager
                               code:SDLEncryptionLifecycleManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_encryption_lifecycle_encryption_off {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Encryption Lifecycle received a ACK with encryption bit = 0", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The SDL library received ACK with encryption = OFF.", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure you are on a supported remote head unit with proper policies and your app id is approved.", nil)
                                                       };
    
    return [NSError errorWithDomain:SDLErrorDomainEncryptionLifecycleManager
                               code:SDLEncryptionLifecycleManagerErrorEncryptionOff
                           userInfo:userInfo];
}

+ (NSError *)sdl_encryption_lifecycle_nak {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Encryption Lifecycle received a negative acknowledgement", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The remote head unit sent a NAK.  Encryption service failed to start due to NAK.", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure your certificates are valid.", nil)
                                                       };
    
    return [NSError errorWithDomain:SDLErrorDomainEncryptionLifecycleManager
                               code:SDLEncryptionLifecycleManagerErrorNAK
                           userInfo:userInfo];

}

#pragma mark - SDLManager

+ (NSError *)sdl_lifecycle_rpcErrorWithDescription:(NSString *)description andReason:(NSString *)reason {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorRPCRequestFailed
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_notConnectedError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Could not find a connection", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The SDL library could not find a current connection to an SDL hardware device", nil)
                                                       };

    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_notReadyError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Lifecycle manager not ready", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The SDL library is not finished setting up the connection, please wait until the lifecycleState is SDLLifecycleStateReady", nil)
                                                       };

    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorNotConnected
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_unknownRemoteErrorWithDescription:(NSString *)description andReason:(NSString *)reason {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil)
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

+ (NSError *)sdl_lifecycle_startedWithBadResult:(SDLResult)result info:(NSString *)info {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(result, nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(info, nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorRegistrationFailed
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_startedWithWarning:(SDLResult)result info:(NSString *)info {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(result, nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(info, nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainLifecycleManager
                               code:SDLManagerErrorRegistrationSuccessWithWarning
                           userInfo:userInfo];
}

+ (NSError *)sdl_lifecycle_failedWithBadResult:(SDLResult)result info:(NSString *)info {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(result, nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(info, nil)
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
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Cannot overwrite remote file", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The remote file system already has a file of this name, and the file manager is set to not automatically overwrite files", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Set SDLFileManager autoOverwrite to YES, or call forceUploadFile:completion:", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorCannotOverwrite userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_noKnownFileError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"No such remote file is currently known", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The remote file is not currently known by the file manager. It could be that this file does not exist on the remote system or that the file manager has not completed its initialization and received a list of files from the remote system.", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure a file with this name is present on the remote system and that the file manager has finished its initialization.", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorNoKnownFile userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_unableToStartError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"The file manager was unable to start", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"This may be because files are not supported on this unit and / or LISTFILES returned an error", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that the system is sending back a proper LIST FILES response", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorUnableToStart userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_unableToUploadError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"The file manager was unable to send this file", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"This could be because the file manager has not started, or the head unit does not support files", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that the system is sending back a proper LIST FILES response and check the file manager's state", nil)
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
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"The file upload was canceled", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The file upload transaction was canceled before it could be completed", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"The file upload was canceled", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerUploadCanceled userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_dataMissingError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"The file upload was canceled", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The data for the file is missing", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure the data used to create the file is valid", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorFileDataMissing userInfo:userInfo];
}

+ (NSError *)sdl_fileManager_staticIconError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"The file upload was canceled", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The file is a static icon, which cannot be uploaded", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Stop trying to upload a static icon, set it via the screen manager or create an SDLImage instead", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainFileManager code:SDLFileManagerErrorStaticIcon userInfo:userInfo];
}

#pragma mark SDLUploadFileOperation

+ (NSError *)sdl_fileManager_fileDoesNotExistError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"The file manager was unable to send the file", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"This could be because the file does not exist at the specified file path or that passed data is invalid", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that the the correct file path is being set and that the passed data is valid", nil)
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
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Choice Set Manager error", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Choice set manager failed to create menu items due to menuName being empty.", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"If you are setting the menuName, it is possible that the head unit is sending incorrect displayCapabilities.", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorFailedToCreateMenuItems userInfo:userInfo];
}

+ (NSError *)sdl_choiceSetManager_incorrectState:(SDLChoiceManagerState *)state {
    NSString *errorString = [NSString stringWithFormat:@"Choice Set Manager error invalid state: %@", state];
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: errorString,
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The choice set manager could be in an invalid state because the head unit doesn't support choice sets or the manager failed to set up correctly.", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"If you are setting the menuName, it is possible that the head unit is sending incorrect displayCapabilities.", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorInvalidState userInfo:userInfo];
}

#pragma mark System Capability Manager

+ (NSError *)sdl_systemCapabilityManager_moduleDoesNotSupportSystemCapabilities {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Module does not understand system capabilities", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The connected module does not support system capabilities", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Use isCapabilitySupported to find out if the feature is supported on the head unit, but no more information about the feature is available on this module", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainSystemCapabilityManager code:SDLSystemCapabilityManagerErrorModuleDoesNotSupportSystemCapabilities userInfo:userInfo];
}

+ (NSError *)sdl_systemCapabilityManager_cannotUpdateInHMINONE {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"System capabilities cannot be updated in HMI NONE.", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The system capability manager attempted to subscribe or update a system capability in HMI NONE, which is not allowed.", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Wait until you are in HMI BACKGROUND, LIMITED, OR FULL before subscribing or updating a capability.", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainSystemCapabilityManager code:SDLSystemCapabilityManagerErrorHMINone userInfo:userInfo];
}

+ (NSError *)sdl_systemCapabilityManager_cannotUpdateTypeDISPLAYS {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"System capability type DISPLAYS cannot be updated.", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The system capability manager attempted to update system capability type DISPLAYS, which is not allowed.", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Subscribe to DISPLAYS to automatically receive updates or retrieve a cached display capability value directly from the SystemCapabilityManager.", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainSystemCapabilityManager code:SDLSystemCapabilityManagerErrorCannotUpdateTypeDisplays userInfo:userInfo];
}

#pragma mark Transport

+ (NSError *)sdl_transport_unknownError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"TCP connection error", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"TCP connection cannot be established due to unknown error.", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that correct IP address and TCP port number are specified, and the phone is connected to the correct Wi-Fi network.", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainTransport code:SDLTransportErrorUnknown userInfo:userInfo];
}

+ (NSError *)sdl_transport_connectionRefusedError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"TCP connection cannot be established", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The TCP connection is refused by head unit. Possible causes are that the specified TCP port number is not correct, or SDL Core is not running properly on the head unit.", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that correct IP address and TCP port number are specified. Also, make sure that SDL Core on the head unit enables TCP transport.", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainTransport code:SDLTransportErrorConnectionRefused userInfo:userInfo];
}

+ (NSError *)sdl_transport_connectionTimedOutError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"TCP connection timed out", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"The TCP connection cannot be established within a given time. Possible causes are that the specified IP address is not correct, or the connection is blocked by a firewall.", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that correct IP address and TCP port number are specified. Also, make sure that the head unit's system configuration accepts TCP connections.", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainTransport code:SDLTransportErrorConnectionTimedOut userInfo:userInfo];
}

+ (NSError *)sdl_transport_networkDownError {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Network is not available", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"TCP connection cannot be established because the phone is not connected to the network. Possible causes are: Wi-Fi being disabled on the phone or the phone is connected to a wrong Wi-Fi network.", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that the phone is connected to the Wi-Fi network that has the head unit on it. Also, make sure that correct IP address and TCP port number are specified.", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainTransport code:SDLTransportErrorNetworkDown userInfo:userInfo];
}

#pragma mark Store

+ (NSError *)sdl_rpcStore_invalidObjectErrorWithObject:(id)wrongObject expectedType:(Class)type {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Type of stored value doesn't match with requested", nil),
                                                       NSLocalizedFailureReasonErrorKey: [NSString stringWithFormat:@"Requested %@ but returned %@", NSStringFromClass(type), NSStringFromClass([wrongObject class])],
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Check the object type returned from the head unit system", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainRPCStore code:SDLRPCStoreErrorGetInvalidObject userInfo:userInfo];
}

#pragma mark Cache File Manager

+ (NSError *)sdl_cacheFileManager_updateIconArchiveFileFailed {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: NSLocalizedString(@"Cache File Manager error", nil),
                                                       NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"Unable to archive icon archive file to file path", nil),
                                                       NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(@"Make sure that file path is valid", nil)
                                                       };
    return [NSError errorWithDomain:SDLErrorDomainCacheFileManager code:SDLCacheManagerErrorUpdateIconArchiveFileFailure userInfo:userInfo];
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

+ (NSException *)sdl_invalidSelectorExceptionWithSelector:(SEL)selector {
    return [NSException exceptionWithName:@"com.sdl.systemCapabilityManager.selectorException"
                                   reason:[NSString stringWithFormat:@"Capability observation selector: %@ does not match possible selectors, which must have between 0 and 3 parameters, or is not a selector on the observer object. Check that your selector is formatted correctly, and that your observer is not nil. You should unsubscribe an observer before it goes to nil.", NSStringFromSelector(selector)]
                                 userInfo:nil];
}

@end

NS_ASSUME_NONNULL_END
