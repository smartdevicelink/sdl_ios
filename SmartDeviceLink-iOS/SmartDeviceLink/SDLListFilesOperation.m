//
//  SDLListFilesOperation.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/25/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLListFilesOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLListFiles.h"
#import "SDLListFilesResponse.h"
#import "SDLRPCRequestFactory.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLListFilesOperation ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (copy, nonatomic, nullable) SDLFileManagerListFilesCompletion completionHandler;

@end


@implementation SDLListFilesOperation {
    BOOL executing;
    BOOL finished;
}

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager completionHandler:(nullable SDLFileManagerListFilesCompletion)completionHandler {
    self = [super init];
    if (!self) { return nil; }
    
    _connectionManager = connectionManager;
    _completionHandler = completionHandler;
    
    return self;
}

- (void)start {
    if (self.isCancelled) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [self sdl_listFiles];
}

- (void)sdl_listFiles {
    SDLListFiles *listFiles = [SDLRPCRequestFactory buildListFilesWithCorrelationID:@0];
    
    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendRequest:listFiles withCompletionHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        SDLListFilesResponse *listFilesResponse = (SDLListFilesResponse *)response;
        BOOL success = [listFilesResponse.success boolValue];
        NSUInteger bytesAvailable = [listFilesResponse.spaceAvailable unsignedIntegerValue];
        NSArray<NSString *> *fileNames = [NSArray arrayWithArray:listFilesResponse.filenames];
        
        if (weakSelf.completionHandler != nil) {
            weakSelf.completionHandler(success, bytesAvailable, fileNames, error);
        }
        
        [weakSelf sdl_finishOperation];
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
    return @"List Files";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}

@end

NS_ASSUME_NONNULL_END