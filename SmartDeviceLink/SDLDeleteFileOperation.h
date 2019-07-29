//
//  SDLDeleteFileOperation.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"
#import "SDLFileManagerConstants.h"

@protocol SDLConnectionManagerType;


NS_ASSUME_NONNULL_BEGIN

@interface SDLDeleteFileOperation : SDLAsynchronousOperation

/**
 *  Create an instance of a delete files operation which will tell the remote system to remove a file form its storage.
 *
 *  @param fileName The name of the file to be deleted on the remote system.
 *  @param connectionManager The connection manager which will handle transporting the request to the remote system.
 *  @param completionHandler A completion handler to be called when the delete finishes.
 *
 *  @return An instance of SDLDeleteFilesOperation
 */
- (instancetype)initWithFileName:(NSString *)fileName connectionManager:(id<SDLConnectionManagerType>)connectionManager completionHandler:(nullable SDLFileManagerDeleteCompletionHandler)completionHandler;

/**
 The name of the file to be deleted on the remote system.
 */
@property (copy, nonatomic, readonly) NSString *fileName;

/**
 The connection manager which will handle transporting the request to the remote system.
 */
@property (weak, nonatomic, readonly) id<SDLConnectionManagerType> connectionManager;

/**
 A completion handler to be called when the delete finishes.
 */
@property (copy, nonatomic, nullable, readonly) SDLFileManagerDeleteCompletionHandler completionHandler;

@end

NS_ASSUME_NONNULL_END
