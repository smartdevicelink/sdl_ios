//
//  SDLErrorConstants.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/5/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLError.h"

#import "SDLChoiceSetManager.h"
#import "SDLMenuConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@implementation NSError (SDLErrors)

+ (NSError *)sdl_failedToCreateObjectOfClass:(Class)objectClass {
    return [NSError errorWithDomain:SDLErrorDomainSystem code:SDLSystemErrorFailedToCreateObject userInfo:@{
        NSLocalizedDescriptionKey: [NSString stringWithFormat: @"iOS system failed to create a new object of class: %@", objectClass],
        NSLocalizedFailureReasonErrorKey: @"An unknown error caused iOS to fail to create an object",
        NSLocalizedRecoverySuggestionErrorKey: @"There is no known way to fix this error"
    }];
}

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

+ (NSError *)sdl_encryption_unknown {
    NSDictionary<NSString *, NSString *> *userInfo = @{
                                                       NSLocalizedDescriptionKey: @"Encryption received an unknown error",
                                                       NSLocalizedFailureReasonErrorKey: @"We don't know the reason for the failure",
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Ensure that encryption is properly set up"
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
                                                       NSLocalizedRecoverySuggestionErrorKey: @"Set file.overwrite to true to overwrite the file"
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
    return [NSError errorWithDomain:SDLErrorDomainTextAndGraphicManager code:SDLTextAndGraphicManagerErrorPendingUpdateSuperseded userInfo:@{
        NSLocalizedDescriptionKey: @"The screen manager didn't complete this update because a newer update was requested. Any remaining pieces of this update that were not overridden by the new update will complete in that update."
    }];
}

+ (NSError *)sdl_softButtonManager_pendingUpdateSuperseded {
    return [NSError errorWithDomain:SDLErrorDomainSoftButtonManager code:SDLSoftButtonManagerErrorPendingUpdateSuperseded userInfo:@{
        NSLocalizedDescriptionKey: @"The screen manager didn't complete this update because a newer update was requested. Any remaining pieces of this update that were not overridden by the new update will complete in that update."
    }];
}

+ (NSError *)sdl_subscribeButtonManager_notSubscribed {
    NSDictionary<NSString *, NSString *> *userInfo = @{
        NSLocalizedDescriptionKey: @"Subscribe Button Manager error",
        NSLocalizedFailureReasonErrorKey: @"The subscribe button manager has not yet subscribed to the button being unsubscribed.",
        NSLocalizedRecoverySuggestionErrorKey: @"Make sure you have used the Subscribe Button Manager to subscribe to the button name that you are attempting to unsubscribe."
    };
    return [NSError errorWithDomain:SDLErrorDomainSubscribeButtonManager code:SDLSubscribeButtonManagerErrorNotSubscribed userInfo:userInfo];
}

+ (NSError *)sdl_textAndGraphicManager_batchingUpdate {
    return [NSError errorWithDomain:SDLErrorDomainTextAndGraphicManager code:SDLTextAndGraphicManagerErrorCurrentlyBatching userInfo:@{
        NSLocalizedDescriptionKey: @"Update will not run because batching is enabled",
        NSLocalizedFailureReasonErrorKey: @"Text and Graphic manager will not run this update and call this handler because its currently batching updates. The update will occur when batching ends.",
        NSLocalizedRecoverySuggestionErrorKey: @"This callback shouldn't occur. Please open an issue on https://www.github.com/smartdevicelink/sdl_ios/ if it does"
    }];
}

+ (NSError *)sdl_textAndGraphicManager_nothingToUpdate {
    return [NSError errorWithDomain:SDLErrorDomainTextAndGraphicManager code:SDLTextAndGraphicManagerErrorNothingToUpdate userInfo:@{
        NSLocalizedDescriptionKey: @"Update will not run because there's nothing to update",
        NSLocalizedFailureReasonErrorKey: @"This callback shouldn't occur, so there's no known reason for this failure.",
        NSLocalizedRecoverySuggestionErrorKey: @"This callback shouldn't occur. Please open an issue on https://www.github.com/smartdevicelink/sdl_ios/ if it does"
    }];
}

#pragma mark Menu Manager

+ (NSError *)sdl_menuManager_configurationOperationLayoutsNotSupported {
    return [NSError errorWithDomain:SDLErrorDomainMenuManager code:SDLMenuManagerErrorConfigurationUpdateLayoutNotSupported userInfo:@{
        NSLocalizedDescriptionKey: @"Menu Manager - Configuration Update Failed",
        NSLocalizedFailureReasonErrorKey: @"One or more of the configuration layouts is not supported by the module",
        NSLocalizedRecoverySuggestionErrorKey: @"Compare SDLManager.systemCapabilityManager.defaultWindowCapability.menuLayoutsAvailable to what you attempted to set"
    }];
}

+ (NSError *)sdl_menuManager_configurationOperationFailed:(SDLMenuConfiguration *)failedConfiguration {
    return [NSError errorWithDomain:SDLErrorDomainMenuManager code:SDLMenuManagerErrorConfigurationUpdateFailed userInfo:@{
        @"Failed Configuration": failedConfiguration,
        NSLocalizedDescriptionKey: @"Menu Manager - Configuration Update Failed",
        NSLocalizedFailureReasonErrorKey: @"The configuration may not be supported by the connected head unit",
        NSLocalizedRecoverySuggestionErrorKey: @"Check SystemCapabilityManager.defaultWindowCapability.menuLayouts to ensure the set configuration is supported"
    }];
}

+ (NSError *)sdl_menuManager_openMenuOperationCancelled {
    return [NSError errorWithDomain:SDLErrorDomainMenuManager code:SDLMenuManagerErrorOperationCancelled userInfo:@{
        NSLocalizedDescriptionKey: @"Menu Manager - Open Menu Cancelled",
        NSLocalizedFailureReasonErrorKey: @"The menu manager was probably stopped or opening another menu item was requested.",
        NSLocalizedRecoverySuggestionErrorKey: @"This error probably does not need recovery."
    }];
}

+ (NSError *)sdl_menuManager_openMenuOperationFailed:(nullable SDLMenuCell *)menuCell {
    NSString *failureReason = nil;
    if (menuCell != nil) {
        failureReason = @"Something went wrong attempting to open the menu.";
    } else {
        failureReason = [NSString stringWithFormat:@"Something went wrong attempting to open the menu to the given subcell: %@", menuCell];
    }

    return [NSError errorWithDomain:SDLErrorDomainMenuManager code:SDLMenuManagerErrorOpenMenuFailed userInfo:@{
        NSLocalizedDescriptionKey: @"Menu Manager - Open Menu Failed",
        NSLocalizedFailureReasonErrorKey: failureReason,
        NSLocalizedRecoverySuggestionErrorKey: @"Check the error logs for more information on the RPC failure."
    }];
}

+ (NSError *)sdl_menuManager_replaceOperationCancelled {
    return [NSError errorWithDomain:SDLErrorDomainMenuManager code:SDLMenuManagerErrorOperationCancelled userInfo:@{
        NSLocalizedDescriptionKey: @"Menu Manager - Menu Replace Cancelled",
        NSLocalizedFailureReasonErrorKey: @"The menu manager was probably stopped or another menu update was requested.",
        NSLocalizedRecoverySuggestionErrorKey: @"This error probably does not need recovery."
    }];
}

+ (NSError *)sdl_menuManager_failedToUpdateWithDictionary:(NSDictionary *)userInfo {
    return [NSError errorWithDomain:SDLErrorDomainMenuManager code:SDLMenuManagerErrorRPCsFailed userInfo:userInfo];
}

+ (NSError *)sdl_voiceCommandManager_pendingUpdateSuperseded {
    return [NSError errorWithDomain:SDLErrorDomainMenuManager code:SDLMenuManagerErrorPendingUpdateSuperseded userInfo:@{
        NSLocalizedDescriptionKey: @"Voice Command Manager error",
        NSLocalizedFailureReasonErrorKey: @"Voice command operation was cancelled because it was superseded by another update"
    }];
}

#pragma mark Choice Set Manager

+ (NSError *)sdl_choiceSetManager_choicesNotAvailableForPresentation:(NSSet<SDLChoiceCell *> *)neededCells availableCells:(NSSet<SDLChoiceCell *> *)availableCells {

    return [NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorNeededChoicesUnavailable userInfo:@{
        NSLocalizedDescriptionKey: @"Choice Set Manager error",
        NSLocalizedFailureReasonErrorKey: @"Not all needed choices for presentation are available on the head unit. See key 'neededChoices' and 'availableChoices'",
        NSLocalizedRecoverySuggestionErrorKey: @"Choices may have been deleted or were not all properly uploaded for presentation. You can attempt the presentation again to retry the upload.",
        @"neededChoices": neededCells.description,
        @"availableChoices": availableCells.description
    }];
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

+ (NSError *)sdl_choiceSetManager_cancelled {
    return [NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorCancelled userInfo:@{
        NSLocalizedDescriptionKey: @"Choice set operation error cancelled",
        NSLocalizedFailureReasonErrorKey: @"The choice operation was cancelled and may or may not have completed",
        NSLocalizedRecoverySuggestionErrorKey: @"It may have been cancelled due to shutdown, or it may have been cancelled by the developer"
    }];
}

+ (NSError *)sdl_choiceSetManager_noIdsAvailable {
    return [NSError errorWithDomain:SDLErrorDomainChoiceSetManager code:SDLChoiceSetManagerErrorNoIdsAvailable userInfo:@{
        NSLocalizedDescriptionKey: @"Choice set operation failed because the maximum number of choices have been uploaded (65535)",
        NSLocalizedFailureReasonErrorKey: @"65535 unique choices have been uploaded to the head unit in this session and no more are allowed",
        NSLocalizedRecoverySuggestionErrorKey: @"Re-use or delete choices to free up space"
    }];
}

#pragma mark Alert Manager

+ (NSError *)sdl_alertManager_presentationFailedWithError:(NSError *)error tryAgainTime:(int)tryAgainTime {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: @"The alert presentation failed",
        NSLocalizedFailureReasonErrorKey: @"Either the alert failed to present on the module or it was dismissed early after being shown",
        NSLocalizedRecoverySuggestionErrorKey: @"Please check the \"error\" key and the \"tryAgainTime\" keys for more information",
        @"tryAgainTime": @(tryAgainTime),
        @"error": error
    };
    return [NSError errorWithDomain:SDLErrorDomainAlertManager code:SDLAlertManagerPresentationError userInfo:userInfo];
}

+ (NSError *)sdl_alertManager_alertDataInvalid {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: @"The alert data is invalid",
        NSLocalizedFailureReasonErrorKey: @"At least either text, secondaryText or audio needs to be provided",
        NSLocalizedRecoverySuggestionErrorKey: @"Make sure to set at least the text, secondaryText or audio properties on the SDLAlertView"
    };
    return [NSError errorWithDomain:SDLErrorDomainAlertManager code:SDLAlertManagerInvalidDataError userInfo:userInfo];
}

