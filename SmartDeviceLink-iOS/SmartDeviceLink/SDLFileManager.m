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

#pragma mark - SDLFileWrapper class struct

@interface SDLFileWrapper : NSObject

@property (strong, nonatomic, readonly) SDLFile *file;
@property (copy, nonatomic, readonly) SDLFileManagerUploadCompletion completionHandler;

- (instancetype)initWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completionHandler;

+ (instancetype)wrapperWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completionHandler;

@end


#pragma mark - SDLFileManager class

@interface SDLFileManager ()

@property (weak, nonatomic) id<SDLConnectionManager> connectionManager;

// Remote state
@property (copy, nonatomic, readwrite) NSMutableSet<SDLFileName *> *mutableRemoteFileNames;
@property (assign, nonatomic, readwrite) NSUInteger bytesAvailable;

// Local state
@property (copy, nonatomic) NSMutableArray<SDLFileWrapper *> *uploadQueue;
@property (assign, nonatomic, readwrite) SDLFileManagerState state;
@property (assign, nonatomic) NSUInteger currentFileUploadOffset;

@end


@implementation SDLFileManager

- (instancetype)init {
    return [self initWithConnectionManager:[SDLManager sharedManager]];
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManager>)manager {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _connectionManager = manager;
    _bytesAvailable = 0;
    _allowOverwrite = NO;
    
    _mutableRemoteFileNames = [NSMutableSet set];
    _uploadQueue = [NSMutableArray array];
    _state = SDLFileManagerStateNotConnected;
    _currentFileUploadOffset = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didConnect:) name:SDLDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didDisconnect:) name:SDLDidDisconnectNotification object:nil];
    
    return self;
}


#pragma mark - Getters

- (NSSet<SDLFileName *> *)remoteFileNames {
    return [self.mutableRemoteFileNames copy];
}


#pragma mark - Setters

- (void)setState:(SDLFileManagerState)state {
    _state = state;
    
    switch (state) {
        case SDLFileManagerStateReady: {
            if (self.uploadQueue.count != 0) {
                SDLFileWrapper *wrapper = [self.uploadQueue firstObject];
                [self.uploadQueue removeObjectAtIndex:0];
                [self uploadFile:wrapper.file completionHandler:wrapper.completionHandler];
            }
        } break;
        default: return;
    }
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
    switch (self.state) {
            // Not connected state will fail on attempting to send
        case SDLFileManagerStateReady:
        case SDLFileManagerStateNotConnected: {
            self.state = SDLFileManagerStateWaiting;
            
            NSArray<SDLPutFile *> *putFiles = [self.class sdl_splitFile:file];
            [self sdl_sendPutFiles:putFiles withCompletion:completion];
        } break;
        case SDLFileManagerStateWaiting: {
            [self.uploadQueue addObject:[SDLFileWrapper wrapperWithFile:file completionHandler:completion]];
        } break;
    }
}

- (void)sdl_sendPutFiles:(NSArray<SDLPutFile *> *)putFiles withCompletion:(nullable SDLFileManagerUploadCompletion)completion {
    __block BOOL stop = NO;
    __block NSError *streamError = nil;
    __block NSUInteger numResponsesReceived = 0;
    __block NSInteger highestCorrelationIDReceived = -1;
    
    __weak typeof(self) weakSelf = self;
    for (SDLPutFile *putFile in putFiles) {
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
                strongSelf.state = SDLFileManagerStateReady;
                
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
                
                strongSelf.state = SDLFileManagerStateReady;
            }
        }];
    }
}

+ (NSArray<SDLPutFile *> *)sdl_splitFile:(SDLFile *)file {
    NSData *fileData = [file.data copy];
    NSInteger currentOffset = 0;
    NSMutableArray<SDLPutFile *> *putFiles = [NSMutableArray array];
    
    for (int i = 0; i < ((fileData.length / [SDLGlobals globals].maxMTUSize) + 1); i++){
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
    self.state = SDLFileManagerStateWaiting;
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
        
        strongSelf.state = SDLFileManagerStateReady;
    }];
}

- (void)sdl_didDisconnect:(NSNotification *)notification {
    [self.mutableRemoteFileNames removeAllObjects];
    self.bytesAvailable = 0;
    [self.uploadQueue removeAllObjects];
    self.state = SDLFileManagerStateNotConnected;
    self.currentFileUploadOffset = 0;
}

@end


#pragma mark - SDLFileWrapper Helper

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
