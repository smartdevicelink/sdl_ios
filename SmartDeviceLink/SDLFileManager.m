//
//  SDLFileManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLFileManager.h"

#import "SDLDebugTool.h"
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
#import "SDLRPCRequestFactory.h"
#import "SDLStateMachine.h"
#import "SDLUploadFileOperation.h"


NS_ASSUME_NONNULL_BEGIN

NSString *const SDLFileManagerStateShutdown = @"Shutdown";
NSString *const SDLFileManagerStateFetchingInitialList = @"FetchingInitialList";
NSString *const SDLFileManagerStateReady = @"Ready";


#pragma mark - SDLFileManager class

@interface SDLFileManager ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

// Remote state
@property (copy, nonatomic, readwrite) NSMutableSet<SDLFileName *> *mutableRemoteFileNames;
@property (assign, nonatomic, readwrite) NSUInteger bytesAvailable;

// Local state
@property (strong, nonatomic) NSOperationQueue *transactionQueue;
@property (strong, nonatomic) SDLStateMachine *stateMachine;
@property (copy, nonatomic, nullable) SDLFileManagerStartupCompletion startupCompletionHandler;

@end


@implementation SDLFileManager

#pragma mark - Lifecycle

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _connectionManager = manager;
    _bytesAvailable = 0;
    _allowOverwrite = NO;
    
    _mutableRemoteFileNames = [NSMutableSet set];
    _transactionQueue = [[NSOperationQueue alloc] init];
    _transactionQueue.name = @"SDLFileManager Transaction Queue";
    _transactionQueue.maxConcurrentOperationCount = 1;
    
    _stateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLFileManagerStateShutdown states:[self.class sdl_stateTransitionDictionary]];
    
    return self;
}


#pragma mark - Setup / Shutdown

- (void)startManagerWithCompletionHandler:(nullable SDLFileManagerStartupCompletion)completionHandler {
    if ([self.currentState isEqualToString:SDLFileManagerStateShutdown]) {
        self.startupCompletionHandler = completionHandler;
        [self.stateMachine transitionToState:SDLFileManagerStateFetchingInitialList];
    } else {
        // If we already started, just tell the handler we're started.
        completionHandler(YES, nil);
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
             SDLFileManagerStateFetchingInitialList: @[SDLFileManagerStateShutdown, SDLFileManagerStateReady],
             SDLFileManagerStateReady: @[SDLFileManagerStateShutdown]
             };
}

- (void)willEnterStateShutdown {
    [self.transactionQueue cancelAllOperations];
    [self.mutableRemoteFileNames removeAllObjects];
    [self.class sdl_clearTemporaryFileDirectory];
    self.bytesAvailable = 0;
}

- (void)didEnterStateFetchingInitialList {
    __weak typeof(self) weakSelf = self;
    [self sdl_listRemoteFilesWithCompletionHandler:^(BOOL success, NSUInteger bytesAvailable, NSArray<NSString *> * _Nonnull fileNames, NSError * _Nullable error) {
        // If there was an error, we'll pass the error to the startup handler and cancel out
        if (error != nil) {
            weakSelf.startupCompletionHandler(NO, error);
            [weakSelf.stateMachine transitionToState:SDLFileManagerStateShutdown];
            BLOCK_RETURN;
        }
        
        // If no error, make sure we're in the ready state
        [weakSelf.stateMachine transitionToState:SDLFileManagerStateReady];
    }];
}

- (void)didEnterStateReady {
    if (self.startupCompletionHandler != nil) {
        self.startupCompletionHandler(YES, nil);
    }
}


#pragma mark - Private Listing Remote Files

- (void)sdl_listRemoteFilesWithCompletionHandler:(SDLFileManagerListFilesCompletion)completion {
    __weak typeof(self) weakSelf = self;
    SDLListFilesOperation *listOperation = [[SDLListFilesOperation alloc] initWithConnectionManager:self.connectionManager completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSArray<NSString *> * _Nonnull fileNames, NSError * _Nullable error) {
        if (error != nil || !success) {
            BLOCK_RETURN;
        }
        
        // If there was no error, set our properties and call back to the startup completion handler
        [weakSelf.mutableRemoteFileNames addObjectsFromArray:fileNames];
        weakSelf.bytesAvailable = bytesAvailable;
        
        completion(success, bytesAvailable, fileNames, error);
    }];
    
    [self.transactionQueue addOperation:listOperation];
}


