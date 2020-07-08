//
//  SDLLifecycleSystemRequestHandler.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/8/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLLifecycleSystemRequestHandler.h"

#import "SDLCacheFileManager.h"
#import "SDLConnectionManagerType.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLOnSystemRequest.h"
#import "SDLPutFile.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLSystemRequest.h"

static const float DefaultConnectionTimeout = 45.0;

NS_ASSUME_NONNULL_BEGIN

typedef void (^URLSessionTaskCompletionHandler)(NSData *data, NSURLResponse *response, NSError *error);
typedef void (^URLSessionDownloadTaskCompletionHandler)(NSURL *location, NSURLResponse *response, NSError *error);

@interface SDLLifecycleSystemRequestHandler ()

@property (weak, nonatomic) id<SDLConnectionManagerType> manager;
@property (strong, nonatomic) SDLCacheFileManager *cacheFileManager;
@property (strong, nonatomic) NSURLSession *urlSession;

@end

@implementation SDLLifecycleSystemRequestHandler

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)manager {
    self = [super init];
    if (!self) { return nil; }

    SDLLogV(@"Initializing SystemRequest handler");
    _manager = manager;

    _cacheFileManager = [[SDLCacheFileManager alloc] init];

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = DefaultConnectionTimeout;
    configuration.timeoutIntervalForResource = DefaultConnectionTimeout;
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    _urlSession = [NSURLSession sessionWithConfiguration:configuration];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemRequestReceived:) name:SDLDidReceiveSystemRequestNotification object:nil];

    return self;
}

- (void)stop {
    SDLLogV(@"Stopping SystemRequest handler and stopping all URL session tasks");
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

#pragma mark - Handle OnSystemRequest
- (void)sdl_handleSystemRequestLaunchApp:(SDLOnSystemRequest *)request {
    NSURL *urlScheme = [NSURL URLWithString:request.url];
    if (urlScheme == nil) {
        SDLLogW(@"System request LaunchApp failed: invalid URL sent from module: %@", request.url);
        return;
    }

    // If system version is less than 9.0 http://stackoverflow.com/a/5337804/1370927
    if (SDL_SYSTEM_VERSION_LESS_THAN(@"9.0")) {
        // Return early if we can't openURL because openURL will crash instead of fail silently in < 9.0
        if (![[UIApplication sharedApplication] canOpenURL:urlScheme]) {
            return;
        }
    }

    [[UIApplication sharedApplication] openURL:urlScheme];
}

- (void)sdl_handleSystemRequestProprietary:(SDLOnSystemRequest *)request {
    NSDictionary<NSString *, id> *jsonDict = [self sdl_validateAndParseProprietarySystemRequest:request];
    if (jsonDict == nil || request.url == nil) {
        return;
    }

    // Send the HTTP Request
    __weak typeof(self) weakSelf = self;
    [self sdl_uploadForBodyDataDictionary:jsonDict
                                urlString:request.url
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;

        if (error) {
            SDLLogW(@"OnSystemRequest HTTP response error: %@", error);
            return;
        }
        if (data == nil || data.length == 0) {
            SDLLogW(@"OnSystemRequest HTTP response error: no data received");
            return;
        }

        // Create the SystemRequest RPC to send to module.
        SDLLogV(@"OnSystemRequest HTTP response");
        SDLSystemRequest *request = [[SDLSystemRequest alloc] init];
        request.requestType = SDLRequestTypeProprietary;
        request.bulkData = data;

        // Send the RPC Request
        [strongSelf.manager sendConnectionManagerRequest:request withResponseHandler:nil];
    }];
}

// TODO: Move to lock screen manager
- (void)sdl_handleSystemRequestLockScreenIconURL:(SDLOnSystemRequest *)request {
    [self.cacheFileManager retrieveImageForRequest:request withCompletionHandler:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (error != nil) {
            SDLLogW(@"Failed to retrieve lock screen icon: %@", error.localizedDescription);
            return;
        }

        NSDictionary<NSString *, id> *userInfo = nil;
        if (image != nil) {
            userInfo = @{SDLNotificationUserInfoObject: image};
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SDLDidReceiveLockScreenIcon object:nil userInfo:userInfo];
    }];
}

