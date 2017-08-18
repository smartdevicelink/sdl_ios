//
//  SDLFileManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLFileManager.h"

#import "SDLConnectionManagerType.h"
#import "SDLLogMacros.h"
#import "SDLDeleteFileOperation.h"
#import "SDLError.h"
#import "SDLFile.h"
#import "SDLFileWrapper.h"
#import "SDLGlobals.h"
#import "SDLListFilesOperation.h"
#import "SDLManager.h"
#import "SDLNotificationConstants.h"
#import "SDLPutFile.h"
#import "SDLPutFileResponse.h"
#import "SDLStateMachine.h"
#import "SDLUploadFileOperation.h"


NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLFileManagerState;
SDLFileManagerState *const SDLFileManagerStateShutdown = @"Shutdown";
SDLFileManagerState *const SDLFileManagerStateFetchingInitialList = @"FetchingInitialList";
SDLFileManagerState *const SDLFileManagerStateReady = @"Ready";
SDLFileManagerState *const SDLFileManagerStateStartupError = @"StartupError";


#pragma mark - SDLFileManager class

@interface SDLFileManager ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

// Remote state
@property (strong, nonatomic, readwrite) NSMutableSet<SDLFileName *> *mutableRemoteFileNames;
@property (assign, nonatomic, readwrite) NSUInteger bytesAvailable;

// Local state
@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (strong, nonatomic) SDLStateMachine *stateMachine;
@property (copy, nonatomic, nullable) SDLFileManagerStartupCompletionHandler startupCompletionHandler;

@end

#pragma mark Constants

const char *_Nullable BackgroundUploadFilesQueue = "com.sdl.background.uploads.queue";
const char *_Nullable BackgroundUploadFilesWaitingQueue = "com.sdl.background.uploads.waiting.queue";
NSString * const FileManagerTransactionQueue = @"SDLFileManager Transaction Queue";

@implementation SDLFileManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _connectionManager = manager;
    _bytesAvailable = 0;

    _mutableRemoteFileNames = [NSMutableSet set];
    _transactionQueue = [[NSOperationQueue alloc] init];
    _transactionQueue.name = FileManagerTransactionQueue;
    // FIXME: - add comment below to class description
    // The transaction queue is serial for safety reasons. For example if a developer adds to the queue an upload file RPC and then adds an RPC to delete the same file, bad things can happen if the delete runs before the upload is completed.
    _transactionQueue.maxConcurrentOperationCount = 1;

    _stateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLFileManagerStateShutdown states:[self.class sdl_stateTransitionDictionary]];

    return self;
}


#pragma mark - Setup / Shutdown

- (void)startWithCompletionHandler:(nullable SDLFileManagerStartupCompletionHandler)handler {
    if ([self.currentState isEqualToString:SDLFileManagerStateShutdown]) {
        self.startupCompletionHandler = handler;
        [self.stateMachine transitionToState:SDLFileManagerStateFetchingInitialList];
    } else {
        // If we already started, just tell the handler we're started.
        handler(YES, nil);
    }
}

- (void)stop {
    [self.stateMachine transitionToState:SDLFileManagerStateShutdown];
}


#pragma mark - Getters

- (NSSet<SDLFileName *> *)remoteFileNames {
    return [NSSet setWithSet:self.mutableRemoteFileNames];
}

- (NSString *)currentState {
    return self.stateMachine.currentState;
}

- (NSArray<__kindof NSOperation *> *)pendingTransactions {
    return self.transactionQueue.operations;
}

- (BOOL)suspended {
    return self.transactionQueue.suspended;
}


#pragma mark Setters

- (void)setSuspended:(BOOL)suspended {
    self.transactionQueue.suspended = suspended;
}


#pragma mark - State

