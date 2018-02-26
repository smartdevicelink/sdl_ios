//
//  SDLListFilesOperation.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 5/25/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLListFilesOperation.h"

#import "SDLConnectionManagerType.h"
#import "SDLListFiles.h"
#import "SDLListFilesResponse.h"


NS_ASSUME_NONNULL_BEGIN

@interface SDLListFilesOperation ()

@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (copy, nonatomic, nullable) SDLFileManagerListFilesCompletionHandler completionHandler;

@end


@implementation SDLListFilesOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager completionHandler:(nullable SDLFileManagerListFilesCompletionHandler)completionHandler {
    self = [super init];
    if (!self) {
        return nil;
    }

    _connectionManager = connectionManager;
    _completionHandler = completionHandler;

    return self;
}

- (void)start {
    [super start];

    [self sdl_listFiles];
}

- (void)sdl_listFiles {
    SDLListFiles *listFiles = [[SDLListFiles alloc] init];

    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendConnectionManagerRequest:listFiles
                           withResponseHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
                               SDLListFilesResponse *listFilesResponse = (SDLListFilesResponse *)response;
                               BOOL success = [listFilesResponse.success boolValue];
                               NSUInteger bytesAvailable = [listFilesResponse.spaceAvailable unsignedIntegerValue];
                               NSArray<NSString *> *fileNames = [NSArray arrayWithArray:listFilesResponse.filenames];

                               if (weakSelf.completionHandler != nil) {
                                   weakSelf.completionHandler(success, bytesAvailable, fileNames, error);
                               }

                               [weakSelf finishOperation];
                           }];
}


#pragma mark Property Overrides

- (nullable NSString *)name {
    return @"List Files";
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}

@end

NS_ASSUME_NONNULL_END
