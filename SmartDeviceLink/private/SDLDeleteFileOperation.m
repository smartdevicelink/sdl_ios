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

NS_ASSUME_NONNULL_BEGIN

@interface SDLDeleteFileOperation ()

@property (copy, nonatomic) NSString *fileName;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (copy, nonatomic, nullable) SDLFileManagerDeleteCompletionHandler completionHandler;

@end


@implementation SDLDeleteFileOperation

- (instancetype)initWithFileName:(NSString *)fileName connectionManager:(id<SDLConnectionManagerType>)connectionManager completionHandler:(nullable SDLFileManagerDeleteCompletionHandler)completionHandler {
    self = [super init];
    if (!self) {
        return nil;
    }

    _fileName = fileName;
    _connectionManager = connectionManager;
    _completionHandler = completionHandler;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    [self sdl_deleteFile];
}

- (void)sdl_deleteFile {
    SDLDeleteFile *deleteFile = [[SDLDeleteFile alloc] initWithFileName:self.fileName];

    typeof(self) weakself = self;
    [self.connectionManager sendConnectionManagerRequest:deleteFile withResponseHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        // Pull out the parameters
        SDLDeleteFileResponse *deleteFileResponse = (SDLDeleteFileResponse *)response;
        BOOL success = [deleteFileResponse.success boolValue];

        // If spaceAvailable is nil, set it to the max value
        NSUInteger bytesAvailable = deleteFileResponse.spaceAvailable != nil ? deleteFileResponse.spaceAvailable.unsignedIntegerValue : 2000000000;

        // Callback
        if (weakself.completionHandler != nil) {
            weakself.completionHandler(success, bytesAvailable, error);
        }

        [weakself finishOperation];
    }];
}


#pragma mark Property Overrides

- (nullable NSString *)name {
    return [NSString stringWithFormat:@"%@ - %@", self.class, self.fileName];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}

@end

NS_ASSUME_NONNULL_END
