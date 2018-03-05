//
//  SDLErrorConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/8/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Errors associated with the SDLManager class.
 */
typedef NS_ENUM(NSInteger, SDLManagerError) {
    /**
     *  An RPC request failed to send.
     */
    SDLManagerErrorRPCRequestFailed = -1,
    /**
     *  Some action was attempted that requires a connection to the remote head unit.
     */
    SDLManagerErrorNotConnected = -2,
    /**
     *  Some action was attempted before the ready state was reached.
     */
    SDLManagerErrorNotReady = -3,
    /**
     *  The remote system encountered an unknown error.
     */
    SDLManagerErrorUnknownRemoteError = -4,
    /**
     *  One or more of the sub-managers failed to start.
     */
    SDLManagerErrorManagersFailedToStart = -5,
    /**
     *  Registering with the remote system failed.
     */
    SDLManagerErrorRegistrationFailed = -6,
    /**
     *  Registering with the remote system was successful, but had a warning.
     */
    SDLManagerErrorRegistrationSuccessWithWarning = -7,
    /**
     *  Request operations were cancelled before they could be sent
     */
    SDLManagerErrorCancelled = -8
};

/**
 *  Errors associated with the SDLFileManager class.
 */
typedef NS_ENUM(NSInteger, SDLFileManagerError) {
    /**
     *  A file attempted to send, but a file with that name already exists on the remote head unit, and the file was not configured to overwrite.
     */
    SDLFileManagerErrorCannotOverwrite = -1,
    /**
     *  A file was attempted to be accessed but it does not exist.
     */
    SDLFileManagerErrorNoKnownFile = -2,
    /**
     *  The file manager attempted to start but encountered an error.
     */
    SDLFileManagerErrorUnableToStart = -3,
    /**
     *  The file manager was unable to send this file.
     */
    SDLFileManagerErrorUnableToUpload = -4,
    /**
     *  The file manager could not find the local file.
     */
    SDLFileManagerErrorFileDoesNotExist = -5,
    /*
     *  The file upload was canceled.
     */
    SDLFileManagerUploadCanceled = -6,
    /*
     *  One or more of multiple files being uploaded or deleted failed.
     */
    SDLFileManagerMultipleFileUploadTasksFailed = -7,
    /*
     *  One or more of multiple files being uploaded or deleted failed.
     */
    SDLFileManagerMultipleFileDeleteTasksFailed = -8,
    /*
     *  The file data is nil or empty.
     */
    SDLFileManagerErrorFileDataMissing = -9,
};

typedef NS_ENUM(NSInteger, SDLTextAndGraphicManagerError) {
    SDLTextAndGraphicManagerErrorPendingUpdateSuperseded = -1
};

typedef NS_ENUM(NSInteger, SDLSoftButtonManagerError) {
    SDLSoftButtonManagerErrorPendingUpdateSuperseded = -1
};
