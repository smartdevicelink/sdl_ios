//
//  SDLFileManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLFileManagerConstants.h"

@class SDLFile;
@protocol SDLConnectionManagerType;


NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLFileName;

typedef void (^SDLFileManagerStartupCompletionHandler)(BOOL success, NSError *__nullable error);


/**
 *  The SDLFileManager is an RPC manager for the remote file system. After it starts, it will attempt to communicate with the remote file system to get the names of all files. Deleting and Uploading will them queue these changes as transactions. If a delete succeeds, the local list of remote files will remove that file name, and likewise, if an upload succeeds, the local list of remote files will now include that file name.
 */
@interface SDLFileManager : NSObject

/**
 *  A set of all names of files known on the remote head unit. Known files can be used or deleted on the remote system.
 */
@property (copy, nonatomic, readonly) NSSet<SDLFileName *> *remoteFileNames;

/**
 *  The number of bytes still available for files for this app.
 */
@property (assign, nonatomic, readonly) NSUInteger bytesAvailable;

/**
 *  The state of the file manager.
 */
@property (copy, nonatomic, readonly) NSString *currentState;

/**
 *  The currently pending transactions (Upload, Delete, and List Files) in the file manager
 */
@property (copy, nonatomic, readonly) NSArray<__kindof NSOperation *> *pendingTransactions;

/**
 *  Whether or not the file manager is suspended. If suspended, the file manager can continue to queue uploads and deletes, but will not actually perform any of those until it is no longer suspended. This can be used for throttling down the file manager if other, important operations are taking place over the accessory connection.
 */
@property (assign, nonatomic) BOOL suspended;

/**
 *  Initialize the class...or not, since this method is unavailable. Dependencies must be injected using initWithConnectionManager:
 *
 *  @return nil
 */
- (instancetype)init NS_UNAVAILABLE;

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
- (void)startWithCompletionHandler:(nullable SDLFileManagerStartupCompletionHandler)completionHandler;

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
- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(nullable SDLFileManagerDeleteCompletionHandler)completion;

/**
 *  Upload a file to the remote file system. If a file with the [SDLFile name] already exists, this will overwrite that file. If you do not want that to happen, check remoteFileNames before uploading, or change allowOverwrite to NO.
 *
 *  @param file       An SDLFile that contains metadata about the file to be sent
 *  @param completion An optional completion handler that sends an error should one occur.
 */
- (void)uploadFile:(SDLFile *)file completionHandler:(nullable SDLFileManagerUploadCompletionHandler)completion;

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
