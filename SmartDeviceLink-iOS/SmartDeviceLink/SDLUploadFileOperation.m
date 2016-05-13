//
//  SDLUploadFileOperation.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLUploadFileOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLFile.h"
#import "SDLFileWrapper.h"
#import "SDLGlobals.h"
#import "SDLPutFile.h"
#import "SDLPutFileResponse.h"
#import "SDLRPCResponse.h"
#import "SDLRPCRequestFactory.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark - SDLUploadFileOperation

@interface SDLUploadFileOperation () {
    BOOL executing;
    BOOL finished;
}

@property (strong, nonatomic) SDLFileWrapper *fileWrapper;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

@end


@implementation SDLUploadFileOperation

- (instancetype)initWithFile:(SDLFileWrapper *)file connectionManager:(id<SDLConnectionManagerType>)connectionManager {
    self = [super init];
    if (!self) { return nil; }
    
    executing = NO;
    finished = NO;
    
    _fileWrapper = file;
    _connectionManager = connectionManager;
    
    return self;
}

- (void)start {
    if (self.isCancelled || self.isFinished || !self.isExecuting) {
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        
        return;
    }
    
    [self sdl_sendPutFiles:[self.class sdl_splitFile:self.fileWrapper.file] withCompletion:self.fileWrapper.completionHandler];
}

- (void)sdl_sendPutFiles:(NSArray<SDLPutFile *> *)putFiles withCompletion:(SDLFileManagerUploadCompletion)completion {
    __block BOOL stop = NO;
    __block NSError *streamError = nil;
    __block NSUInteger bytesAvailable = 0;
    __block NSInteger highestCorrelationIDReceived = -1;
    
    dispatch_group_t putFileGroup = dispatch_group_create();
    dispatch_group_enter(putFileGroup);
    
    // When the putfiles all complete, run this block
    dispatch_group_notify(putFileGroup, dispatch_get_main_queue(), ^{
        [self sdl_finishOperation];
        
        if (streamError != nil) {
            completion(NO, bytesAvailable, streamError);
        } else {
            completion(YES, bytesAvailable, nil);
        }
    });
    
    for (SDLPutFile *putFile in putFiles) {
        dispatch_group_enter(putFileGroup);
        __weak typeof(self) weakself = self;
        [self.connectionManager sendRequest:putFile withCompletionHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {
            typeof(weakself) strongself = weakself;
            // If we've already encountered an error, then just abort
            // TODO: Is this the right way to handle this case? Should we just abort everything in the future? Should we be deleting what we sent? Should we have an automatic retry strategy based on what the error was?
            if (strongself.isCancelled) {
                stop = YES;
            }
            
            if (stop) {
                dispatch_group_leave(putFileGroup);
                BLOCK_RETURN;
            }
            
            // If we encounted an error, abort in the future and call the completion handler
            if (error != nil || response == nil || ![response.success boolValue]) {
                stop = YES;
                streamError = error;
                
                if (completion != nil) {
                    completion(NO, 0, error);
                }
                
                dispatch_group_leave(putFileGroup);
                BLOCK_RETURN;
            }
            
            // If we haven't encounted an error
            SDLPutFileResponse *putFileResponse = (SDLPutFileResponse *)response;
            
            // We need to do this to make sure our bytesAvailable is accurate
            if ([request.correlationID integerValue] > highestCorrelationIDReceived) {
                highestCorrelationIDReceived = [request.correlationID integerValue];
                bytesAvailable = [putFileResponse.spaceAvailable unsignedIntegerValue];
            }
            
            dispatch_group_leave(putFileGroup);
        }];
    }
    
    dispatch_group_leave(putFileGroup);
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
    return self.fileWrapper.file.name;
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

@end

NS_ASSUME_NONNULL_END
