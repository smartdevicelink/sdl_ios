//
//  SDLFileManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/14/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLFileManager.h"

#import "SDLDeleteFile.h"
#import "SDLDeleteFileResponse.h"
#import "SDLError.h"
#import "SDLFile.h"
#import "SDLGlobals.h"
#import "SDLListFiles.h"
#import "SDLListFilesResponse.h"
#import "SDLManager.h"
#import "SDLNotificationConstants.h"
#import "SDLPutFile.h"
#import "SDLPutFileResponse.h"
#import "SDLRPCRequestFactory.h"


NS_ASSUME_NONNULL_BEGIN

NSString *const SDLFileManagerStateShutdown = @"Shutdown";
NSString *const SDLFileManagerStateFetchingInitialList = @"FetchingInitialList";
NSString *const SDLFileManagerStateCheckingQueue = @"CheckingQueue";
NSString *const SDLFileManagerStateUploading = @"Uploading";
NSString *const SDLFileManagerStateIdle = @"Idle";


#pragma mark - SDLFileWrapper Helper Class

@interface SDLFileWrapper : NSObject

@property (strong, nonatomic, readonly) SDLFile *file;
@property (copy, nonatomic, readonly) SDLFileManagerUploadCompletion completionHandler;

- (instancetype)initWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completionHandler;

+ (instancetype)wrapperWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completionHandler;

@end

@implementation SDLFileWrapper

- (instancetype)initWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completionHandler {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _file = file;
    _completionHandler = completionHandler;
    
    return self;
}

+ (instancetype)wrapperWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completionHandler {
    return [[self alloc] initWithFile:file completionHandler:completionHandler];
}

@end


#pragma mark - SDLFileManager class

@interface SDLFileManager ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

// Remote state
@property (copy, nonatomic, readwrite) NSMutableSet<SDLFileName *> *mutableRemoteFileNames;
@property (assign, nonatomic, readwrite) NSUInteger bytesAvailable;

// Local state
@property (copy, nonatomic) NSMutableArray<SDLFileWrapper *> *uploadQueue;
@property (strong, nonatomic, readwrite) SDLStateMachine *stateMachine;
@property (assign, nonatomic) BOOL initialUpload;
@property (copy, nonatomic, nullable) SDLFileManagerStartupCompletion startupCompletionHandler;

@end

// TODO: Allow versioning of persistent files so that if new ones need to overwrite old ones they can.

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
    _uploadQueue = [initialFiles mutableCopy];
    
    _stateMachine = [[SDLStateMachine alloc] initWithTarget:self initialState:SDLFileManagerStateShutdown states:[self.class sdl_stateTransitionDictionary]];
    _initialUpload = YES;
    
    return self;
}


#pragma mark - Setup / Shutdown

- (void)startManagerWithCompletionHandler:(SDLFileManagerStartupCompletion)completionHandler {
    if ([self.currentState isEqualToString:SDLFileManagerStateShutdown]) {
        self.startupCompletionHandler = completionHandler;
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
    [self.uploadQueue removeAllObjects];
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

- (void)didEnterStateCheckingQueue {
    if (self.uploadQueue.count > 0) {
        [self.stateMachine transitionToState:SDLFileManagerStateUploading];
    } else {
        [self.stateMachine transitionToState:SDLFileManagerStateIdle];
    }
}

- (void)didEnterStateUploading {
    SDLFileWrapper *nextFile = [self.uploadQueue firstObject];
    [self.uploadQueue removeObjectAtIndex:0];
    
    NSArray<SDLPutFile *> *putFiles = [self.class sdl_splitFile:nextFile.file];
    [self sdl_sendPutFiles:putFiles withCompletion:nextFile.completionHandler];
}

- (void)didEnterStateIdle {
    if (self.initialUpload) {
        self.startupCompletionHandler(YES, self.bytesAvailable, nil);
    }
    
    self.initialUpload = NO;
}


#pragma mark - Deleting

- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(nullable SDLFileManagerDeleteCompletion)completion {
    if (![self.mutableRemoteFileNames containsObject:name]) {
        completion(NO, self.bytesAvailable, [NSError sdl_fileManager_noKnownFileError]);
    }
    
    SDLDeleteFile *deleteFile = [SDLRPCRequestFactory buildDeleteFileWithName:name correlationID:@0];
    
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequest:deleteFile withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        // Pull out the parameters
        SDLDeleteFileResponse *deleteFileResponse = (SDLDeleteFileResponse *)response;
        BOOL success = [deleteFileResponse.success boolValue];
        NSInteger bytesAvailable = [deleteFileResponse.spaceAvailable unsignedIntegerValue];
        
        // Mutate self based on the changes
        strongSelf.bytesAvailable = bytesAvailable;
        if (success) {
            [strongSelf.mutableRemoteFileNames removeObject:name];
        }
        
        // Callback
        if (completion != nil) {
            completion(success, bytesAvailable, error);
        }
    }];
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
    [self.uploadQueue addObject:[SDLFileWrapper wrapperWithFile:file completionHandler:completion]];
    [self.stateMachine transitionToState:SDLFileManagerStateCheckingQueue];
}

