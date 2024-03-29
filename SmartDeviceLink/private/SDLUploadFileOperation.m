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
#import "SDLFileManager.h"
#import "SDLFileWrapper.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLPutFile.h"
#import "SDLPutFileResponse.h"
#import "SDLProtocolHeader.h"
#import "SDLRPCResponse.h"
#import "SDLVersion.h"


NS_ASSUME_NONNULL_BEGIN

#pragma mark - SDLUploadFileOperation

/// The size of the binary header, in bytes, for protocol version 2 and greater
static NSUInteger const BinaryHeaderByteSize = 12;
/// The maximum value that can be set for the PutFile's crc property
static NSUInteger const MaxCRCValue = UINT32_MAX;

@interface SDLUploadFileOperation ()

@property (strong, nonatomic, readwrite) SDLFileWrapper *fileWrapper;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (strong, nonatomic) NSInputStream *inputStream;

@end


@implementation SDLUploadFileOperation

- (instancetype)initWithFile:(SDLFileWrapper *)file connectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager {
    self = [super init];
    if (!self) {
        return nil;
    }

    _fileWrapper = file;
    _connectionManager = connectionManager;
    _fileManager = fileManager;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    SDLFile *file = self.fileWrapper.file;

    // HAX: [#827](https://github.com/smartdevicelink/sdl_ios/issues/827) Older versions of Core had a bug where list files would cache incorrectly. This led to attempted uploads failing due to the system thinking they were already there when they were not. This is only needed if connecting to Core v4.3.1 or less which corresponds to RPC v4.3.1 or less
    if (!file.persistent && ![self.fileManager hasUploadedFile:file] && [[SDLGlobals sharedGlobals].rpcVersion isLessThanVersion:[SDLVersion versionWithMajor:4 minor:4 patch:0]]) {
        file.overwrite = YES;
    }

    if (![self.fileManager fileNeedsUpload:file]) {
        SDLLogW(@"File is already on the head unit, aborting upload operation");
        self.fileWrapper.completionHandler(NO, NSNotFound, [NSError sdl_fileManager_cannotOverwriteError]);
        return [self finishOperation];
    }

    [self sdl_sendFile:file mtuSize:[[SDLGlobals sharedGlobals] mtuSizeForServiceType:SDLServiceTypeRPC] withCompletion:self.fileWrapper.completionHandler];
}

/**
 Sends data asynchronously to the SDL Core by breaking the data into smaller packets, each of which is sent via a PutFile. To prevent large files from eating up memory, the data packet is deleted once it is sent via a PutFile. If the SDL Core receives all the PutFiles successfully, a success response with the amount of free storage space left on the SDL Core is returned. Otherwise the error returned by the SDL Core is passed along.

 @param file The file containing the data to be sent to the SDL Core
 @param mtuSize The maximum packet size allowed
 @param completion Closure returning whether or not the upload was a success
 */
- (void)sdl_sendFile:(SDLFile *)file mtuSize:(NSUInteger)mtuSize withCompletion:(SDLFileManagerUploadCompletionHandler)completion {
    __block NSError *streamError = nil;
    __block NSUInteger bytesAvailable = 2000000000;
    __block NSInteger highestCorrelationIDReceived = -1;

    if (file == nil) {
        completion(NO, bytesAvailable, [NSError sdl_fileManager_fileDoesNotExistError]);
        return [self finishOperation];
    }

    self.inputStream = [self sdl_openInputStreamWithFile:file];
    if (self.inputStream == nil || !self.inputStream.hasBytesAvailable) {
        // If the file does not exist or the passed data is nil, return an error
        [self sdl_closeInputStream];

        completion(NO, bytesAvailable, [NSError sdl_fileManager_fileDoesNotExistError]);
        return [self finishOperation];
    }

    dispatch_group_t putFileGroup = dispatch_group_create();
    dispatch_group_enter(putFileGroup);

    // Break the data into small pieces, each of which will be sent in a separate putfile
    NSUInteger maxBulkDataSize = [self.class sdl_getMaxBulkDataSizeForFile:file mtuSize:mtuSize];
    NSUInteger currentOffset = 0;
    NSUInteger numPutFiles = (((file.fileSize - 1) / maxBulkDataSize) + 1);
    for (int i = 0; i < numPutFiles; i++) {
        dispatch_group_enter(putFileGroup);

        // Get a chunk of data from the input stream
        UInt32 putFileLength = (UInt32)[self.class sdl_getPutFileLengthForOffset:currentOffset fileSize:(NSUInteger)file.fileSize bulkDataSize:maxBulkDataSize];
        NSUInteger putFileBulkDataSize = [self.class sdl_getDataSizeForOffset:currentOffset fileSize:file.fileSize bulkDataSize:maxBulkDataSize];
        NSData *putFileBulkData = [self.class sdl_getDataChunkWithSize:putFileBulkDataSize inputStream:self.inputStream];

        SDLPutFile *putFile = [[SDLPutFile alloc]
                               initWithFileName:file.name
                               fileType:file.fileType
                               persistentFile:file.isPersistent
                               systemFile:NO
                               offset:(UInt32)currentOffset
                               length:putFileLength
                               bulkData:putFileBulkData];

        currentOffset += putFileBulkDataSize;

        __weak typeof(self) weakself = self;
        [self.connectionManager sendConnectionManagerRequest:putFile withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
            typeof(weakself) strongself = weakself;
            SDLPutFileResponse *putFileResponse = (SDLPutFileResponse *)response;

            // TODO: Is this the right way to handle this case? Should we just abort everything in the future? Should we be deleting what we sent? Should we have an automatic retry strategy based on what the error was?
            // If the SDL Core returned an error, cancel the upload the process in the future
            if (error != nil || response == nil || !response.success.boolValue || strongself.isCancelled) {
                streamError = error;
                BLOCK_RETURN dispatch_group_leave(putFileGroup);;
            }

            // If no errors, watch for a response containing the amount of storage left on the SDL Core
            if ([self.class sdl_newHighestCorrelationID:request highestCorrelationIDReceived:highestCorrelationIDReceived]) {
                highestCorrelationIDReceived = [request.correlationID integerValue];

                // If spaceAvailable is nil, set it to the max value
                bytesAvailable = putFileResponse.spaceAvailable != nil ? putFileResponse.spaceAvailable.unsignedIntegerValue : 2000000000;
            }

            dispatch_group_leave(putFileGroup);
        }];
    }
    dispatch_group_leave(putFileGroup);

    // Wait for all packets be sent before returning whether or not the upload was a success
    __weak typeof(self) weakself = self;
    dispatch_group_notify(putFileGroup, [SDLGlobals sharedGlobals].sdlProcessingQueue, ^{
        typeof(weakself) strongself = weakself;
        [strongself sdl_closeInputStream];

        if (streamError != nil || strongself.isCancelled) {
            SDLLogE(@"Error sending PutFile RPCs for upload: %@, error: %@", strongself.fileWrapper.file, streamError);
            completion(NO, bytesAvailable, streamError);
        } else {
            completion(YES, bytesAvailable, nil);
        }

        [strongself finishOperation];
    });
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