- (void)sdl_handleSystemRequestIconURL:(SDLOnSystemRequest *)request {
    __weak typeof(self) weakSelf = self;
    [self sdl_sendDataTaskWithURL:[NSURL URLWithString:request.url]
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (icon url) HTTP download task failed: %@", error.localizedDescription);
            return;
        } else if (data.length == 0) {
            SDLLogW(@"OnSystemRequest (icon url) HTTP download task failed to get the cloud app icon image data");
            return;
        }

        SDLSystemRequest *iconURLSystemRequest = [[SDLSystemRequest alloc] initWithType:SDLRequestTypeIconURL fileName:request.url];
        iconURLSystemRequest.bulkData = data;

        [strongSelf.manager sendConnectionManagerRequest:iconURLSystemRequest withResponseHandler:nil];
    }];
}

- (void)sdl_handleSystemRequestHTTP:(SDLOnSystemRequest *)request {
    if (request.bulkData.length == 0) {
        // TODO: not sure how we want to handle http requests that don't have bulk data (maybe as GET?)
        return;
    }

    __weak typeof(self) weakSelf = self;
    [self sdl_uploadData:request.bulkData
             toURLString:request.url
       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error != nil) {
            SDLLogW(@"OnSystemRequest (HTTP) error: %@", error.localizedDescription);
            return;
        }

        if (data.length == 0) {
            SDLLogW(@"OnSystemRequest (HTTP) error: no data returned");
            return;
        }

        // Show the HTTP response
        SDLLogV(@"OnSystemRequest (HTTP) response: %@", response);

        // Create the PutFile RPC to send to module.
        SDLPutFile *putFile = [[SDLPutFile alloc] init];
        putFile.fileType = SDLFileTypeJSON;
        putFile.sdlFileName = @"response_data";
        putFile.bulkData = data;

        // Send RPC Request
        [strongSelf.manager sendConnectionManagerRequest:putFile withResponseHandler:nil];
    }];
}

#pragma mark - HTTP

/**
 *  Start an upload for some data to a web address specified
 *
 *  @param data              The data to be passed to the server
 *  @param urlString         The URL the data should be POSTed to
 *  @param completionHandler A completion handler of what to do when the server responds
 */
- (void)sdl_uploadData:(NSData *_Nonnull)data toURLString:(NSString *_Nonnull)urlString completionHandler:(URLSessionTaskCompletionHandler _Nullable)completionHandler {
    // NSURLRequest configuration
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    request.HTTPMethod = @"POST";

    SDLLogV(@"OnSystemRequest (HTTP) upload task created for URL: %@", urlString);

    // Create the upload task
    [self sdl_sendUploadRequest:request withData:data completionHandler:completionHandler];
}

/**
 *  Start an upload for a body data dictionary, this is used by the "proprietary" system request needed for backward compatibility
 *
 *  @param dictionary        The system request dictionary that contains the HTTP data to be sent
 *  @param urlString         A string containing the URL to send the upload to
 *  @param completionHandler A completion handler returning the response from the server to the upload task
 */
- (void)sdl_uploadForBodyDataDictionary:(NSDictionary<NSString *, id> *)dictionary urlString:(NSString *)urlString completionHandler:(URLSessionTaskCompletionHandler)completionHandler {
    NSParameterAssert(dictionary != nil);
    NSParameterAssert(urlString != nil);
    NSParameterAssert(completionHandler != NULL);

    // Extract data from the dictionary
    NSDictionary<NSString *, id> *requestData = dictionary[@"HTTPRequest"];
    NSDictionary *headers = requestData[@"headers"];
    NSString *contentType = headers[@"ContentType"];
    NSTimeInterval timeout = [headers[@"ConnectTimeout"] doubleValue];
    NSString *method = headers[@"RequestMethod"];
    NSString *bodyString = requestData[@"body"];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];

    // NSURLRequest configuration
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:contentType forHTTPHeaderField:@"content-type"];
    request.timeoutInterval = timeout;
    request.HTTPMethod = method;

    SDLLogV(@"OnSystemRequest (Proprietary) upload task created for URL: %@", urlString);

    // Create the upload task
    [self sdl_sendUploadRequest:request withData:bodyData completionHandler:completionHandler];
}