- (void)sdl_sendPutFiles:(NSArray<SDLPutFile *> *)putFiles withCompletion:(nullable SDLFileManagerUploadCompletion)completion {
    __block BOOL stop = NO;
    __block NSError *streamError = nil;
    __block NSInteger highestCorrelationIDReceived = -1;
    
    // Move this to an NSOperation?
    dispatch_group_t putFileGroup = dispatch_group_create();
    // When the putfiles all complete, run this block
    dispatch_group_notify(putFileGroup, dispatch_get_main_queue(), ^{
        [self.mutableRemoteFileNames addObject:putFiles[0].syncFileName];
        
        if (completion != nil) {
            completion(YES, self.bytesAvailable, nil);
        }
        
        [self.stateMachine transitionToState:SDLFileManagerStateCheckingQueue];
    });
    
    for (SDLPutFile *putFile in putFiles) {
        // TODO: More classes for something like upload tasks in NSURLSession, to be able to send and be able to cancel instead of just looping.
        dispatch_group_enter(putFileGroup);
        __weak typeof(self) weakSelf = self;
        [self.connectionManager sendRequest:putFile withCompletionHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            // If we've already encountered an error, then just abort
            // TODO: Is this the right way to handle this case? Should we just abort everything in the future? Should we be deleting what we sent? Should we have an automatic retry strategy based on what the error was?
            if (stop) {
                dispatch_group_leave(putFileGroup);
                BLOCK_RETURN;
            }
            
            // If we encounted an error, abort in the future and call the completion handler
            if (error != nil || response == nil || ![response.success boolValue]) {
                stop = YES;
                streamError = error;
                
                if (response != nil) {
                    strongSelf.bytesAvailable = [((SDLPutFileResponse *)response).spaceAvailable unsignedIntegerValue];
                }
                
                if (completion != nil) {
                    completion(NO, strongSelf.bytesAvailable, error);
                }
                
                dispatch_group_leave(putFileGroup);
                [strongSelf.stateMachine transitionToState:SDLFileManagerStateCheckingQueue];
                
                BLOCK_RETURN;
            }
            
            // If we haven't encounted an error
            SDLPutFileResponse *putFileResponse = (SDLPutFileResponse *)response;
            
            // We need to do this to make sure our bytesAvailable is accurate
            if ([request.correlationID integerValue] > highestCorrelationIDReceived) {
                highestCorrelationIDReceived = [request.correlationID integerValue];
                strongSelf.bytesAvailable = [putFileResponse.spaceAvailable unsignedIntegerValue];
            }
            
            dispatch_group_leave(putFileGroup);
        }];
    }
}

+ (NSArray<SDLPutFile *> *)sdl_splitFile:(SDLFile *)file {
    NSData *fileData = [file.data copy];
    NSUInteger currentOffset = 0;
    NSMutableArray<SDLPutFile *> *putFiles = [NSMutableArray array];
    
    for (int i = 0; i < ((fileData.length / [SDLGlobals globals].maxMTUSize) + 1); i++) {
        SDLPutFile *putFile = [SDLRPCRequestFactory buildPutFileWithFileName:file.name fileType:file.fileType persistentFile:@(file.isPersistent) correlationId:@0];
        putFile.offset = @(currentOffset);
        
        if (currentOffset == 0) {
            putFile.length = @(fileData.length);
        } else if((fileData.length - currentOffset) < [SDLGlobals globals].maxMTUSize) {
            putFile.length = @(fileData.length - currentOffset);
        } else {
            putFile.length = @([SDLGlobals globals].maxMTUSize);
        }
        
        putFile.bulkData = [fileData subdataWithRange:NSMakeRange(currentOffset, [putFile.length unsignedIntegerValue])];
        currentOffset = [putFile.length unsignedIntegerValue] + 1;
        
        [putFiles addObject:putFile];
    }
    
    return putFiles;
}

@end


NS_ASSUME_NONNULL_END
