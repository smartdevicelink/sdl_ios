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


NS_ASSUME_NONNULL_BEGIN

#pragma mark - SDLUploadFileOperation

@interface SDLUploadFileOperation ()

@property (strong, nonatomic) SDLFileWrapper *fileWrapper;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;

@end


@implementation SDLUploadFileOperation {
    BOOL executing;
    BOOL finished;
}

- (instancetype)initWithFile:(SDLFileWrapper *)file connectionManager:(id<SDLConnectionManagerType>)connectionManager {
    self = [super init];
    if (!self) {
        return nil;
    }

    executing = NO;
    finished = NO;

    _fileWrapper = file;
    _connectionManager = connectionManager;

    return self;
}

- (void)start {
    [super start];

    [self sdl_sendPutFiles:[self.class sdl_splitFile:self.fileWrapper.file mtuSize:[[SDLGlobals globals] mtuSizeForServiceType:SDLServiceType_RPC]] withCompletion:self.fileWrapper.completionHandler];
}

- (void)sdl_sendPutFiles:(NSArray<SDLPutFile *> *)putFiles withCompletion:(SDLFileManagerUploadCompletionHandler)completion {
    __block NSError *streamError = nil;
    __block NSUInteger bytesAvailable = 0;
    __block NSInteger highestCorrelationIDReceived = -1;

    dispatch_group_t putFileGroup = dispatch_group_create();
    dispatch_group_enter(putFileGroup);

    // When the putfiles all complete, run this block
    __weak typeof(self) weakself = self;
    dispatch_group_notify(putFileGroup, dispatch_get_main_queue(), ^{
        typeof(weakself) strongself = weakself;
        if (streamError != nil || strongself.isCancelled) {
            completion(NO, bytesAvailable, streamError);
        } else {
            completion(YES, bytesAvailable, nil);
        }

        [weakself finishOperation];
    });

    for (SDLPutFile *putFile in putFiles) {
        dispatch_group_enter(putFileGroup);
        __weak typeof(self) weakself = self;
        [self.connectionManager sendManagerRequest:putFile
                               withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
                                   typeof(weakself) strongself = weakself;
                                   // TODO: Is this the right way to handle this case? Should we just abort everything in the future? Should we be deleting what we sent? Should we have an automatic retry strategy based on what the error was?
                                   if (strongself.isCancelled) {
                                       dispatch_group_leave(putFileGroup);
                                       BLOCK_RETURN;
                                   }

                                   // If we encounted an error, abort in the future and call the completion handler
                                   if (error != nil || response == nil || ![response.success boolValue] || strongself.isCancelled) {
                                       [strongself cancel];
                                       streamError = error;

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

+ (NSArray<SDLPutFile *> *)sdl_splitFile:(SDLFile *)file mtuSize:(NSUInteger)mtuSize {
    NSData *fileData = [file.data copy];
    NSUInteger currentOffset = 0;
    NSMutableArray<SDLPutFile *> *putFiles = [NSMutableArray array];

    // http://stackoverflow.com/a/503201 Make sure we get the exact number of packets we need
    for (int i = 0; i < (((fileData.length - 1) / mtuSize) + 1); i++) {
        SDLPutFile *putFile = [[SDLPutFile alloc] initWithFileName:file.name fileType:file.fileType persistentFile:file.isPersistent];
        putFile.offset = @(currentOffset);

        // Set the length putfile based on the offset
        if (currentOffset == 0) {
            // If the offset is 0, the putfile expects to have the full file length within it
            putFile.length = @(fileData.length);
        } else if ((fileData.length - currentOffset) < mtuSize) {
            // The file length remaining is less than our total MTU size, so use the file length remaining
            putFile.length = @(fileData.length - currentOffset);
        } else {
            // The file length remaining is greater than our total MTU size, and the offset is not zero, we will fill the packet with our max MTU size
            putFile.length = @(mtuSize);
        }

        // Place the data and set the new offset
        if (currentOffset == 0 && (mtuSize < [putFile.length unsignedIntegerValue])) {
            putFile.bulkData = [fileData subdataWithRange:NSMakeRange(currentOffset, mtuSize)];
            currentOffset = mtuSize;
        } else {
            putFile.bulkData = [fileData subdataWithRange:NSMakeRange(currentOffset, [putFile.length unsignedIntegerValue])];
            currentOffset += [putFile.length unsignedIntegerValue];
        }

        [putFiles addObject:putFile];
    }

    return putFiles;
}


#pragma mark Property Overrides

- (nullable NSString *)name {
    return self.fileWrapper.file.name;
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

@end

NS_ASSUME_NONNULL_END
