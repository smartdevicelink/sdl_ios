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

    [self sendPutFiles:self.fileWrapper.file mtuSize:[SDLGlobals sharedGlobals].maxMTUSize withCompletion:self.fileWrapper.completionHandler];
    // [self sdl_sendPutFiles:[self.class sdl_splitFile:self.fileWrapper.file mtuSize:[SDLGlobals sharedGlobals].maxMTUSize] withCompletion:self.fileWrapper.completionHandler];
}

- (void)sendPutFiles:(SDLFile *)file mtuSize:(NSUInteger)mtuSize withCompletion:(SDLFileManagerUploadCompletionHandler)completion  {
    NSInputStream *inputStream = [self openInputStreamWithFile:file];

    // Wait for all data chunks be sent before considering executing the code in dispatch_group_notify
    dispatch_group_t putFileGroup = dispatch_group_create();
    dispatch_group_enter(putFileGroup);
    __weak typeof(self) weakself = self;
    __block BOOL stop = NO;
    __block NSError *streamError = nil;
    __block NSUInteger bytesAvailable = 0;
    __block NSInteger highestCorrelationIDReceived = -1;
    dispatch_group_notify(putFileGroup, dispatch_get_main_queue(), ^{
        // Let user know if data was sent to the SDL Core successfully
        if (streamError != nil || stop) {
            completion(NO, bytesAvailable, streamError);
        } else {
            completion(YES, bytesAvailable, nil);
        }
        [weakself finishOperation];
    });

    // Break the data into small chunks, each of which will be sent in a separate putfile
    unsigned long long fileSize = [file fileSize];
    NSUInteger currentOffset = 0;
    unsigned long long numberOfFilesToSend = (((fileSize - 1) / mtuSize) + 1);
    for (int i = 0; i < numberOfFilesToSend; i++) {
        SDLPutFile *putFile = [[SDLPutFile alloc] initWithFileName:file.name fileType:file.fileType persistentFile:file.isPersistent];
        putFile.offset = @(currentOffset);

        // The putfile's length parameter is based on the current offset
        NSInteger putFileLength = [self getPutFileLengthForOffset:currentOffset fileSize:fileSize mtuSize:mtuSize];
        putFile.length = @(putFileLength);

        // Retrieve a chunk of data from the input stream
        NSError *error = nil;
        NSData *dataChunk = [self getDataChunkWithSize:putFileLength inputStream:inputStream error:&error];
        if (dataChunk == nil) {
            return completion(NO, bytesAvailable, streamError);
        }
        putFile.bulkData = [self getDataChunkWithSize:putFileLength inputStream:inputStream error:&error];
        currentOffset += putFileLength;

        // Send the putfile
        dispatch_group_enter(putFileGroup);
        __weak typeof(self) weakself = self;
        [self.connectionManager sendManagerRequest:putFile withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
            typeof(weakself) strongself = weakself;

            // FIXME: - not a a good idea if data needs to be resent
            // Data is no longer needed
            @autoreleasepool {
                putFile.bulkData = nil;
            }

            // If there is an error, cancel sending the rest of the data
            if (strongself.isCancelled) {
                stop = YES;
            }
            if (stop) {
                dispatch_group_leave(putFileGroup);
                BLOCK_RETURN;
            }
            // If there is an error, abort in the future and call the completion handler
            if (error != nil || response == nil || ![response.success boolValue]) {
                stop = YES;
                streamError = error;
                dispatch_group_leave(putFileGroup);
                BLOCK_RETURN;
            }

            // If no error make sure bytes availabe is accurate
            SDLPutFileResponse *putFileResponse = (SDLPutFileResponse *)response;
            if ([request.correlationID integerValue] > highestCorrelationIDReceived) {
                highestCorrelationIDReceived = [request.correlationID integerValue];
                bytesAvailable = [putFileResponse.spaceAvailable unsignedIntegerValue];
            }
            dispatch_group_leave(putFileGroup);
       }];
    }

    dispatch_group_leave(putFileGroup);
}

- (NSInputStream *)openInputStreamWithFile:(SDLFile *)file {
    NSInputStream *inputStream = file.inputStream;
    [inputStream setDelegate:self];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    return inputStream;
}

- (NSUInteger)getPutFileLengthForOffset:(NSUInteger)currentOffset fileSize:(unsigned long long)fileSize mtuSize:(NSUInteger)mtuSize {
    NSInteger putFileLength = 0;
    if (currentOffset == 0) {
        // If the offset is 0, the putfile expects to have the full file size.
        putFileLength = (NSInteger)fileSize;
    } else if ((fileSize - currentOffset) < mtuSize) {
        // The file length remaining is smaller than the max data chunk sized allowed. The putfile expects the length parameter to match the size of the last data chunk being sent.
        putFileLength = (NSInteger)(fileSize - currentOffset);
    } else {
        // When the file length remaining is greater than the max data chunk sized allowed, and the offset is not zero, the putfile expects the length parameter to match the size of the data chunk being sent.
        putFileLength = mtuSize;
    }
    return putFileLength;
}

- (nullable NSData *)getDataChunkWithSize:(NSInteger)size inputStream:(NSInputStream *)inputStream error:(NSError **)error {
    uint8_t buffer[size];
    NSInteger bytesRead = [inputStream read:buffer maxLength:size];
    if (bytesRead) {
        // Return the bytes read into the buffer
        NSData *dataChunk = [[NSData alloc] initWithBytes:(const void*)buffer length:size];
        return dataChunk;
    } else {
        NSLog(@"nothing was read from the input stream");
        if (error) {
            // TODO: return error
        }
        return nil;
    }
}

