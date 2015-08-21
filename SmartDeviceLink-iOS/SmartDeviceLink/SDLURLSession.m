//
//  SDLURLSession.m
//  SmartDeviceLink-iOS
//
//  Created by CHDSEZ318988DADM on 11/08/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLURLSession.h"

#import "SDLDebugTool.h"

@interface SDLURLSession () {
    NSURLSession *systemRequestSession;
    NSURLSession *encodedSyncPDataSession;
    id _delegate;
}
@property (strong) NSString *debugConsoleGroupName;

@end

@implementation SDLURLSession
-(id)initWithDelegate:(id<SDLURLSessionDelegate>)delegate withDebugConsoleGroup:(NSString *)debugConsoleGroupName{
    self = [super init];
    if(self) {
        _delegate = delegate;
    }
    self.debugConsoleGroupName = [[NSString alloc] initWithString:debugConsoleGroupName];
    return self;
}

-(void)uploadTaskWithPData:(NSData *)data withRequest:(NSMutableURLRequest *)request withTimeout:(NSNumber*) timeout{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Content-Type": @"application/json"};
    config.timeoutIntervalForRequest = 60;
    encodedSyncPDataSession = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionUploadTask *uploadTask = [encodedSyncPDataSession uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (_delegate && [_delegate respondsToSelector:@selector(syncPDatadataReady:)]) {
            [_delegate syncPDatadataReady:data];
        }
    }];
    [uploadTask resume];
}

- (void)uploadTaskWithSystemProprietaryDictionary:(NSDictionary *)dictionary withURLString:(NSString *)urlString {
    NSParameterAssert(dictionary != nil);
    NSParameterAssert(urlString != nil);
    
    // Extract data from the dictionary
    NSDictionary *requestData = dictionary[@"HTTPRequest"];
    NSDictionary *headers = requestData[@"headers"];
    NSString *contentType = headers[@"ContentType"];
    NSTimeInterval timeout = [headers[@"ConnectTimeout"] doubleValue];
    NSString *method = headers[@"RequestMethod"];
    NSString *bodyString = requestData[@"body"];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    // NSURLSession configuration
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    systemRequestSession = [NSURLSession sessionWithConfiguration:config];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:contentType forHTTPHeaderField:@"content-type"];
    request.timeoutInterval = timeout;
    request.HTTPMethod = method;
    
    // Logging
    NSString *logMessage = [NSString stringWithFormat:@"OnSystemRequest (HTTP Request) to URL %@", urlString];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    
    // Create the upload task
    NSURLSessionUploadTask *task =  [systemRequestSession uploadTaskWithRequest:request fromData:bodyData completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *logMessage = nil;
        
        if (error) {
            logMessage = [NSString stringWithFormat:@"OnSystemRequest (HTTP response) = ERROR: %@", error];
            [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
            
        }
        if (_delegate && [_delegate respondsToSelector:@selector(systemProprietarydataReady:)]) {
            [_delegate  systemProprietarydataReady:data];
        }
    }];
    [task resume];
    
}

- (void) dataTaskForSystemRequestURLString:(NSString *)urlString {
    NSParameterAssert(urlString != nil);
    
    NSString *logMessage = [NSString stringWithFormat:@"OnSystemRequest (HTTP Request to URL: %@", urlString];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];

    // Create and return the data task
     [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString]completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
         if (error) {
             NSString *logString = nil;

             logString = [NSString stringWithFormat:@"OnSystemRequest (HTTP response) = ERROR: %@", error];
             [SDLDebugTool logInfo:logString withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
             
         }
         if (_delegate && [_delegate respondsToSelector:@selector(systemQueueAppDataReady:)]) {
             [_delegate systemQueueAppDataReady:data];
         }

     }];
}

- (void) cancelAndInvalidate {
    
    if (systemRequestSession != nil) {
        [systemRequestSession invalidateAndCancel];
    }
    if (encodedSyncPDataSession != nil) {
        [encodedSyncPDataSession invalidateAndCancel];
    }
    
}
@end
