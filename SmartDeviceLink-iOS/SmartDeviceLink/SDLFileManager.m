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

typedef NS_ENUM(NSUInteger, SDLFileManagerState) {
    SDLFileManagerStateNotConnected,
    SDLFileManagerStateReady,
    SDLFileManagerStateWaiting
};


@interface SDLFileWrapper : NSObject

@property (strong, nonatomic, readonly) SDLFile *file;
@property (copy, nonatomic, readonly) SDLFileManagerUploadCompletion completionHandler;

- (instancetype)initWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completionHandler;

+ (instancetype)wrapperWithFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completionHandler;

@end


@interface SDLFileManager ()

@property (weak, nonatomic) id<SDLConnectionManager> connectionManager;

// Remote state
@property (copy, nonatomic, readwrite) NSMutableArray<SDLFileName *> *mutableRemoteFiles;
@property (assign, nonatomic, readwrite) NSUInteger bytesAvailable;

// Local state
@property (copy, nonatomic) NSMutableArray<SDLFileWrapper *> *uploadQueue;
@property (assign, nonatomic) SDLFileManagerState state;
@property (assign, nonatomic) NSUInteger currentFileUploadOffset;

@end


@implementation SDLFileManager

- (instancetype)init {
    return [[self.class alloc] initWithConnectionManager:[SDLManager sharedManager]];
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManager>)manager {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _connectionManager = manager;
    _bytesAvailable = 0;
    _mutableRemoteFiles = [NSMutableArray array];
    _uploadQueue = [NSMutableArray array];
    _state = SDLFileManagerStateNotConnected;
    _currentFileUploadOffset = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didConnect:) name:SDLDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didDisconnect:) name:SDLDidDisconnectNotification object:nil];
    
    return self;
}


#pragma mark - Getters

- (NSArray<SDLFileName *> *)remoteFiles {
    return [self.mutableRemoteFiles copy];
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


#pragma mark - Remote File Manipulation

- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(SDLFileManagerDeleteCompletion)completion {
    SDLDeleteFile *deleteFile = [SDLRPCRequestFactory buildDeleteFileWithName:name correlationID:@0];
    
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequest:deleteFile withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        __strong typeof(self) strongSelf = weakSelf;
        
        // Pull out the parameters
        SDLDeleteFileResponse *deleteFileResponse = (SDLDeleteFileResponse *)response;
        BOOL success = [deleteFileResponse.success boolValue];
        NSInteger bytesAvailable = [deleteFileResponse.spaceAvailable unsignedIntegerValue];
        
        // Mutate self based on the changes
        strongSelf.bytesAvailable = bytesAvailable;
        if (success) {
            [self.mutableRemoteFiles removeObject:name];
        }
        
        // Callback
        completion(success, bytesAvailable, error);
    }];
}

- (void)uploadFile:(SDLFile *)file completionHandler:(SDLFileManagerUploadCompletion)completion {
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

- (void)sdl_sendPutFiles:(NSArray<SDLPutFile *> *)putFiles withCompletion:(SDLFileManagerUploadCompletion)completion {
    __block BOOL stop = NO;
    __block NSError *streamError = nil;
    __block NSUInteger numResponsesReceived = 0;
    __block NSUInteger highestCorrelationID = 0;
    
    __weak typeof(self) weakSelf = self;
    for (SDLPutFile *putFile in putFiles) {
        [self.connectionManager sendRequest:putFile withCompletionHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            __strong typeof(self) strongSelf = weakSelf;
            
            // If we've already encountered an error, then just abort
            if (stop) {
                return;
            }
            
            // If we encounted an error, abort in the future and call the completion handler
            if (error != nil || response == nil) {
                stop = YES;
                streamError = error;
                completion(NO, strongSelf.bytesAvailable, error);
                
                strongSelf.state = SDLFileManagerStateReady;
            }
            
            // If we haven't encounted an error
            SDLPutFileResponse *putFileResponse = (SDLPutFileResponse *)response;
            numResponsesReceived++;
            
            // We need to do this to make sure our bytesAvailable is accurate
            if ([request.correlationID unsignedIntegerValue] > highestCorrelationID) {
                highestCorrelationID = [request.correlationID unsignedIntegerValue];
                strongSelf.bytesAvailable = [putFileResponse.spaceAvailable unsignedIntegerValue];
            }
            
            // If we've received all the responses we're going to receive
            if (putFiles.count == numResponsesReceived) {
                stop = YES;
                completion(YES, strongSelf.bytesAvailable, nil);
                
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
        __strong typeof(self) strongSelf = weakSelf;
        
        if (error != nil) {
            // TODO: this is bad
            return;
        }
        
        SDLListFilesResponse *listFilesResponse = (SDLListFilesResponse *)response;
        strongSelf.mutableRemoteFiles = [listFilesResponse.filenames copy];
        strongSelf.bytesAvailable = [listFilesResponse.spaceAvailable unsignedIntegerValue];
        
        strongSelf.state = SDLFileManagerStateReady;
    }];
}

- (void)sdl_didDisconnect:(NSNotification *)notification {
    // TODO: Reset properties
    self.mutableRemoteFiles = [NSMutableArray array];
    self.bytesAvailable = 0;
    self.uploadQueue = [NSMutableArray array];
    self.state = SDLFileManagerStateNotConnected;
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