#pragma mark - Deleting

- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(nullable SDLFileManagerDeleteCompletion)completion {
    if (![self.remoteFileNames containsObject:name]) {
        completion(NO, self.bytesAvailable, [NSError sdl_fileManager_noKnownFileError]);
    }
    
    __weak typeof(self) weakSelf = self;
    SDLDeleteFileOperation *deleteOperation = [[SDLDeleteFileOperation alloc] initWithFileName:name connectionManager:self.connectionManager completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        // Mutate self based on the changes
        strongSelf.bytesAvailable = bytesAvailable;
        if (success) {
            [strongSelf.mutableRemoteFileNames removeObject:name];
        }
        
        completion(YES, self.bytesAvailable, nil);
    }];
    
    [self.transactionQueue addOperation:deleteOperation];
}


#pragma mark - Uploading

- (void)uploadFile:(SDLFile *)file completionHandler:(nullable SDLFileManagerUploadCompletion)completion {
    // Check our overwrite settings and error out if it would overwrite
    if (self.allowOverwrite == NO && [self.remoteFileNames containsObject:file.name]) {
        if (completion != nil) {
            completion(NO, self.bytesAvailable, [NSError sdl_fileManager_cannotOverwriteError]);
        }
        
        return;
    }
    
    // If we didn't error out over the overwrite, then continue on
    [self sdl_uploadFile:file completionHandler:completion];
}

- (void)forceUploadFile:(SDLFile *)file completionHandler:(nullable SDLFileManagerUploadCompletion)completion {
    [self sdl_uploadFile:file completionHandler:completion];
}

- (void)sdl_uploadFile:(SDLFile *)file completionHandler:(nullable SDLFileManagerUploadCompletion)completion {
    SDLFileWrapper *fileWrapper = [SDLFileWrapper wrapperWithFile:file completionHandler:^(BOOL success, NSUInteger bytesAvailable, NSError * _Nullable error) {
        [self.class sdl_deleteTemporaryFile:file.fileURL];
        completion(success, bytesAvailable, error);
    }];
    
    SDLUploadFileOperation *uploadOperation = [[SDLUploadFileOperation alloc] initWithFile:fileWrapper connectionManager:self.connectionManager];
    
    [self.transactionQueue addOperation:uploadOperation];
}


#pragma mark - Temporary Files

+ (NSURL *)temporaryFileDirectory {
    NSURL *directoryURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"SDL"]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:[directoryURL path]]) {
        [[NSFileManager defaultManager] createDirectoryAtURL:directoryURL withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return directoryURL;
}

+ (void)sdl_clearTemporaryFileDirectory {
    BOOL (^errorHandler)(NSURL *url, NSError *error) = ^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
        NSString *debugString = [NSString stringWithFormat:@"[Error clearing temporary file directory] %@ (%@)", error, url];
        [SDLDebugTool logInfo:debugString];
        return YES;
    };
    
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtURL:[self.class temporaryFileDirectory] includingPropertiesForKeys:@[NSURLNameKey, NSURLIsDirectoryKey] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:errorHandler];
    
    for (NSURL *fileURL in enumerator) {
        NSError *error = nil;
        if(![[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error]) {
            errorHandler(fileURL, error);
        }
    }
}

+ (void)sdl_deleteTemporaryFile:(NSURL *)fileURL {
    NSError *error = nil;
    if (![[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error]) {
        NSString *debugString = [NSString stringWithFormat:@"[Error clearing temporary file directory] %@ (%@)", error, fileURL];
        [SDLDebugTool logInfo:debugString];
    }
}


@end


NS_ASSUME_NONNULL_END