+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_stateTransitionDictionary {
    return @{
        SDLFileManagerStateShutdown: @[SDLFileManagerStateFetchingInitialList],
        SDLFileManagerStateFetchingInitialList: @[SDLFileManagerStateShutdown, SDLFileManagerStateReady, SDLFileManagerStateStartupError],
        SDLFileManagerStateReady: @[SDLFileManagerStateShutdown],
        SDLFileManagerStateStartupError: @[SDLFileManagerStateShutdown]
    };
}

- (void)didEnterStateStartupError {
    if (self.startupCompletionHandler != nil) {
        self.startupCompletionHandler(NO, [NSError sdl_fileManager_unableToStartError]);
        self.startupCompletionHandler = nil;
    }
}

- (void)didEnterStateShutdown {
    [self.transactionQueue cancelAllOperations];
    [self.mutableRemoteFileNames removeAllObjects];
    [self.class sdl_clearTemporaryFileDirectory];
    self.bytesAvailable = 0;

    self.startupCompletionHandler = nil;
}

- (void)didEnterStateFetchingInitialList {
    __weak typeof(self) weakSelf = self;
    [self sdl_listRemoteFilesWithCompletionHandler:^(BOOL success, NSUInteger bytesAvailable, NSArray<NSString *> *_Nonnull fileNames, NSError *_Nullable error) {
        // If there was an error, we'll pass the error to the startup handler and cancel out
        if (error != nil) {
            [weakSelf.stateMachine transitionToState:SDLFileManagerStateStartupError];
            BLOCK_RETURN;
        }

        // If no error, make sure we're in the ready state
        [weakSelf.stateMachine transitionToState:SDLFileManagerStateReady];
    }];
}

- (void)didEnterStateReady {
    if (self.startupCompletionHandler != nil) {
        self.startupCompletionHandler(YES, nil);
        self.startupCompletionHandler = nil;
    }
}


#pragma mark - Private Listing Remote Files

- (void)sdl_listRemoteFilesWithCompletionHandler:(SDLFileManagerListFilesCompletionHandler)handler {
    __weak typeof(self) weakSelf = self;
    SDLListFilesOperation *listOperation = [[SDLListFilesOperation alloc] initWithConnectionManager:self.connectionManager
                                                                                  completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSArray<NSString *> *_Nonnull fileNames, NSError *_Nullable error) {
                                                                                      if (error != nil || !success) {
                                                                                          handler(success, bytesAvailable, fileNames, error);
                                                                                          BLOCK_RETURN;
                                                                                      }

                                                                                      // If there was no error, set our properties and call back to the startup completion handler
                                                                                      [weakSelf.mutableRemoteFileNames addObjectsFromArray:fileNames];
                                                                                      weakSelf.bytesAvailable = bytesAvailable;

                                                                                      handler(success, bytesAvailable, fileNames, error);
                                                                                  }];

    [self.transactionQueue addOperation:listOperation];
}


#pragma mark - Deleting

- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(nullable SDLFileManagerDeleteCompletionHandler)handler {
    if ((![self.remoteFileNames containsObject:name]) && (handler != nil)) {
        handler(NO, self.bytesAvailable, [NSError sdl_fileManager_noKnownFileError]);
    }

    __weak typeof(self) weakSelf = self;
    SDLDeleteFileOperation *deleteOperation = [[SDLDeleteFileOperation alloc] initWithFileName:name
                                                                             connectionManager:self.connectionManager
                                                                             completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError *_Nullable error) {
                                                                                 __strong typeof(weakSelf) strongSelf = weakSelf;

                                                                                 // Mutate self based on the changes
                                                                                 strongSelf.bytesAvailable = bytesAvailable;
                                                                                 if (success) {
                                                                                     [strongSelf.mutableRemoteFileNames removeObject:name];
                                                                                 }

                                                                                 if (handler != nil) {
                                                                                     handler(YES, self.bytesAvailable, nil);
                                                                                 }
                                                                             }];

    [self.transactionQueue addOperation:deleteOperation];
}

