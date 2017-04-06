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

- (void)sendPutFiles:(SDLFile *)file mtuSize:(NSUInteger)mtuSize withCompletion:(SDLFileManagerUploadCompletionHandler)completion  {

    // iStream is NSInputStream instance variable
    self.inputStream = file.inputStream;
    [self.inputStream setDelegate:self];
    [self.inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];
    [self.inputStream open];

    // Wait for all data chunks be sent before executing the code in dispatch_group_notify
    dispatch_group_t putFileGroup = dispatch_group_create();
    dispatch_group_enter(putFileGroup);
    NSLog(@"entering: %@", self);
    __weak typeof(self) weakself = self;
    __block BOOL stop = NO;
    __block NSError *streamError = nil;
    __block NSUInteger bytesAvailable = 0;
    __block NSInteger highestCorrelationIDReceived = -1;
    dispatch_group_notify(putFileGroup, dispatch_get_main_queue(), ^{
        // Was the data sent to the SDL Core successfully?
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

        // Get a chunk of data from the input stream
        NSError *error = nil;
        NSUInteger dataSize = [self getDataLengthForOffset:currentOffset fileSize:fileSize mtuSize:mtuSize];
        NSData *dataChunk = [self getDataChunkWithSize:dataSize inputStream:self.inputStream error:&error];
        if (dataChunk == nil) {
            // TODO: - ????? Add error message here!
            return completion(NO, bytesAvailable, streamError);
        }
        putFile.bulkData = dataChunk;
        currentOffset += dataSize;

        // Send the putfile
        NSLog(@"entering: %@", self);
        dispatch_group_enter(putFileGroup);
        __weak typeof(self) weakself = self;
        NSLog(@"sending to connection manager: %@", self.connectionManager);
        [self.connectionManager sendManagerRequest:putFile withResponseHandler:^(__kindof SDLRPCRequest * _Nullable request, __kindof SDLRPCResponse * _Nullable response, NSError * _Nullable error) {

            NSLog(@"got something...");
            NSLog(@"leaving: %@", self);
            dispatch_group_leave(putFileGroup);
        }];
    }

    NSLog(@"leaving: %@", self);
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

- (NSUInteger)getDataLengthForOffset:(NSUInteger)currentOffset fileSize:(unsigned long long)fileSize mtuSize:(NSUInteger)mtuSize {
    NSInteger dataSize = 0;
    NSUInteger fileSizeRemaining = (NSUInteger)(fileSize - currentOffset);
    if (fileSizeRemaining < mtuSize) {
        // The file length remaining is smaller than the max data chunk sized allowed. The putfile expects the length parameter to match the size of the last data chunk being sent.
        dataSize = fileSizeRemaining;
    } else {
        // When the file length remaining is greater than the max data chunk sized allowed, and the offset is not zero, the putfile expects the length parameter to match the size of the data chunk being sent.
        dataSize = mtuSize;
    }
    return dataSize;
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
            NSLog(@"Input stream error occured");
        case NSStreamEventEndEncountered:
            NSLog(@"Input stream end encountered. Closing...");
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            break;
        case NSStreamEventOpenCompleted:
            // Todo
            NSLog(@"Input stream open completed");
        case NSStreamEventHasBytesAvailable:
            // Todo
            NSLog(@"Input stream still reading");
        case NSStreamEventHasSpaceAvailable:
            // Todo
            NSLog(@"Input stream space still available");
        case NSStreamEventNone:
            // Todo
            NSLog(@"Input stream nothing happening");
        default:
            break;
    }
}

@end

NS_ASSUME_NONNULL_END
