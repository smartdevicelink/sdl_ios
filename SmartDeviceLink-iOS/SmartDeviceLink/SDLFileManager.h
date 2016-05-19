//
//  SDLFileManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLConnectionManagerType.h"
#import "SDLFileManagerConstants.h"

@class SDLFile;


NS_ASSUME_NONNULL_BEGIN

extern NSString *const SDLFileManagerStateShutdown;
extern NSString *const SDLFileManagerStateFetchingInitialList;
extern NSString *const SDLFileManagerStateReady;


typedef NSString SDLFileName;

typedef void (^SDLFileManagerStartupCompletion)(BOOL success, NSError *__nullable error);


@interface SDLFileManager : NSObject

@property (copy, nonatomic, readonly) NSSet<SDLFileName *> *remoteFileNames;
@property (assign, nonatomic, readonly) NSUInteger bytesAvailable;
@property (copy, nonatomic, readonly) NSString *currentState;
@property (assign, nonatomic, readonly) NSUInteger pendingTransactionsCount;

@property (assign, nonatomic) BOOL allowOverwrite;


- (instancetype)init __unavailable;

/**
 *  Creates a new file manager with a specified connection manager
 *
 *  @param manager A connection manager to use to forward on RPCs
 *
 *  @return An instance of SDLFileManager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager NS_DESIGNATED_INITIALIZER;

/**
 *  The manager stars up and attempts to fetch its initial list and transfer initial files.
 *
 *  @param completionHandler The handler called when the manager is set up or failed to set up with an error. Use weak self when accessing self from the completion handler.
 */
- (void)startManagerWithCompletionHandler:(SDLFileManagerStartupCompletion)completionHandler;

/**
 *  Cancels all file manager operations and deletes all associated data.
 */
- (void)stop;

/**
 *  Delete a file stored on the remote system
 *
 *  @param name       The name of the remote file. It should be a name currently stored in remoteFileNames
 *  @param completion An optional completion handler that sends an error should one occur.
 */
- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(nullable SDLFileManagerDeleteCompletion)completion;

/**
 *  Upload a file to the remote file system. If a file with the [SDLFile name] already exists, this will overwrite that file. If you do not want that to happen, check remoteFileNames before uploading, or change allowOverwrite to NO.
 *
 *  @param file       An SDLFile that contains metadata about the file to be sent
 *  @param completion An optional completion handler that sends an error should one occur.
 */
- (void)uploadFile:(SDLFile *)file completionHandler:(nullable SDLFileManagerUploadCompletion)completion;

/**
 *  Upload a file to the remote file system. If a file with the [SDLFile name] already exists, and allowOverwrite is NO, this method will still overwrite the file.
 *
 *  @param file       An SDLFile that contains metadata about the file to be sent
 *  @param completion An optional completion handler that sends an error should one occur.
 */
- (void)forceUploadFile:(SDLFile *)file completionHandler:(nullable SDLFileManagerUploadCompletion)completion;

/**
 *  A URL to the directory where temporary files are stored. When an SDLFile is created with NSData, it writes to a temporary file until the file manager finishes uploading it.
 *
 *  The SDL library manages the creation and deletion of these files and you should not have to touch this directory at all.
 *
 *  @return An NSURL pointing to the location on disk where SDL's temporary files are stored.
 */
+ (NSURL *)temporaryFileDirectory;

@end

NS_ASSUME_NONNULL_END
