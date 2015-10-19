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
#import "SDLListFiles.h"
#import "SDLListFilesResponse.h"
#import "SDLManager.h"
#import "SDLNotificationConstants.h"
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
    self = [super init];
    if (!self) {
        return nil;
    }
    
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
        default: {
            return;
        } break;
    }
}


#pragma mark - Remote File Manipulation

- (void)deleteRemoteFileWithName:(SDLFileName *)name completionHandler:(SDLFileManagerDeleteCompletion)completion {
    SDLDeleteFile *deleteFile = [SDLRPCRequestFactory buildDeleteFileWithName:name correlationID:@0];
    
    __weak typeof(self) weakSelf = self;
    [[SDLManager sharedManager] sendRequest:deleteFile withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
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
        case SDLFileManagerStateReady: {
            self.state = SDLFileManagerStateWaiting;
            
            SDLPutFile *putFile = [SDLRPCRequestFactory buildPutFileWithFileName:file.name fileType:file.fileType persistentFile:@(file.isPersistent) correlationId:@0];
        } break;
        case SDLFileManagerStateWaiting: {
            [self.uploadQueue addObject:[SDLFileWrapper wrapperWithFile:file completionHandler:completion]];
        } break;
    }
}


#pragma mark - SDL Notification Observers

- (void)sdl_didConnect:(NSNotification *)notification {
    self.state = SDLFileManagerStateWaiting;
    SDLListFiles *listFiles = [SDLRPCRequestFactory buildListFilesWithCorrelationID:@0];
    
    __weak typeof(self) weakSelf = self;
    [[SDLManager sharedManager] sendRequest:listFiles withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
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
