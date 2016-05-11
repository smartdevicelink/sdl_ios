//
//  SDLDeleteFileOperation.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLDeleteFileOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLDeleteFile.h"
#import "SDLDeleteFileResponse.h"
#import "SDLRPCRequestFactory.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLDeleteFileOperation ()

@property (copy, nonatomic) NSString *fileName;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (copy, nonatomic) SDLFileManagerDeleteCompletion completionHandler;

@end


@implementation SDLDeleteFileOperation {
    BOOL executing;
    BOOL finished;
}

- (instancetype)initWithFileName:(NSString *)fileName connectionManager:(id<SDLConnectionManagerType>)connectionManager completionHandler:(nullable SDLFileManagerDeleteCompletion)completionHandler {
    self = [super init];
    if (!self) { return nil; }
    
    _fileName = fileName;
    _connectionManager = connectionManager;
    _completionHandler = completionHandler;
    
    return self;
}

- (void)start {
    if (self.isCancelled || self.isFinished || !self.isExecuting) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        return;
    }
}

- (void)sdl_deleteFile {
    SDLDeleteFile *deleteFile = [SDLRPCRequestFactory buildDeleteFileWithName:self.fileName correlationID:@0];
    
    typeof(self) weakself = self;
    [self.connectionManager sendRequest:deleteFile withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        // Pull out the parameters
        SDLDeleteFileResponse *deleteFileResponse = (SDLDeleteFileResponse *)response;
        BOOL success = [deleteFileResponse.success boolValue];
        NSInteger bytesAvailable = [deleteFileResponse.spaceAvailable unsignedIntegerValue];
        
        // Callback
        if (weakself.completionHandler != nil) {
            weakself.completionHandler(success, bytesAvailable, error);
        }
    }];
}

- (void)sdl_finishOperation {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    executing = NO;
    finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    [self didChangeValueForKey:@"isExecuting"];
}

#pragma mark Property Overrides

- (BOOL)isAsynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

- (nullable NSString *)name {
    return self.fileName;
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}

@end

NS_ASSUME_NONNULL_END