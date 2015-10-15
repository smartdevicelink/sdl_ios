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

@interface SDLFileManager ()

@property (copy, nonatomic, readwrite) NSArray<SDLFileName *> *remoteFiles;
@property (assign, nonatomic, readwrite) NSUInteger bytesAvailable;

@property (copy, nonatomic) NSMutableArray *uploadQueue;
@property (assign, nonatomic) SDLFileManagerState state;

@end


@implementation SDLFileManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _remoteFiles = @[];
    _bytesAvailable = 0;
    _uploadQueue = [NSMutableArray array];
    _state = SDLFileManagerStateNotConnected;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didConnect:) name:SDLDidConnectNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_didDisconnect:) name:SDLDidDisconnectNotification object:nil];
    
    return self;
}


#pragma mark - Remote File Manipulation

- (void)deleteRemoteFileWithName:(SDLFileName *)name {
    SDLDeleteFile *deleteFile = [SDLRPCRequestFactory buildDeleteFileWithName:name correlationID:@0];
    
    [[SDLManager sharedManager] sendRequest:deleteFile withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        if (error != nil) {
            // TODO:
            return;
        }
        
//        SDLDeleteFileResponse *deleteFileResponse = (SDLDeleteFileResponse *)response;
//        BOOL success = deleteFileResponse.success.boolValue; TODO: Do anything with this? Optional completion block?
    }];
}


#pragma mark - SDL Notification Observers

- (void)sdl_didConnect:(NSNotification *)notification {
    // TODO: List files
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
        strongSelf.remoteFiles = [listFilesResponse.filenames copy];
        strongSelf.bytesAvailable = listFilesResponse.spaceAvailable.unsignedIntegerValue;
        
        strongSelf.state = SDLFileManagerStateReady;
    }];
}

- (void)sdl_didDisconnect:(NSNotification *)notification {
    // TODO: Reset properties
    self.remoteFiles = @[];
    self.bytesAvailable = 0;
    self.uploadQueue = [NSMutableArray array];
    self.state = SDLFileManagerStateNotConnected;
}

@end

NS_ASSUME_NONNULL_END
