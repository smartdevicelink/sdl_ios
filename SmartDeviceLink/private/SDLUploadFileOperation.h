//
//  SDLUploadFileOperation.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"
#import "SDLFileManagerConstants.h"

@protocol SDLConnectionManagerType;
@class SDLFileManager;
@class SDLFileWrapper;


NS_ASSUME_NONNULL_BEGIN


@interface SDLUploadFileOperation : SDLAsynchronousOperation

/**
 * Create an instance of an upload files operation which will send a file to a remote system when added to an operation queue.
 *
 * @param file A file wrapper around the file which will be sent and a completion handler for when the file finishes sending.
 * @param connectionManager The connection manager which will handle transporting the file bytes to the remote system
 * @param fileManager The file manager, used to check if the file is uploaded
 *
 * @return An instance of SDLUploadFilesOperation
 */
- (instancetype)initWithFile:(SDLFileWrapper *)file connectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager;

@property (nonatomic, strong, readonly) SDLFileWrapper *fileWrapper;
@property (nonatomic, weak) SDLFileManager *fileManager;

@end

NS_ASSUME_NONNULL_END
