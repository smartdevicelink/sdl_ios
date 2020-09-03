//
//  SDLFileManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLArtwork.h"
#import "SDLFileManagerConstants.h"

@class SDLFile;
@class SDLFileManagerConfiguration;
@protocol SDLConnectionManagerType;


NS_ASSUME_NONNULL_BEGIN

/// The handler that is called when the manager is set up or failed to set up with an error.
/// This is for internal use only.
///
/// @param success True if every request succeeded, false if any failed.
/// @param error The error that occurred during the request if any occurred.
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
 *  Creates a new file manager with a specified connection manager and configuration
 *
 *  @param manager          A connection manager to use to forward on RPCs
 *  @param configuration    A configuration for this file manager session
 *
 *  @return An instance of SDLFileManager
 */
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager configuration:(SDLFileManagerConfiguration *)configuration NS_DESIGNATED_INITIALIZER;

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
 Check if the remote system contains a file

 @param file The file to check
 @return Whether or not the remote system has the file
 */
- (BOOL)hasUploadedFile:(SDLFile *)file;

/**
 *  Delete a file stored on the remote system
 *
 *  @param name       The name of the remote file. It should be a name currently stored in remoteFileNames
 *  @param completion An optional completion handler that sends an error should one occur.
 */
- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(nullable SDLFileManagerDeleteCompletionHandler)completion NS_SWIFT_NAME(delete(fileName:completionHandler:));

/**
 *  Deletes an array of files on the remote file system. The files are deleted in the order in which they are added to the array, with the first file to be deleted at index 0. The delete queue is sequential, meaning that once a delete request is sent to Core, the queue waits until a response is received from Core before the next the next delete request is sent.
 *
 *  @param names  The names of the files to be deleted
 *  @param completionHandler  an optional SDLFileManagerMultiDeleteCompletionHandler
 */
- (void)deleteRemoteFilesWithNames:(NSArray<SDLFileName *> *)names completionHandler:(nullable SDLFileManagerMultiDeleteCompletionHandler)completionHandler NS_SWIFT_NAME(delete(fileNames:completionHandler:));

/**
 *  Upload a file to the remote file system. If a file with the [SDLFile name] already exists, this will overwrite that file. If you do not want that to happen, check remoteFileNames before uploading, or change allowOverwrite to NO.
 *
 *  @param file       An SDLFile that contains metadata about the file to be sent
 *  @param completion An optional completion handler that sends an error should one occur.
 */
- (void)uploadFile:(SDLFile *)file completionHandler:(nullable SDLFileManagerUploadCompletionHandler)completion NS_SWIFT_NAME(upload(file:completionHandler:));

/**
 *  Uploads an array of files to the remote file system. The files will be uploaded in the order in which they are added to the array, with the first file to be uploaded at index 0. The upload queue is sequential, meaning that once a upload request is sent to Core, the queue waits until a response is received from Core before the next the next upload request is sent.
 *
 *  The optional progress handler can be used to keep track of the upload progress. After each file upload, the progress handler returns the upload percentage and an error, if one occured during the upload process. The progress handler also includes an option to cancel the upload of all remaining files in queue.
 *
 *  @param files  An array of SDLFiles to be sent
 *  @param progressHandler an optional SDLFileManagerMultiUploadProgressHandler
 *  @param completionHandler an optional SDLFileManagerMultiUploadCompletionHandler
 */
- (void)uploadFiles:(NSArray<SDLFile *> *)files progressHandler:(nullable SDLFileManagerMultiUploadProgressHandler)progressHandler completionHandler:(nullable SDLFileManagerMultiUploadCompletionHandler)completionHandler NS_SWIFT_NAME(upload(files:progressHandler:completionHandler:));

/**
 *  Uploads an array of files to the remote file system. The files will be uploaded in the order in which they are added to the array, with the first file to be uploaded at index 0. The upload queue is sequential, meaning that once a upload request is sent to Core, the queue waits until a response is received from Core before the next the next upload request is sent.
 *
 *  @param files                An array of SDLFiles to be sent
 *  @param completionHandler    An optional SDLFileManagerMultiUploadCompletionHandler
 */
- (void)uploadFiles:(NSArray<SDLFile *> *)files completionHandler:(nullable SDLFileManagerMultiUploadCompletionHandler)completionHandler NS_SWIFT_NAME(upload(files:completionHandler:));

/**
 *  Uploads an artwork file to the remote file system and returns the name of the uploaded artwork once completed. If an artwork with the same name is already on the remote system, the artwork is not uploaded and the artwork name is simply returned.
 *
 *  @param artwork      A SDLArwork containing an image to be sent
 *  @param completion   An optional completion handler that returns the name of the uploaded artwork. It also returns an error if the upload fails.
 */
- (void)uploadArtwork:(SDLArtwork *)artwork completionHandler:(nullable SDLFileManagerUploadArtworkCompletionHandler)completion NS_SWIFT_NAME(upload(artwork:completionHandler:));

/**
 *  Uploads an array of artworks to the remote file system. The artworks will be uploaded in the order in which they are added to the array, with the first file to be uploaded at index 0. The upload queue is sequential, meaning that once a upload request is sent to Core, the queue waits until a response is received from Core before the next the next upload request is sent.
 *
 *  @param artworks     An array of SDLArtworks to be sent
 *  @param completion   An optional SDLFileManagerMultiUploadArtworkCompletionHandler
 */
- (void)uploadArtworks:(NSArray<SDLArtwork *> *)artworks completionHandler:(nullable SDLFileManagerMultiUploadArtworkCompletionHandler)completion NS_SWIFT_NAME(upload(artworks:completionHandler:));

/**
 *  Uploads an array of artworks to the remote file system. The artworks will be uploaded in the order in which they are added to the array, with the first file to be uploaded at index 0. The upload queue is sequential, meaning that once a upload request is sent to Core, the queue waits until a response is received from Core before the next the next upload request is sent.
 *
 *  The optional progress handler can be used to keep track of the upload progress. After each artwork upload, the progress handler returns the artwork name, the upload percentage and an error, if one occured during the upload process. The progress handler also includes an option to cancel the upload of all remaining files in queue.
 *
 *  @param artworks         An array of SDLArtworks to be sent
 *  @param progressHandler  An optional SDLFileManagerMultiUploadArtworkProgressHandler
 *  @param completion       An optional SDLFileManagerMultiUploadArtworkCompletionHandler
 */
- (void)uploadArtworks:(NSArray<SDLArtwork *> *)artworks progressHandler:(nullable SDLFileManagerMultiUploadArtworkProgressHandler)progressHandler completionHandler:(nullable SDLFileManagerMultiUploadArtworkCompletionHandler)completion NS_SWIFT_NAME(upload(artworks:progressHandler:completionHandler:));

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
