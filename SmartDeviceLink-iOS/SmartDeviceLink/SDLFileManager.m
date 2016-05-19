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
#import "SDLListFiles.h"
#import "SDLListFilesResponse.h"
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

- (void)startManagerWithCompletionHandler:(SDLFileManagerStartupCompletion)completionHandler {
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
    return [self.mutableRemoteFileNames copy];
}

- (NSString *)currentState {
    return self.stateMachine.currentState;
}

- (NSUInteger)pendingTransactionsCount {
    return self.transactionQueue.operationCount;
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
    SDLListFiles *listFiles = [SDLRPCRequestFactory buildListFilesWithCorrelationID:@0];
    
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequest:listFiles withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (error != nil) {
            self.startupCompletionHandler(NO, error);
            [self.stateMachine transitionToState:SDLFileManagerStateShutdown];
            BLOCK_RETURN;
        }
        
        SDLListFilesResponse *listFilesResponse = (SDLListFilesResponse *)response;
        [strongSelf.mutableRemoteFileNames addObjectsFromArray:listFilesResponse.filenames];
        strongSelf.bytesAvailable = [listFilesResponse.spaceAvailable unsignedIntegerValue];
        
        [strongSelf.stateMachine transitionToState:SDLFileManagerStateReady];
    }];
}

- (void)didEnterStateReady {
    self.startupCompletionHandler(YES, nil);
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
