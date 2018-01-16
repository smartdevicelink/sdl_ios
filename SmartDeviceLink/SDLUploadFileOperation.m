//
//  SDLUploadFileOperation.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/11/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLUploadFileOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLError.h"
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

    [self sdl_sendFile:self.fileWrapper.file mtuSize:[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC] withCompletion:self.fileWrapper.completionHandler];
}

/**
 Sends data asynchronously to the SDL Core by breaking the data into smaller packets, each of which is sent via a putfile. To prevent large files from eating up memory, the data packet is deleted once it is sent via a putfile. If the SDL Core receives all the putfiles successfully, a success response with the amount of free storage space left on the SDL Core is returned. Otherwise the error returned by the SDL Core is passed along.

 @param file The file containing the data to be sent to the SDL Core
 @param mtuSize The maximum packet size allowed
 @param completion Closure returning whether or not the upload was a success
 */
- (void)sdl_sendFile:(SDLFile *)file mtuSize:(NSUInteger)mtuSize withCompletion:(SDLFileManagerUploadCompletionHandler)completion  {
    __block NSError *streamError = nil;
    __block NSUInteger bytesAvailable = 0;
    __block NSInteger highestCorrelationIDReceived = -1;

    if (self.isCancelled) {
        return completion(NO, bytesAvailable, [NSError sdl_fileManager_fileUploadCanceled]);
    }

    if (file == nil) {
        return completion(NO, bytesAvailable, [NSError sdl_fileManager_fileDoesNotExistError]);
    }

    self.inputStream = [self sdl_openInputStreamWithFile:file];
    if (self.inputStream == nil || ![self.inputStream hasBytesAvailable]) {
        // If the file does not exist or the passed data is nil, return an error
        [self sdl_closeInputStream];
        return completion(NO, bytesAvailable, [NSError sdl_fileManager_fileDoesNotExistError]);
    }

    dispatch_group_t putFileGroup = dispatch_group_create();
    dispatch_group_enter(putFileGroup);

    // Wait for all packets be sent before returning whether or not the upload was a success
    __weak typeof(self) weakself = self;
    dispatch_group_notify(putFileGroup, dispatch_get_main_queue(), ^{
        typeof(weakself) strongself = weakself;

        [weakself sdl_closeInputStream];
        
        if (streamError != nil || strongself.isCancelled) {
            completion(NO, bytesAvailable, streamError);
        } else {
            completion(YES, bytesAvailable, nil);
        }
        [weakself finishOperation];
    });

    // Break the data into small pieces, each of which will be sent in a separate putfile
    NSUInteger currentOffset = 0;
    for (int i = 0; i < (((file.fileSize - 1) / mtuSize) + 1); i++) {
        dispatch_group_enter(putFileGroup);

        // The putfile's length parameter is based on the current offset
        SDLPutFile *putFile = [[SDLPutFile alloc] initWithFileName:file.name fileType:file.fileType persistentFile:file.isPersistent];
        putFile.offset = @(currentOffset);
        putFile.length = @([self.class sdl_getPutFileLengthForOffset:currentOffset fileSize:file.fileSize mtuSize:mtuSize]);

        // Get a chunk of data from the input stream
        NSUInteger dataSize = [self.class sdl_getDataSizeForOffset:currentOffset fileSize:file.fileSize mtuSize:mtuSize];
        putFile.bulkData = [self.class sdl_getDataChunkWithSize:dataSize inputStream:self.inputStream];
        currentOffset += dataSize;

        __weak typeof(self) weakself = self;
        [self.connectionManager sendManagerRequest:putFile withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
            typeof(weakself) strongself = weakself;

            // Check if the upload process has been cancelled by another packet. If so, stop the upload process.
            // TODO: Is this the right way to handle this case? Should we just abort everything in the future? Should we be deleting what we sent? Should we have an automatic retry strategy based on what the error was?
            if (strongself.isCancelled) {
                dispatch_group_leave(putFileGroup);
                BLOCK_RETURN;
            }

            // If the SDL Core returned an error, cancel the upload the process in the future
            if (error != nil || response == nil || ![response.success boolValue] || strongself.isCancelled) {
                [strongself cancel];
                streamError = error;
                dispatch_group_leave(putFileGroup);
                BLOCK_RETURN;
            }

            // If no errors, watch for a response containing the amount of storage left on the SDL Core
            if ([self.class sdl_newHighestCorrelationID:request highestCorrelationIDReceived:highestCorrelationIDReceived]) {
                highestCorrelationIDReceived = [request.correlationID integerValue];
                bytesAvailable = [(SDLPutFileResponse *)response spaceAvailable].unsignedIntegerValue;
            }

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
    [inputStream open];
    return inputStream;
}
/**
 *  Close the input stream once all the data has been read
 */
- (void)sdl_closeInputStream {
    if (self.inputStream == nil) { return; }
    [self.inputStream close];
}

/**
 Returns the length of the data being sent in the putfile. The first putfile's length is unique in that it sends the full size of the data. For the rest of the putfiles, the length parameter is equal to the size of the chunk of data being sent in the putfile.

 @param currentOffset The current position in the file
 @param fileSize The size of the file
 @param mtuSize The maximum packet size allowed
 @return The the length of the data being sent in the putfile
 */
+ (NSUInteger)sdl_getPutFileLengthForOffset:(NSUInteger)currentOffset fileSize:(unsigned long long)fileSize mtuSize:(NSUInteger)mtuSize {
    NSUInteger putFileLength = 0;
    if (currentOffset == 0) {
        // The first putfile sends the full file size
        putFileLength = fileSize;
    } else if ((fileSize - currentOffset) < mtuSize) {
        // The last putfile sends the size of the remaining data
        putFileLength = fileSize - currentOffset;
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
+ (NSUInteger)sdl_getDataSizeForOffset:(NSUInteger)currentOffset fileSize:(unsigned long long)fileSize mtuSize:(NSUInteger)mtuSize {
    NSUInteger dataSize = 0;
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
+ (nullable NSData *)sdl_getDataChunkWithSize:(NSUInteger)size inputStream:(NSInputStream *)inputStream {
    if (size <= 0) {
        return nil;
    }
    
    Byte buffer[size];
    NSInteger bytesRead = [inputStream read:buffer maxLength:size];
    if (bytesRead) {
        return [[NSData alloc] initWithBytes:(const void*)buffer length:size];
    } else {
        // TODO: return a custom error?
        return nil;
    }
}

/**
 One of the responses returned by the SDL Core will contain the correct remaining free storage size on the SDL Core. Since communication with the SDL Core is asynchronous, there is no way to predict which response contains the correct bytes available other than to watch for the largest correlation id, since that will be the last response sent by the SDL Core.

 @param request The newest response returned by the SDL Core for a putfile
 @param highestCorrelationIDReceived The largest currently received correlation id
 @return Whether or not the newest request contains the highest correlationId
 */
+ (BOOL)sdl_newHighestCorrelationID:(SDLRPCRequest *)request highestCorrelationIDReceived:(NSInteger)highestCorrelationIDReceived {
    if ([request.correlationID integerValue] > highestCorrelationIDReceived) {
        return true;
    }

    return false;
}

#pragma mark - Property Overrides

- (nullable NSString *)name {
    return self.fileWrapper.file.name;
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

@end

NS_ASSUME_NONNULL_END