- (void)deleteRemoteFilesWithNames:(NSArray<SDLFileName *> *)names completionHandler:(nullable SDLFileManagerMultiDeleteCompletionHandler)completionHandler {

}

#pragma mark - Uploading

- (void)uploadFiles:(NSArray<SDLFile *> *)files completionHandler:(nullable SDLFileManagerMultiUploadCompletionHandler)completionHandler {
    [self uploadFiles:files progressHandler:nil completionHandler:completionHandler];
}

- (void)uploadFiles:(NSArray<SDLFile *> *)files progressHandler:(nullable SDLFileManagerMultiUploadProgressHandler)progressHandler completionHandler:(nullable SDLFileManagerMultiUploadCompletionHandler)completionHandler {
    if (files.count == 0) {
        return completionHandler([NSError sdl_fileManager_noFilesError]);
    }

    float totalBytesToUpload = progressHandler == nil ? 0.0 : [self sdl_totalBytesToUpload:files];
    __block float totalBytesUploaded = 0.0;

    NSMutableDictionary *failedUploads = [[NSMutableDictionary alloc] init];
    dispatch_group_t uploadFilesTask = dispatch_group_create();

    dispatch_group_enter(uploadFilesTask);
    for(SDLFile *file in files) {
        dispatch_group_enter(uploadFilesTask);
        [self sdl_uploadFileAsync:file completionHandler:^(Boolean success, NSString * _Nonnull fileName, NSError * _Nullable error) {
            if (success == false) {
                failedUploads[fileName] = error;
            }

            // Send an update
            if (progressHandler != nil) {
                totalBytesUploaded += file.fileSize;
                float uploadPercentage = [self sdl_uploadPercentage:totalBytesToUpload uploadedBytes:totalBytesUploaded];
                Boolean cancel = false;
                progressHandler(fileName, uploadPercentage, &cancel, error);

                if (cancel) {
                    dispatch_group_leave(uploadFilesTask);
                    [self.transactionQueue cancelAllOperations];
                    BLOCK_RETURN;
                }
            }

            dispatch_group_leave(uploadFilesTask);
        }];
    }
    dispatch_group_leave(uploadFilesTask);

    dispatch_queue_t waitingQueue = dispatch_queue_create(BackgroundUploadFilesWaitingQueue, DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(waitingQueue, ^{
        dispatch_group_wait(uploadFilesTask, DISPATCH_TIME_FOREVER);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionHandler == nil) { return; }
            if (failedUploads.count > 0) {
                return completionHandler([NSError sdl_fileManager_unableToUploadError:failedUploads]);
            }

            return completionHandler(nil);
        });
    });
}

/**
 *  Uploads each file in on a serial background queue.
 *
 *  @param file    The file to upload
 *  @param handler Called when a response is received from the remote
 */
- (void)sdl_uploadFileAsync:(SDLFile *)file completionHandler:(void (^)(Boolean success, NSString *fileName, NSError * _Nullable error))handler {
    dispatch_queue_t backgroundQueue = dispatch_queue_create(BackgroundUploadFilesQueue, DISPATCH_QUEUE_SERIAL);
    dispatch_sync(backgroundQueue, ^{
        [self uploadFile:file completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler == nil) { return; }
                return handler(success, [file name], error);
            });
        }];
    });
}

/**
 *  Computes the total amount of bytes to be uploaded to the remote. This total is computed by summing up the file size of all files to be uploaded to the remote
 *
 *  @param files           All the files being uploaded to the remote
 *  @return                The total byte count
 */
- (float)sdl_totalBytesToUpload:(NSArray<SDLFile *> *)files {
    float totalBytes = 0.0;
    for(SDLFile *file in files) {
        totalBytes += file.fileSize;
    }

    return totalBytes;
}