- (void)sdl_sendUploadRequest:(NSURLRequest*)request withData:(NSData*)data completionHandler:(URLSessionTaskCompletionHandler)completionHandler {
    NSMutableURLRequest* mutableRequest = [request mutableCopy];

    if ([mutableRequest.URL.scheme isEqualToString:@"http"]) {
        mutableRequest.URL = [NSURL URLWithString:[mutableRequest.URL.absoluteString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"https"]];
    }

    [[self.urlSession uploadTaskWithRequest:request fromData:data completionHandler:completionHandler] resume];
}

- (void)sdl_sendDataTaskWithURL:(NSURL*)url completionHandler:(URLSessionTaskCompletionHandler)completionHandler {
    if ([url.scheme isEqualToString:@"http"]) {
        url = [NSURL URLWithString:[url.absoluteString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:@"https"]];
    }

    [[self.urlSession dataTaskWithURL:url completionHandler:completionHandler] resume];
}

#pragma mark - Validation

/**
 *  Determine if the System Request is valid and return it's JSON dictionary, if available.
 *
 *  @param request The system request to parse
 *
 *  @return A parsed JSON dictionary, or nil if it couldn't be parsed
 */
- (nullable NSDictionary<NSString *, id> *)sdl_validateAndParseProprietarySystemRequest:(SDLOnSystemRequest *)request {
    NSString *urlString = request.url;
    SDLFileType fileType = request.fileType;

    // Validate input
    if (urlString == nil || [NSURL URLWithString:urlString] == nil) {
        SDLLogW(@"OnSystemRequest validation failure: URL is nil");
        return nil;
    }
    if (![fileType isEqualToEnum:SDLFileTypeJSON]) {
        SDLLogW(@"OnSystemRequest validation failure: file type is not JSON");
        return nil;
    }

    // Get data dictionary from the bulkData
    NSError *error = nil;
    NSDictionary<NSString *, id> *JSONDictionary = [NSJSONSerialization JSONObjectWithData:request.bulkData options:kNilOptions error:&error];
    if (error != nil) {
        SDLLogW(@"OnSystemRequest validation failure: data is not valid JSON");
        return nil;
    }

    return JSONDictionary;
}

#pragma mark - Notifications

- (void)systemRequestReceived:(SDLRPCNotificationNotification *)notification {
    SDLOnSystemRequest *onSystemRequest = notification.notification;
    SDLRequestType requestType = onSystemRequest.requestType;

    // Handle the various OnSystemRequest types
    if ([requestType isEqualToEnum:SDLRequestTypeProprietary]) {
        [self sdl_handleSystemRequestProprietary:onSystemRequest];
    } else if ([requestType isEqualToEnum:SDLRequestTypeLockScreenIconURL]) {
        [self sdl_handleSystemRequestLockScreenIconURL:onSystemRequest];
    } else if ([requestType isEqualToEnum:SDLRequestTypeIconURL]) {
        [self sdl_handleSystemRequestIconURL:onSystemRequest];
    } else if ([requestType isEqualToEnum:SDLRequestTypeHTTP]) {
        [self sdl_handleSystemRequestHTTP:onSystemRequest];
    } else if ([requestType isEqualToEnum:SDLRequestTypeLaunchApp]) {
        if ([NSThread isMainThread]) {
            [self sdl_handleSystemRequestLaunchApp:onSystemRequest];
        } else {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self sdl_handleSystemRequestLaunchApp:onSystemRequest];
            });
        }
    }
}

@end

NS_ASSUME_NONNULL_END
