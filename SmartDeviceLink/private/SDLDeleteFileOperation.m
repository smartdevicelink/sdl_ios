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
#import "SDLError.h"
#import "SDLLogMacros.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLDeleteFileOperation ()

@property (copy, nonatomic) NSString *fileName;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (copy, nonatomic, nullable) SDLFileManagerDeleteCompletionHandler completionHandler;

@end


@implementation SDLDeleteFileOperation

- (instancetype)initWithFileName:(SDLFileName *)fileName connectionManager:(id<SDLConnectionManagerType>)connectionManager remoteFileNames:(NSSet<SDLFileName *> *)remoteFileNames completionHandler:(SDLFileManagerDeleteCompletionHandler)completionHandler {
    self = [super init];
    if (!self) {
        if (completionHandler != nil) {
            completionHandler(NO, NSNotFound, [NSError sdl_failedToCreateObjectOfClass:[SDLDeleteFileOperation class]]);
        }
        return nil;
    }

    _fileName = fileName;
    _connectionManager = connectionManager;
    _remoteFileNames = remoteFileNames;
    _completionHandler = completionHandler;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    if (![self.remoteFileNames containsObject:self.fileName]) {
        SDLLogW(@"File to delete is no longer on the head unit, aborting operation");
        self.completionHandler(NO, NSNotFound, [NSError sdl_fileManager_fileDoesNotExistError]);
        return [self finishOperation];
    }

    [self sdl_deleteFile];
}

- (void)sdl_deleteFile {
    SDLDeleteFile *deleteFile = [[SDLDeleteFile alloc] initWithFileName:self.fileName];

    typeof(self) weakself = self;
    [self.connectionManager sendConnectionManagerRequest:deleteFile withResponseHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        SDLDeleteFileResponse *deleteFileResponse = (SDLDeleteFileResponse *)response;
        BOOL success = [deleteFileResponse.success boolValue];

        if (error != nil) {
            SDLLogE(@"Error deleting file: %@", error);
        }

        // If spaceAvailable is nil, set it to the max value
        NSUInteger bytesAvailable = (deleteFileResponse.spaceAvailable != nil) ? deleteFileResponse.spaceAvailable.unsignedIntegerValue : 2000000000;

        weakself.completionHandler(success, bytesAvailable, error);
        [weakself finishOperation];
    }];
}


#pragma mark Property Overrides

- (nullable NSString *)name {
    return [NSString stringWithFormat:@"%@ - %@", self.class, self.fileName];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityNormal;
}

@end

NS_ASSUME_NONNULL_END
