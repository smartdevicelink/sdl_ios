//
//  SDLListFilesOperation.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/25/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLAsynchronousOperation.h"
#import "SDLFileManagerConstants.h"

@protocol SDLConnectionManagerType;


NS_ASSUME_NONNULL_BEGIN

@interface SDLListFilesOperation : SDLAsynchronousOperation

/**
 *  Create an instance of a list files operation which will ask the remote system which files it has on its system already.
 *
 *  @param connectionManager The connection manager which will handle transporting the request to the remote system.
 *  @param completionHandler A completion handler for when the response returns.
 *
 *  @return An instance of SDLListFilesOperation
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager completionHandler:(nullable SDLFileManagerListFilesCompletionHandler)completionHandler;

/**
 The connection manager which will handle transporting the request to the remote system.
 */
@property (weak, nonatomic, readonly) id<SDLConnectionManagerType> connectionManager;

/**
 A completion handler for when the response returns.
 */
@property (copy, nonatomic, nullable, readonly) SDLFileManagerListFilesCompletionHandler completionHandler;

@end

NS_ASSUME_NONNULL_END
