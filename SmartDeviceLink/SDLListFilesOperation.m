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

@property (strong, nonatomic) NSUUID *operationId;
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (copy, nonatomic, nullable) SDLFileManagerListFilesCompletionHandler completionHandler;

@end


@implementation SDLListFilesOperation

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager completionHandler:(nullable SDLFileManagerListFilesCompletionHandler)completionHandler {
    self = [super init];
    if (!self) {
        return nil;
    }

    _operationId = [NSUUID UUID];
    _connectionManager = connectionManager;
    _completionHandler = completionHandler;

    return self;
}

- (void)start {
    [super start];
    if (self.isCancelled) { return; }

    [self sdl_listFiles];
}

- (void)sdl_listFiles {
    SDLListFiles *listFiles = [[SDLListFiles alloc] init];

    __weak typeof(self) weakSelf = self;
    [self.connectionManager sendConnectionManagerRequest:listFiles withResponseHandler:^(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *response, NSError *error) {
        SDLListFilesResponse *listFilesResponse = (SDLListFilesResponse *)response;
        BOOL success = [listFilesResponse.success boolValue];
        NSArray<NSString *> *fileNames = [NSArray arrayWithArray:listFilesResponse.filenames];

        // If spaceAvailable is nil, set it to the max value
        NSUInteger bytesAvailable = listFilesResponse.spaceAvailable != nil ? listFilesResponse.spaceAvailable.unsignedIntegerValue : 2000000000;

        if (weakSelf.completionHandler != nil) {
            if(error != nil) {
                NSMutableDictionary *results = [error.userInfo mutableCopy];
                results[@"resultCode"] = response.resultCode;
                NSError *resultError = [NSError errorWithDomain:error.domain code:error.code userInfo:results];
                weakSelf.completionHandler(success, bytesAvailable, fileNames, resultError);
            } else {
                weakSelf.completionHandler(success, bytesAvailable, fileNames, error);
            }
        }

        [weakSelf finishOperation];
    }];
}


#pragma mark Property Overrides

- (nullable NSString *)name {
    return [NSString stringWithFormat:@"%@ - %@", self.class, self.operationId];
}

- (NSOperationQueuePriority)queuePriority {
    return NSOperationQueuePriorityVeryHigh;
}

@end

NS_ASSUME_NONNULL_END
