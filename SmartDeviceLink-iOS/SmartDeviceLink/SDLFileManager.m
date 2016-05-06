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

NSString *const SDLFileManagerStateNotConnected = @"NotConnected";
NSString *const SDLFileManagerStateFetchingInitialList = @"FetchingInitialList";
NSString *const SDLFileManagerStateCheckingQueue = @"CheckingQueue";
NSString *const SDLFileManagerStateUploading = @"Uploading";
NSString *const SDLFileManagerStateIdle = @"Idle";


#pragma mark - SDLFileWrapper class struct

@interface SDLFileWrapper : NSObject

@property (strong, nonatomic, readonly) SDLFile *file;
@property (copy, nonatomic, readonly) SDLFileManagerUploadCompletion completionHandler;

- (instancetype)initWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completionHandler;

+ (instancetype)wrapperWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completionHandler;

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

@end


@implementation SDLFileManager

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
    
    _stateMachine = [[SDLStateMachine alloc] initWithTarget:self states:[self.class sdl_stateTransitionDictionary] startState:SDLFileManagerStateNotConnected];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didConnect:) name:SDLDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didDisconnect:) name:SDLDidDisconnectNotification object:nil];
    
    return self;
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
             SDLFileManagerStateNotConnected: @[SDLFileManagerStateFetchingInitialList],
             SDLFileManagerStateFetchingInitialList: @[SDLFileManagerStateNotConnected, SDLFileManagerStateCheckingQueue],
             SDLFileManagerStateCheckingQueue: @[SDLFileManagerStateNotConnected,SDLFileManagerStateUploading, SDLFileManagerStateIdle],
             SDLFileManagerStateUploading: @[SDLFileManagerStateNotConnected, SDLFileManagerStateCheckingQueue, SDLFileManagerStateIdle],
             SDLFileManagerStateIdle: @[SDLFileManagerStateNotConnected, SDLFileManagerStateNotConnected, SDLFileManagerStateUploading]
             };
}

- (void)didEnterStateFetchingInitialList {
    
}

- (void)didEnterStateCheckingQueue {
    if (self.uploadQueue.count > 0) {
        SDLFileWrapper *wrapper = [self.uploadQueue firstObject];
        [self.uploadQueue removeObjectAtIndex:0];
        [self uploadFile:wrapper.file completionHandler:wrapper.completionHandler];
    } else {
        [self.stateMachine transitionToState:SDLFileManagerStateIdle];
    }
}

- (void)didEnterStateNotConnected {
    [self.mutableRemoteFileNames removeAllObjects];
    self.bytesAvailable = 0;
    
    // TODO: Change back to initialFiles
    [self.uploadQueue removeAllObjects];
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
    if ([self.stateMachine isCurrentState:SDLFileManagerStateIdle]) {
        [self.stateMachine transitionToState:SDLFileManagerStateUploading];
        
        NSArray<SDLPutFile *> *putFiles = [self.class sdl_splitFile:file];
        [self sdl_sendPutFiles:putFiles withCompletion:completion];
    } else if ([self.stateMachine isCurrentState:SDLFileManagerStateUploading]) {
        [self.uploadQueue addObject:[SDLFileWrapper wrapperWithFile:file completionHandler:completion]];
    }
}

- (void)sdl_sendPutFiles:(NSArray<SDLPutFile *> *)putFiles withCompletion:(nullable SDLFileManagerUploadCompletion)completion {
    __block BOOL stop = NO;
    __block NSError *streamError = nil;
    __block NSUInteger numResponsesReceived = 0;
    __block NSInteger highestCorrelationIDReceived = -1;
    
    __weak typeof(self) weakSelf = self;
    for (SDLPutFile *putFile in putFiles) {
        // TODO: More classes for something like upload tasks in NSURLSession, to be able to send and be able to cancel instead of just looping.
        [self.connectionManager sendRequest:putFile withCompletionHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            // If we've already encountered an error, then just abort
            // TODO: Is this the right way to handle this case? Should we just abort everything in the future? Should we be deleting what we sent? Should we have an automatic retry strategy based on what the error was?
            if (stop) {
                return;
            }
            
            // If we encounted an error, abort in the future and call the completion handler
            if (error != nil || response == nil || ![response.success boolValue]) {
                stop = YES;
                streamError = error;
                [strongSelf.stateMachine transitionToState:SDLFileManagerStateCheckingQueue];
                
                if (response != nil) {
                    strongSelf.bytesAvailable = [((SDLPutFileResponse *)response).spaceAvailable unsignedIntegerValue];
                }
                
                if (completion != nil) {
                    completion(NO, strongSelf.bytesAvailable, error);
                }
                
                return;
            }
            
            // If we haven't encounted an error
            SDLPutFileResponse *putFileResponse = (SDLPutFileResponse *)response;
            numResponsesReceived++;
            
            // We need to do this to make sure our bytesAvailable is accurate
            if ([request.correlationID integerValue] > highestCorrelationIDReceived) {
                highestCorrelationIDReceived = [request.correlationID integerValue];
                strongSelf.bytesAvailable = [putFileResponse.spaceAvailable unsignedIntegerValue];
            }
            
            // If we've received all the responses we're going to receive and haven't errored, we're done
            if (putFiles.count == numResponsesReceived) {
                stop = YES;
                [strongSelf.mutableRemoteFileNames addObject:putFile.syncFileName];
                
                if (completion != nil) {
                    completion(YES, strongSelf.bytesAvailable, nil);
                }
                
                [strongSelf.stateMachine transitionToState:SDLFileManagerStateCheckingQueue];
            }
        }];
    }
}

+ (NSArray<SDLPutFile *> *)sdl_splitFile:(SDLFile *)file {
    NSData *fileData = [file.data copy];
    NSInteger currentOffset = 0;
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
        
        [putFiles addObject:putFile];
    }
    
    return putFiles;
}


#pragma mark - SDL Notification Observers

- (void)sdl_didConnect:(NSNotification *)notification {
    [self.stateMachine transitionToState:SDLFileManagerStateFetchingInitialList];
    SDLListFiles *listFiles = [SDLRPCRequestFactory buildListFilesWithCorrelationID:@0];
    
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequest:listFiles withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (error != nil) {
            // TODO: this is bad
            return;
        }
        
        SDLListFilesResponse *listFilesResponse = (SDLListFilesResponse *)response;
        [strongSelf.mutableRemoteFileNames addObjectsFromArray:listFilesResponse.filenames];
        strongSelf.bytesAvailable = [listFilesResponse.spaceAvailable unsignedIntegerValue];
        
        [strongSelf.stateMachine transitionToState:SDLFileManagerStateCheckingQueue];
    }];
}

- (void)sdl_didDisconnect:(NSNotification *)notification {
    [self.stateMachine transitionToState:SDLFileManagerStateNotConnected];
}

@end


#pragma mark - SDLFileWrapper Helper Class

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


NS_ASSUME_NONNULL_END
