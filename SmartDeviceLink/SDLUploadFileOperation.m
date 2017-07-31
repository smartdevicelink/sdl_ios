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
    [self sdl_sendPutFiles:self.fileWrapper.file mtuSize:[SDLGlobals sharedGlobals].maxMTUSize withCompletion:self.fileWrapper.completionHandler];
}

/**
 Sends data asychronously to the SDL Core by breaking the data into smaller packets, each of which is sent via a putfile. To prevent large files from eating up memory, the data packet is deleted once it is sent via a putfile. If the SDL Core receives all the putfiles successfully, a success response with the amount of free storage space left on the SDL Core is returned. Otherwise the error returned by the SDL Core is passed along.

 @param file The file containing the data to be sent to the SDL Core
 @param mtuSize The maximum packet size allowed
 @param completion Closure returning whether or not the upload was a success
 */
- (void)sdl_sendPutFiles:(SDLFile *)file mtuSize:(NSUInteger)mtuSize withCompletion:(SDLFileManagerUploadCompletionHandler)completion  {
    __block BOOL stop = NO;
    __block NSError *streamError = nil;
    __block NSUInteger bytesAvailable = 0;
    __block NSInteger highestCorrelationIDReceived = -1;

    dispatch_group_t putFileGroup = dispatch_group_create();
    dispatch_group_enter(putFileGroup);

    // Waits for all packets be sent before returning whether or not the upload was a success
    __weak typeof(self) weakself = self;
    dispatch_group_notify(putFileGroup, dispatch_get_main_queue(), ^{
        if (streamError != nil || stop) {
            completion(NO, bytesAvailable, streamError);
        } else {
            completion(YES, bytesAvailable, nil);
        }
        [weakself finishOperation];
    });

    NSInputStream *inputStream = [self sdl_openInputStreamWithFile:file];

    // Break the data into small pieces, each of which will be sent in a separate putfile
    unsigned long long fileSize = [file fileSize];
    NSUInteger currentOffset = 0;
    unsigned long long numberOfFilesToSend = (((fileSize - 1) / mtuSize) + 1);
    for (int i = 0; i < numberOfFilesToSend; i++) {
        SDLPutFile *putFile = [[SDLPutFile alloc] initWithFileName:file.name fileType:file.fileType persistentFile:file.isPersistent];
        dispatch_group_enter(putFileGroup);

        // The putfile's length parameter is based on the current offset
        putFile.offset = @(currentOffset);
        NSInteger putFileLength = [self sdl_getPutFileLengthForOffset:currentOffset fileSize:fileSize mtuSize:mtuSize];
        putFile.length = @(putFileLength);

        // Get a chunk of data from the input stream
        NSUInteger dataSize = [self sdl_getDataSizeForOffset:currentOffset fileSize:fileSize mtuSize:mtuSize];
        NSData *dataChunk = [self sdl_getDataChunkWithSize:dataSize inputStream:inputStream];
        putFile.bulkData = dataChunk;
        currentOffset += dataSize;

        // Send the putfile
        __weak typeof(self) weakself = self;
        [self.connectionManager sendManagerRequest:putFile withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
            typeof(weakself) strongself = weakself;

            // Once putfile has been sent, delete the data to free up memory
            @autoreleasepool {
                putFile.bulkData = nil;
            }

            // Check if the upload process has been cancelled by another packet. If so, stop the upload process.
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

            // If no errors, watch for a response containing the amount of storage left on the SDL Core
            SDLPutFileResponse *putFileResponse = (SDLPutFileResponse *)response;
            bytesAvailable = [self sdl_getBytesAvailableFromResponse:putFileResponse request:request highestCorrelationIDReceived:highestCorrelationIDReceived currentBytesAvailable:bytesAvailable];

            dispatch_group_leave(putFileGroup);
        }];
    }
    dispatch_group_leave(putFileGroup);
}

/**
 Opens a socket for reading data.

 @param file The file containing the data or the file url of the data
 */
- (NSInputStream *)sdl_openInputStreamWithFile:(SDLFile *)file {
    NSInputStream *inputStream = file.inputStream;
    [inputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                                forMode:NSDefaultRunLoopMode];
    [inputStream open];
    return inputStream;
}

/**
 Returns the position in the file where to start reading data.

 @param currentOffset The current position in the file
 @param fileSize The size of the file
 @param mtuSize The maximum packet size allowed
 @return The new position in the file where to start reading data
 */
- (NSUInteger)sdl_getPutFileLengthForOffset:(NSUInteger)currentOffset fileSize:(unsigned long long)fileSize mtuSize:(NSUInteger)mtuSize {
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
 Gets the size of the data to be sent in a packet. Packet size can not be greater than the max MTU size allowed by the SDL Core.

 @param currentOffset The position in the file where to start reading data
 @param fileSize The size of the file
 @param mtuSize The maximum packet size allowed
 @return The size of the data to be sent in the packet.
 */
- (NSUInteger)sdl_getDataSizeForOffset:(NSUInteger)currentOffset fileSize:(unsigned long long)fileSize mtuSize:(NSUInteger)mtuSize {
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
- (nullable NSData *)sdl_getDataChunkWithSize:(NSInteger)size inputStream:(NSInputStream *)inputStream {
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

/**
 One of the reponses returned by the SDL Core will contain the correct remaining free storage size on the SDL Core. Since communication with the SDL Core is asychronous, there is no way to predict which response contains the correct bytes available other than to watch for the largest correlation id, since that will be the last reponse sent by the SDL Core.

 @param putFileResponse The response sent by the SDL Core after a putfile is sent
 @param request The correlation id for the response
 @param highestCorrelationIDReceived The largest received correlation id
 @param currentBytesAvailable The current number bytes available
 @return The amount of storage space left on the SDL Core
 */
- (NSInteger)sdl_getBytesAvailableFromResponse:(SDLPutFileResponse *)putFileResponse request:(nullable SDLRPCRequest *)request highestCorrelationIDReceived:(NSInteger)highestCorrelationIDReceived currentBytesAvailable:(NSInteger)currentBytesAvailable  {
    // The number of bytes available is sent with the last response
    if ([request.correlationID integerValue] > highestCorrelationIDReceived) {
        highestCorrelationIDReceived = [request.correlationID integerValue];
        return [putFileResponse.spaceAvailable unsignedIntegerValue];
    }
    return currentBytesAvailable;
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