/**
 * Computes the percentage of files uploaded to the remote. This percentage is a decimal number between 0.0 - 1.0. It is calculated by dividing the total number of bytes in files successfully or unsuccessfully uploaded by the total number of bytes in all files to be uploaded.
 *
 *  @param totalBytes      The total number of bytes in all files to be uploaded
 *  @param uploadedBytes   The total number of bytes in files successfully or unsuccessfully uploaded
 *  @return                The upload percentage
 */
- (float)sdl_uploadPercentage:(float)totalBytes uploadedBytes:(float)uploadedBytes {
    if (totalBytes == 0 || uploadedBytes == 0) {
        return 0.0;
    }
    return uploadedBytes / totalBytes;
}

- (void)uploadFile:(SDLFile *)file completionHandler:(nullable SDLFileManagerUploadCompletionHandler)handler {
    if (file == nil) {
        if (handler != nil) {
            handler(NO, self.bytesAvailable, [NSError sdl_fileManager_unableToUploadError]);
        }
        return;
    }

    // Make sure we are able to send files
    if (![self.currentState isEqualToString:SDLFileManagerStateReady]) {
        if (handler != nil) {
            handler(NO, self.bytesAvailable, [NSError sdl_fileManager_unableToUploadError]);
        }
        return;
    }

    // Check our overwrite settings and error out if it would overwrite
    if (file.overwrite == NO && [self.remoteFileNames containsObject:file.name]) {
        if (handler != nil) {
            handler(NO, self.bytesAvailable, [NSError sdl_fileManager_cannotOverwriteError]);
        }

        return;
    }

    // If we didn't error out over the overwrite, then continue on
    [self sdl_uploadFile:file completionHandler:handler];
}

- (void)sdl_uploadFile:(SDLFile *)file completionHandler:(nullable SDLFileManagerUploadCompletionHandler)handler {
    __block NSString *fileName = file.name;
    __block SDLFileManagerUploadCompletionHandler uploadCompletion = [handler copy];

    __weak typeof(self) weakSelf = self;
    SDLFileWrapper *fileWrapper = [SDLFileWrapper wrapperWithFile:file
                                                completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError *_Nullable error) {
                                                    [weakSelf.class sdl_deleteTemporaryFile:file.fileURL];

                                                    if (bytesAvailable != 0) {
                                                        weakSelf.bytesAvailable = bytesAvailable;
                                                    }
                                                    if (success) {
                                                        [weakSelf.mutableRemoteFileNames addObject:fileName];
                                                    }
                                                    if (uploadCompletion != nil) {
                                                        uploadCompletion(success, bytesAvailable, error);
                                                    }
                                                }];

    SDLUploadFileOperation *uploadOperation = [[SDLUploadFileOperation alloc] initWithFile:fileWrapper connectionManager:self.connectionManager];

    [self.transactionQueue addOperation:uploadOperation];
}


#pragma mark - Temporary Files

+ (NSURL *)temporaryFileDirectory {
    NSURL *directoryURL = [self.class sdl_temporaryFileDirectoryName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[directoryURL path]]) {
        [[NSFileManager defaultManager] createDirectoryAtURL:directoryURL withIntermediateDirectories:NO attributes:nil error:nil];
    }

    return directoryURL;
}

+ (NSURL *)sdl_temporaryFileDirectoryName {
    return [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"SDL"]];
}

+ (void)sdl_clearTemporaryFileDirectory {
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.class sdl_temporaryFileDirectoryName].absoluteString]) {
        [[NSFileManager defaultManager] removeItemAtURL:[self.class sdl_temporaryFileDirectoryName] error:&error];
    }

    if (error != nil) {
        SDLLogW(@"[Error clearing temporary file directory] %@", error);
    }
}

+ (void)sdl_deleteTemporaryFile:(NSURL *)fileURL {
    NSError *error = nil;
    if (![[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error]) {
        SDLLogW(@"[Error clearing temporary file directory] %@ (%@)", error, fileURL);
    }
}

@end


NS_ASSUME_NONNULL_END
