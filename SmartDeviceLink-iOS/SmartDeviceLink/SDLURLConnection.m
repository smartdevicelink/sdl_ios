//
//  SDLURLConnection.m
//  SmartDeviceLink-iOS
//
//  Created by CHDSEZ318988DADM on 11/08/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLURLConnection.h"

#import "SDLDebugTool.h"

@interface SDLURLConnection () {
    id _delegate;
    NSURLConnection* _encodedSyncPDataConnection;
    NSURLConnection* _systemRequestProprietaryConnection;
    NSURLConnection* _queryAppConnection;
    
    NSMutableData *encodedSyncPResponseData;
    NSMutableData *systemProprietaryResponseData;
    NSMutableData *queryAppData;
    
}
@property (strong) NSString *debugConsoleGroupName;

@end

@implementation SDLURLConnection
-(id)initWithDelegate:(id<SDLURLConnectionDelegate>)delegate withDebugConsoleGroup:(NSString *)debugConsoleGroupName{
    self = [super init];
    if(self) {
        _delegate = delegate;
    }
    self.debugConsoleGroupName = [[NSString alloc] initWithString:debugConsoleGroupName];
    return self;
}

-(void)uploadTaskWithPData:(NSData *)data withRequest:(NSMutableURLRequest *)request withTimeout:(NSNumber*) timeout{
    request.HTTPBody = data;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    request.timeoutInterval = [timeout doubleValue];
    
    _encodedSyncPDataConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_encodedSyncPDataConnection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                           forMode:NSDefaultRunLoopMode];
    [_encodedSyncPDataConnection start];
    
    if (_encodedSyncPDataConnection == nil) {
        NSString *logString = [NSString stringWithFormat:@"%s: Error creating NSURLConnection", __PRETTY_FUNCTION__];
        [SDLDebugTool logInfo:logString withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }
    
}
- (void)uploadTaskWithSystemProprietaryDictionary:(NSDictionary *)dictionary withURLString:(NSString *)urlString {
    
    // Extract data from the dictionary
    NSDictionary *requestData = dictionary[@"HTTPRequest"];
    NSDictionary *headers = requestData[@"headers"];
    NSString *contentType = headers[@"ContentType"];
    NSTimeInterval timeout = [headers[@"ConnectTimeout"] doubleValue];
    NSString *method = headers[@"RequestMethod"];
    NSString *bodyString = requestData[@"body"];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    
    // NSURLConnection configuration
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:contentType forHTTPHeaderField:@"content-type"];
    request.timeoutInterval = timeout;
    request.HTTPMethod = method;
    request.HTTPBody = bodyData;
    
    
    // Logging
    NSString *logMessage = [NSString stringWithFormat:@"OnSystemRequest (HTTP Request) to URL %@", request.URL];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    _systemRequestProprietaryConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_systemRequestProprietaryConnection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                                   forMode:NSDefaultRunLoopMode];
    [_systemRequestProprietaryConnection start];
    
    if (_systemRequestProprietaryConnection == nil) {
        NSString *logString = [NSString stringWithFormat:@"%s: Error creating NSURLConnection", __PRETTY_FUNCTION__];
        [SDLDebugTool logInfo:logString withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }
    
}

- (void) dataTaskForSystemRequestURLString:(NSString *)urlString {
    NSParameterAssert(urlString != nil);
    
    NSString *logMessage = [NSString stringWithFormat:@"OnSystemRequest (HTTP Request to URL: %@", urlString];
    [SDLDebugTool logInfo:logMessage withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
     NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    _queryAppConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_queryAppConnection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                                                   forMode:NSDefaultRunLoopMode];
    [_queryAppConnection start];
}

- (void) cancelAndInvalidate {
    
    if (encodedSyncPResponseData != nil) {
        encodedSyncPResponseData = nil;
    }
    if (systemProprietaryResponseData != nil) {
        systemProprietaryResponseData = nil;
    }
    if (_encodedSyncPDataConnection != nil) {
        [_encodedSyncPDataConnection cancel];
    }
    if (_systemRequestProprietaryConnection != nil) {
        [_systemRequestProprietaryConnection cancel];
    }
    if (_queryAppConnection != nil) {
        [_queryAppConnection cancel];
    }
    if (queryAppData != nil) {
        queryAppData = nil;
    }
    
}


#pragma mark - NSURL Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // Can be called multiple times, such as a server redirect, so reset the data each time
    if (connection == _encodedSyncPDataConnection) {
        encodedSyncPResponseData = [[NSMutableData alloc] init];
    }
    else if (connection == _systemRequestProprietaryConnection) {
        systemProprietaryResponseData = [[NSMutableData alloc] init];
    }
    else if (connection == _queryAppConnection) {
        queryAppData = [[NSMutableData alloc] init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (connection == _encodedSyncPDataConnection) {
        [encodedSyncPResponseData appendData:data];
    }
    else if (connection == _systemRequestProprietaryConnection) {
        [systemProprietaryResponseData appendData:data];
    }
    else if (connection == _queryAppConnection) {
        [queryAppData appendData:data];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (connection == _encodedSyncPDataConnection) {
        if (_delegate && [_delegate respondsToSelector:@selector(syncPDatadataReady:)]) {
            [_delegate syncPDatadataReady:encodedSyncPResponseData];
        }
    }
    else if (connection == _systemRequestProprietaryConnection) {
        if (_delegate && [_delegate respondsToSelector:@selector(systemProprietarydataReady:)]) {
            [_delegate systemProprietarydataReady:systemProprietaryResponseData];
        }
    }
    else if (connection == _queryAppConnection) {
        if (_delegate && [_delegate respondsToSelector:@selector(systemQueueAppDataReady:)]) {
            [_delegate systemQueueAppDataReady:queryAppData];
        }
    }

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSString *logString;
    if (connection == _encodedSyncPDataConnection) {
        logString = [NSString stringWithFormat:@"%s, OnEncodedSyncPData (HTTP response) failure = ERROR: %@ ", __PRETTY_FUNCTION__, [error localizedDescription]];
        
        [SDLDebugTool logInfo:logString withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }
    else if (connection == _systemRequestProprietaryConnection) {
        logString = [NSString stringWithFormat:@"OnSystemRequest (HTTP response) = ERROR: %@", error];
        [SDLDebugTool logInfo:logString withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
    }
    else if (connection == _queryAppConnection) {
        logString = [NSString stringWithFormat:@"OnSystemRequest failure (HTTP response), upload task failed: %@", error];
        [SDLDebugTool logInfo:logString withType:SDLDebugType_RPC toOutput:SDLDebugOutput_All toGroup:self.debugConsoleGroupName];
        return;
    }
    
}

@end