+ (NSError *)sdl_alertManager_alertAudioFileNotSupported {
    NSDictionary *userInfo = @{
        NSLocalizedDescriptionKey: @"The module does not support the use of only audio file data in an alert",
        NSLocalizedFailureReasonErrorKey: @"The alert has no data and can not be sent to the module",
        NSLocalizedRecoverySuggestionErrorKey: @"The use of audio file data in an alert is only supported on modules supporting RPC Spec v5.0 or newer"
    };
    return [NSError errorWithDomain:SDLErrorDomainAlertManager code:SDLAlertManagerInvalidDataError userInfo:userInfo];
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

+ (NSError *)sdl_systemCapabilityManager_unknownSystemCapabilityType {
    return [NSError errorWithDomain:SDLErrorDomainSystemCapabilityManager code:SDLSystemCapabilityManagerErrorUnknownType userInfo:@{
        NSLocalizedDescriptionKey: @"An unknown system capability type was received.",
        NSLocalizedFailureReasonErrorKey: @"Failure reason unknown. If you see this, please open an issue on https://www.github.com/smartdevicelink/sdl_ios/",
        NSLocalizedRecoverySuggestionErrorKey: @"Ensure you are only attempting to manually subscribe to known system capability types for the version of this library. You may also want to update this library to its latest version."
    }];
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

+ (NSException *)sdl_duplicateSoftButtonsNameException {
    return [NSException exceptionWithName:@"InvalidSoftButtonsInitialization" reason:@"Attempting to create soft buttons with the same name" userInfo:nil];
}

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

+ (NSException *)sdl_invalidTTSSpeechCapabilitiesException {
    return [NSException exceptionWithName:@"InvalidTTSSpeechCapabilities" reason:@"Attempting to create a text-to-speech string with an invalid phonetic type. The phoneticType must be of type `SAPI_PHONEMES`, `LHPLUS_PHONEMES`, `TEXT`, or `PRE_RECORDED`." userInfo:nil];
}

+ (NSException *)sdl_invalidAlertSoftButtonStatesException {
    return [NSException exceptionWithName:@"InvalidSoftButtonStates" reason:@"Attempting to create a soft button for an Alert with more than one state. Alerts only support soft buttons with one state" userInfo:nil];
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

+ (NSException *)sdl_invalidVideoStreamingRange {
    return [NSException exceptionWithName:@"com.sdl.videostreamingrange.rangeException"
                                   reason:[NSString stringWithFormat:@"A video streaming resolution range was created with an invalid range. The minimum was probably greater than the maximum."]
                                 userInfo:nil];
}

@end

NS_ASSUME_NONNULL_END