/// Calculates the max size of the data that can be set in the bulk data field for a PutFile to ensure that if the file data must be broken into chunks and sent in separate PutFiles, each of the PutFiles is sent as a single frame packet. The size of the binary header, JSON, and frame header must be taken into account in order to make sure the packet size does not exceed the max MTU size allowed by SDL Core.
/// 
/// Each RPC packet contains: frame header + payload(binary header + JSON data + bulk data)
/// This means the bulk data size for each packet should not exceed: mtuSize - (binary header size + maximum possible JSON data size + frame header size)
/// @param file The file containing the data to be sent to the SDL Core
/// @param mtuSize The maximum packet size allowed
/// @return The max size of the data that can be set in the bulk data field
+ (NSUInteger)sdl_getMaxBulkDataSizeForFile:(SDLFile *)file mtuSize:(NSUInteger)mtuSize {
    NSUInteger frameHeaderSize = [SDLProtocolHeader headerForVersion:(UInt8)[SDLGlobals sharedGlobals].protocolVersion.major].size;
    NSUInteger binaryHeaderSize = BinaryHeaderByteSize;
    NSUInteger maxJSONSize = [self sdl_getMaxJSONSizeForFile:file];

    return mtuSize - (binaryHeaderSize + maxJSONSize + frameHeaderSize);
}

/// Calculates the max possible (i.e. it may be larger than the actual JSON data generated) size of the JSON data generated for a PutFile request.
/// @param file The file to be sent to the module
/// @return The max possible size of the JSON data
+ (NSUInteger)sdl_getMaxJSONSizeForFile:(SDLFile *)file {
    SDLPutFile *putFile = [[SDLPutFile alloc] initWithFileName:file.name fileType:file.fileType persistentFile:file.persistent systemFile:NO offset:(UInt32)file.fileSize length:(UInt32)file.fileSize bulkData:file.data];
    putFile.crc = @(MaxCRCValue);

    NSError *JSONSerializationError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[putFile serializeAsDictionary:(Byte)[SDLGlobals sharedGlobals].protocolVersion.major] options:kNilOptions error:&JSONSerializationError];
    if (JSONSerializationError != nil) {
        SDLLogW(@"Error attempting to get JSON data for PutFile: %@", putFile);
        return 0;
    }

    return jsonData.length;
}

/**
 Returns the length of the data being sent in the putfile. The first putfile's length is unique in that it sends the full size of the data. For the rest of the putfiles, the length parameter is equal to the size of the chunk of data being sent in the putfile.

 @param currentOffset The current position in the file
 @param fileSize The size of the file
 @param bulkDataSize The maximum size of the bulk data that can be sent in the PutFile
 @return The the length of the data being sent in the putfile
 */
+ (NSUInteger)sdl_getPutFileLengthForOffset:(NSUInteger)currentOffset fileSize:(NSUInteger)fileSize bulkDataSize:(NSUInteger)bulkDataSize {
    NSUInteger putFileLength = 0;
    if (currentOffset == 0) {
        // The first putfile sends the full file size
        putFileLength = fileSize;
    } else if ((fileSize - currentOffset) < bulkDataSize) {
        // The last putfile sends the size of the remaining data
        putFileLength = fileSize - currentOffset;
    } else {
        // All other putfiles send the maximum allowed packet size
        putFileLength = bulkDataSize;
    }
    return putFileLength;
}

/**
 Gets the size of the data to be sent in a packet. Packet size can not be greater than the max MTU size allowed by the SDL Core.

 @param currentOffset The position in the file where to start reading data
 @param fileSize The size of the file
 @param bulkDataSize The maximum size of the bulk data that can be sent in the putfile
 @return The size of the data to be sent in the packet.
 */
+ (NSUInteger)sdl_getDataSizeForOffset:(NSUInteger)currentOffset fileSize:(unsigned long long)fileSize bulkDataSize:(NSUInteger)bulkDataSize {
    NSUInteger dataSize = 0;
    NSUInteger fileSizeRemaining = (NSUInteger)(fileSize - currentOffset);
    if (fileSizeRemaining < bulkDataSize) {
        dataSize = fileSizeRemaining;
    } else {
        dataSize = bulkDataSize;
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
    return [NSString stringWithFormat:@"%@ - %@", self.class, self.fileWrapper.file.name];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

@end

NS_ASSUME_NONNULL_END
