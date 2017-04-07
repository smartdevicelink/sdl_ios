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
@property (strong, nonatomic) NSInputStream *inputStream;
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
    [self sendPutFiles:self.fileWrapper.file mtuSize:[SDLGlobals sharedGlobals].maxMTUSize withCompletion:self.fileWrapper.completionHandler];
}

/**
 Sends data asychronously to the SDL Core by breaking the data into smaller pieces, each of which is sent via a putfile. When all sent putfiles are acknowledged by the SDL Core, a closure returns the whether or not the data was uploaded successfully to the SDL Core.

 @param file The file containing the data to be sent to the SDL Core
 @param mtuSize The maximum packet size allowed
 @param completion Closure returning whether or not the upload was a success
 */
- (void)sendPutFiles:(SDLFile *)file mtuSize:(NSUInteger)mtuSize withCompletion:(SDLFileManagerUploadCompletionHandler)completion  {
    // The input stream is used to read data from both files and application memory
    [self openInputStreamWithFile:file];

    dispatch_group_t putFileGroup = dispatch_group_create();
    dispatch_group_enter(putFileGroup);

    __weak typeof(self) weakself = self;
    __block BOOL stop = NO;
    __block NSError *streamError = nil;
    __block NSUInteger bytesAvailable = 0;
    __block NSInteger highestCorrelationIDReceived = -1;

    // Waits for all packets be sent before returning whether or not the upload was a success
    dispatch_group_notify(putFileGroup, dispatch_get_main_queue(), ^{
        if (streamError != nil || stop) {
            completion(NO, bytesAvailable, streamError);
        } else {
            completion(YES, bytesAvailable, nil);
        }
        [weakself finishOperation];
    });

    // Break the data into small pieces, each of which will be sent in a separate putfile
    unsigned long long fileSize = [file fileSize];
    NSUInteger currentOffset = 0;
    unsigned long long numberOfFilesToSend = (((fileSize - 1) / mtuSize) + 1);
    for (int i = 0; i < numberOfFilesToSend; i++) {
        SDLPutFile *putFile = [[SDLPutFile alloc] initWithFileName:file.name fileType:file.fileType persistentFile:file.isPersistent];
        dispatch_group_enter(putFileGroup);

        // The putfile's length parameter is based on the current offset
        putFile.offset = @(currentOffset);
        NSInteger putFileLength = [self getPutFileLengthForOffset:currentOffset fileSize:fileSize mtuSize:mtuSize];
        putFile.length = @(putFileLength);

        // Get a chunk of data from the input stream
        NSUInteger dataSize = [self getDataSizeForOffset:currentOffset fileSize:fileSize mtuSize:mtuSize];
        NSData *dataChunk = [self getDataChunkWithSize:dataSize inputStream:self.inputStream];
        if (dataChunk == nil) {
            stop = YES;
            dispatch_group_leave(putFileGroup);
            break;
        }
        putFile.bulkData = dataChunk;
        currentOffset += dataSize;

        // Send the putfile
        __weak typeof(self) weakself = self;
        [self.connectionManager sendManagerRequest:putFile withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
            typeof(weakself) strongself = weakself;

            // Check if the upload process has been cancelled by another putfile. If it has, stop the upload process and return a completion handler with an unsuccessfull result.
            if (strongself.isCancelled) {
                // TODO: Is this the right way to handle this case? Should we just abort everything in the future? Should we be deleting what we sent? Should we have an automatic retry strategy based on what the error was?
                stop = YES;
            }
            if (stop) {
                dispatch_group_leave(putFileGroup);
                BLOCK_RETURN;
            }

            // If the SDL Core returned an error, cancel the upload the process in the future
            if (error != nil || response == nil || ![response.success boolValue]) {
                stop = YES;
                streamError = error;
                dispatch_group_leave(putFileGroup);
                BLOCK_RETURN;
            }

            // If no errors, wait for all putfiles to return before returning a completion handler with a success result
            SDLPutFileResponse *putFileResponse = (SDLPutFileResponse *)response;

            // The number of bytes available is sent with the last response
            if ([request.correlationID integerValue] > highestCorrelationIDReceived) {
                highestCorrelationIDReceived = [request.correlationID integerValue];
                bytesAvailable = [putFileResponse.spaceAvailable unsignedIntegerValue];
            }

            dispatch_group_leave(putFileGroup);
        }];
    }
    dispatch_group_leave(putFileGroup);
}

- (void)openInputStreamWithFile:(SDLFile *)file {
    self.inputStream = file.inputStream;
    [self.inputStream setDelegate:self];
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
    [self.inputStream open];
}

/**
 Returns the position in the file where to start reading data.

 @param currentOffset The current position in the file
 @param fileSize The size of the file
 @param mtuSize The maximum packet size allowed
 @return The new position in the file where to start reading data
 */
- (NSUInteger)getPutFileLengthForOffset:(NSUInteger)currentOffset fileSize:(unsigned long long)fileSize mtuSize:(NSUInteger)mtuSize {
    NSInteger putFileLength = 0;
    if (currentOffset == 0) {
        // The first putfile sends the full file size
        putFileLength = (NSInteger)fileSize;
    } else if ((fileSize - currentOffset) < mtuSize) {
        // The last putfile sends the size of the remaining data
        putFileLength = (NSInteger)(fileSize - currentOffset);
    } else {
        // All other putfiles send the maximum allowed packet size
        putFileLength = mtuSize;
    }
    return putFileLength;
}

/**
 Gets the size of the data to be sent in a packet. Packet size can not be greater than the max MTU allowed by the SDL Core.

 @param currentOffset The position in the file where to start reading data
 @param fileSize The size of the file
 @param mtuSize The maximum packet size allowed
 @return The size of the data to be sent in the packet.
 */
- (NSUInteger)getDataSizeForOffset:(NSUInteger)currentOffset fileSize:(unsigned long long)fileSize mtuSize:(NSUInteger)mtuSize {
    NSInteger dataSize = 0;
    NSUInteger fileSizeRemaining = (NSUInteger)(fileSize - currentOffset);
    if (fileSizeRemaining < mtuSize) {
        dataSize = fileSizeRemaining;
    } else {
        dataSize = mtuSize;
    }
    return dataSize;
}

/**
 Reads a chunk of data from a socket.

 @param size The amount of data to read from the input stream
 @param inputStream The socket from which to read the data
 @return The data read from the socket
 */
- (nullable NSData *)getDataChunkWithSize:(NSInteger)size inputStream:(NSInputStream *)inputStream {
    uint8_t buffer[size];
    NSInteger bytesRead = [inputStream read:buffer maxLength:size];
    if (bytesRead) {
        NSData *dataChunk = [[NSData alloc] initWithBytes:(const void*)buffer length:size];
        return dataChunk;
    } else {
        // TODO: return a custom error?
        return nil;
    }
}

#pragma mark - Property Overrides

- (nullable NSString *)name {
    return self.fileWrapper.file.name;
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

#pragma mark - NSStreamDelegate

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    switch (eventCode) {
        case NSStreamEventEndEncountered:
            // Close the input stream once all the data has been read
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        default:
            break;
    }
}

@end

NS_ASSUME_NONNULL_END