//- (void)sdl_sendPutFiles:(NSArray<SDLPutFile *> *)putFiles withCompletion:(SDLFileManagerUploadCompletionHandler)completion {
//    __block BOOL stop = NO;
//    __block NSError *streamError = nil;
//    __block NSUInteger bytesAvailable = 0;
//    __block NSInteger highestCorrelationIDReceived = -1;
//
//    dispatch_group_t putFileGroup = dispatch_group_create();
//    dispatch_group_enter(putFileGroup);
//
//    // When the putfiles all complete, run this block
//    __weak typeof(self) weakself = self;
//    dispatch_group_notify(putFileGroup, dispatch_get_main_queue(), ^{
//        if (streamError != nil || stop) {
//            completion(NO, bytesAvailable, streamError);
//        } else {
//            completion(YES, bytesAvailable, nil);
//        }
//
//        [weakself finishOperation];
//    });
//
//    for (SDLPutFile *putFile in putFiles) {
//        dispatch_group_enter(putFileGroup);
//        __weak typeof(self) weakself = self;
//        [self.connectionManager sendManagerRequest:putFile
//                               withResponseHandler:^(__kindof SDLRPCRequest *_Nullable request, __kindof SDLRPCResponse *_Nullable response, NSError *_Nullable error) {
//                                   typeof(weakself) strongself = weakself;
//                                   // If we've already encountered an error, then just abort
//                                   // TODO: Is this the right way to handle this case? Should we just abort everything in the future? Should we be deleting what we sent? Should we have an automatic retry strategy based on what the error was?
//                                   if (strongself.isCancelled) {
//                                       stop = YES;
//                                   }
//
//                                   if (stop) {
//                                       dispatch_group_leave(putFileGroup);
//                                       BLOCK_RETURN;
//                                   }
//
//                                   // If we encounted an error, abort in the future and call the completion handler
//                                   if (error != nil || response == nil || ![response.success boolValue]) {
//                                       stop = YES;
//                                       streamError = error;
//                                       
//                                       dispatch_group_leave(putFileGroup);
//                                       BLOCK_RETURN;
//                                   }
//
//                                   // If we haven't encounted an error
//                                   SDLPutFileResponse *putFileResponse = (SDLPutFileResponse *)response;
//
//                                   // We need to do this to make sure our bytesAvailable is accurate
//                                   if ([request.correlationID integerValue] > highestCorrelationIDReceived) {
//                                       highestCorrelationIDReceived = [request.correlationID integerValue];
//                                       bytesAvailable = [putFileResponse.spaceAvailable unsignedIntegerValue];
//                                   }
//
//                                   dispatch_group_leave(putFileGroup);
//                               }];
//    }
//
//    dispatch_group_leave(putFileGroup);
//}
//
//+ (NSArray<SDLPutFile *> *)sdl_splitFile:(SDLFile *)file mtuSize:(NSUInteger)mtuSize {
//    NSData *fileData = [file.data copy];
//    NSUInteger currentOffset = 0;
//    NSMutableArray<SDLPutFile *> *putFiles = [NSMutableArray array];
//
//    // http://stackoverflow.com/a/503201 Make sure we get the exact number of packets we need
//    for (int i = 0; i < (((fileData.length - 1) / mtuSize) + 1); i++) {
//        SDLPutFile *putFile = [[SDLPutFile alloc] initWithFileName:file.name fileType:file.fileType persistentFile:file.isPersistent];
//        putFile.offset = @(currentOffset);
//
//        // Set the length putfile based on the offset
//        if (currentOffset == 0) {
//            // If the offset is 0, the putfile expects to have the full file length within it
//            putFile.length = @(fileData.length);
//        } else if ((fileData.length - currentOffset) < mtuSize) {
//            // The file length remaining is less than our total MTU size, so use the file length remaining
//            putFile.length = @(fileData.length - currentOffset);
//        } else {
//            // The file length remaining is greater than our total MTU size, and the offset is not zero, we will fill the packet with our max MTU size
//            putFile.length = @(mtuSize);
//        }
//
//        // Place the data and set the new offset
//        if (currentOffset == 0 && (mtuSize < [putFile.length unsignedIntegerValue])) {
//            putFile.bulkData = [fileData subdataWithRange:NSMakeRange(currentOffset, mtuSize)];
//            currentOffset = mtuSize;
//        } else {
//            putFile.bulkData = [fileData subdataWithRange:NSMakeRange(currentOffset, [putFile.length unsignedIntegerValue])];
//            currentOffset += [putFile.length unsignedIntegerValue];
//        }
//
//        [putFiles addObject:putFile];
//    }
//
//    return putFiles;
//}


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
        case NSStreamEventErrorOccurred:
            // Todo
            NSLog(@"error occured");
        case NSStreamEventEndEncountered:
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        case NSStreamEventOpenCompleted:
            // Todo
            NSLog(@"??");
        case NSStreamEventHasBytesAvailable:
            // Todo
            NSLog(@"Still reading");
        case NSStreamEventHasSpaceAvailable:
            // Todo
            NSLog(@"Space still available");
        case NSStreamEventNone:
            // Todo
            NSLog(@"??");
        default:
            break;
    }
}

@end

NS_ASSUME_NONNULL_END
