//
//  SDLFileManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLFileManager.h"

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
#import "SDLUploadFileOperation.h"


NS_ASSUME_NONNULL_BEGIN

NSString *const SDLFileManagerStateShutdown = @"Shutdown";
NSString *const SDLFileManagerStateFetchingInitialList = @"FetchingInitialList";
NSString *const SDLFileManagerStateUploading = @"Uploading";
NSString *const SDLFileManagerStateIdle = @"Idle";


#pragma mark - SDLFileManager class

@interface SDLFileManager ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

// Remote state
@property (copy, nonatomic, readwrite) NSMutableSet<SDLFileName *> *mutableRemoteFileNames;
@property (assign, nonatomic, readwrite) NSUInteger bytesAvailable;

// Local state
@property (strong, nonatomic) NSOperationQueue *transationQueue;
@property (strong, nonatomic, readwrite) SDLStateMachine *stateMachine;
@property (copy, nonatomic, nullable) SDLFileManagerStartupCompletion startupCompletionHandler;
@property (assign, nonatomic) BOOL initialUpload;

@end

// TODO: Allow versioning of persistent files so that if new ones need to overwrite old ones they can.

// TODO: Remove the idea of "initial files"?

@implementation SDLFileManager

#pragma mark - Lifecycle

- (instancetype)init {
    return [self initWithConnectionManager:[SDLManager sharedManager] initialFiles:@[]];
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager initialFiles:(NSArray<SDLFile *> *)initialFiles {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _connectionManager = manager;
    _bytesAvailable = 0;
    _allowOverwrite = NO;
    
    _mutableRemoteFileNames = [NSMutableSet set];
    _transationQueue = [[NSOperationQueue alloc] init];
    _transationQueue.name = @"SDLFileManager Transaction Queue";
    _transationQueue.maxConcurrentOperationCount = 1;
    
    _stateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLFileManagerStateShutdown states:[self.class sdl_stateTransitionDictionary]];
    _initialUpload = YES;
    
    return self;
}


#pragma mark - Setup / Shutdown

- (void)startManagerWithCompletionHandler:(SDLFileManagerStartupCompletion)completionHandler {
    if ([self.currentState isEqualToString:SDLFileManagerStateShutdown]) {
        self.startupCompletionHandler = completionHandler;
        // TODO: Add initial files to operation queue
        
        [self.stateMachine transitionToState:SDLFileManagerStateFetchingInitialList];
    } else {
        // If we already started, just tell the handler we're started.
        completionHandler(YES, self.bytesAvailable, nil);
    }
}

- (void)stop {
    [self.stateMachine transitionToState:SDLFileManagerStateShutdown];
}


#pragma mark - Getters

- (NSSet<SDLFileName *> *)remoteFileNames {
    return [self.mutableRemoteFileNames copy];
}

- (SDLState *)currentState {
    return self.stateMachine.currentState;
}


#pragma mark - State

+ (NSDictionary<SDLState *, SDLAllowableStateTransitions *> *)sdl_stateTransitionDictionary {
    return @{
             SDLFileManagerStateShutdown: @[SDLFileManagerStateFetchingInitialList],
             SDLFileManagerStateFetchingInitialList: @[SDLFileManagerStateShutdown, SDLFileManagerStateCheckingQueue],
             SDLFileManagerStateCheckingQueue: @[SDLFileManagerStateShutdown,SDLFileManagerStateUploading, SDLFileManagerStateIdle],
             SDLFileManagerStateUploading: @[SDLFileManagerStateShutdown, SDLFileManagerStateCheckingQueue, SDLFileManagerStateIdle],
             SDLFileManagerStateIdle: @[SDLFileManagerStateShutdown, SDLFileManagerStateUploading]
             };
}

- (void)willEnterStateNotConnected {
    [self.transationQueue cancelAllOperations];
    [self.mutableRemoteFileNames removeAllObjects];
    self.bytesAvailable = 0;
}

- (void)didEnterStateFetchingInitialList {
    SDLListFiles *listFiles = [SDLRPCRequestFactory buildListFilesWithCorrelationID:@0];
    
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequest:listFiles withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (error != nil) {
            self.startupCompletionHandler(NO, 0, error);
            BLOCK_RETURN;
        }
        
        SDLListFilesResponse *listFilesResponse = (SDLListFilesResponse *)response;
        [strongSelf.mutableRemoteFileNames addObjectsFromArray:listFilesResponse.filenames];
        strongSelf.bytesAvailable = [listFilesResponse.spaceAvailable unsignedIntegerValue];
        
        [strongSelf.stateMachine transitionToState:SDLFileManagerStateCheckingQueue];
    }];
}

- (void)didEnterStateIdle {
    // TODO: Observe transaction queue to find out when this is?
    if (self.initialUpload) {
        self.startupCompletionHandler(YES, self.bytesAvailable, nil);
    }
    
    self.initialUpload = NO;
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
    
    [self.transationQueue addOperation:deleteOperation];
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
    SDLUploadFileOperation *uploadOperation = [[SDLUploadFileOperation alloc] initWithFile:[SDLFileWrapper wrapperWithFile:file completionHandler:completion] connectionManager:self.connectionManager];
    
    [self.transationQueue addOperation:uploadOperation];
}


@end


NS_ASSUME_NONNULL_END
