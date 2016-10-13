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
     * The file manager attempted to start but encountered an error.
     */
    SDLFileManagerErrorUnableToStart = -3,
    /**
     * The file manager was unable to send this file.
     */
    SDLFileManagerErrorUnableToUpload = -4,
};
