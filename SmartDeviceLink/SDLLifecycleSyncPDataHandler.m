//
//  SDLLifecycleSyncPDataHandler.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/8/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLLifecycleSyncPDataHandler.h"

#import "SDLConnectionManagerType.h"
#import "SDLEncodedSyncPData.h"
#import "SDLLogMacros.h"
#import "SDLOnEncodedSyncPData.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCParameterNames.h"

static const float DefaultConnectionTimeout = 45.0;

NS_ASSUME_NONNULL_BEGIN

@interface SDLLifecycleSyncPDataHandler ()

@property (weak, nonatomic) id<SDLConnectionManagerType> manager;
@property (strong, nonatomic) NSURLSession *urlSession;

@end

@implementation SDLLifecycleSyncPDataHandler

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager {
    self = [super init];
    if (!self) { return nil; }

    SDLLogV(@"Initializing SyncPData handler");
    _manager = manager;

    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = DefaultConnectionTimeout;
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    _urlSession = [NSURLSession sessionWithConfiguration:configuration];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sdl_encodedSyncPDataReceived:) name:SDLDidReceiveEncodedDataNotification object:nil];
#pragma clang diagnostic pop

    return self;
}

- (void)stop {
    SDLLogV(@"Stopping SyncPData handler and stopping all URL session tasks");
    [self.urlSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        for (NSURLSessionTask *task in dataTasks) {
            [task cancel];
        }

        for (NSURLSessionTask *task in uploadTasks) {
            [task cancel];
        }

        for (NSURLSessionTask *task in downloadTasks) {
            [task cancel];
        }
    }];
}

#pragma mark - Utilities

- (void)sdl_sendEncodedSyncPData:(NSDictionary<NSString *, id> *)encodedSyncPData toURL:(NSString *)urlString withTimeout:(NSNumber *)timeout {
    // Configure HTTP URL & Request
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = 60;

    // Prepare the data in the required format
    NSString *encodedSyncPDataString = [[NSString stringWithFormat:@"%@", encodedSyncPData] componentsSeparatedByString:@"\""][1];
    NSArray<NSString *> *array = [NSArray arrayWithObject:encodedSyncPDataString];
    NSDictionary<NSString *, id> *dictionary = @{ @"data": array };
    NSError *JSONSerializationError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:kNilOptions error:&JSONSerializationError];
    if (JSONSerializationError) {
        SDLLogW(@"Error attempting to create SyncPData for HTTP request: %@", JSONSerializationError);
        return;
    }

    // Send the HTTP Request
    __weak typeof(self) weakSelf = self;
    [[self.urlSession uploadTaskWithRequest:request
                                   fromData:data
                          completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf sdl_syncPDataNetworkRequestCompleteWithData:data response:response error:error];
    }] resume];

    SDLLogV(@"OnEncodedSyncPData (HTTP Request)");
}

// Handle the OnEncodedSyncPData HTTP Response
- (void)sdl_syncPDataNetworkRequestCompleteWithData:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error {
    // Sample of response: {"data":["SDLKGLSDKFJLKSjdslkfjslkJLKDSGLKSDJFLKSDJF"]}
    SDLLogV(@"OnEncodedSyncPData (HTTP Response): %@", response);

    // Validate response data.
    if (data == nil || data.length == 0) {
        SDLLogW(@"OnEncodedSyncPData (HTTP Response): no data returned");
        return;
    }

    // Convert data to RPCRequest
    NSError *JSONConversionError = nil;
    NSDictionary<NSString *, id> *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&JSONConversionError];
    if (JSONConversionError) {
        SDLLogE(@"Error converting EncodedSyncPData response dictionary: %@", JSONConversionError);
        return;
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SDLEncodedSyncPData *request = [[SDLEncodedSyncPData alloc] init];
#pragma clang diagnostic pop
    request.data = responseDictionary[@"data"];

    [self.manager sendConnectionManagerRequest:request withResponseHandler:nil];
}


#pragma mark - Notifications

- (void)sdl_encodedSyncPDataReceived:(SDLRPCNotificationNotification *)notification {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SDLOnEncodedSyncPData *message = notification.notification;
#pragma clang diagnostic pop

    // If URL != nil, perform HTTP Post and don't pass the notification to proxy listeners
    SDLLogV(@"OnEncodedSyncPData: %@", message);

    NSString *urlString = (NSString *)message.parameters[SDLRPCParameterNameURLUppercase];
    NSDictionary<NSString *, id> *encodedSyncPData = (NSDictionary<NSString *, id> *)message.parameters[SDLRPCParameterNameData];
    NSNumber *encodedSyncPTimeout = (NSNumber *)message.parameters[SDLRPCParameterNameTimeoutCapitalized];

    if (urlString && encodedSyncPData && encodedSyncPTimeout) {
        [self sdl_sendEncodedSyncPData:encodedSyncPData toURL:urlString withTimeout:encodedSyncPTimeout];
    }
}

@end

NS_ASSUME_NONNULL_END
