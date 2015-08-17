//
//  SDLURLRequestTask.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/17/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLURLRequestTask.h"

#import "SDLURLSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLURLRequestTask () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic, readwrite) NSURLConnection *connection;
@property (copy, nonatomic, readwrite) SDLURLConnectionRequestCompletionHandler completionHandler;
@property (strong, nonatomic) NSMutableData *mutableData;

@end


@implementation SDLURLRequestTask

#pragma mark - Lifecycle

- (instancetype)initWithURLRequest:(NSURLRequest *)request completionHandler:(SDLURLConnectionRequestCompletionHandler)completionHandler {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _connection = [NSURLConnection connectionWithRequest:request delegate:self];
    _completionHandler = completionHandler;
    
    _mutableData = [NSMutableData data];
    _response = nil;
    _state = SDLURLRequestTaskStateRunning;
    
    return self;
}


#pragma mark - Data Methods

- (void)addData:(NSData *)data {
    [self.mutableData appendData:data];
}


#pragma mark - Cancel

- (void)cancel {
    [self.connection cancel];
}


#pragma mark - Setters / Getters

- (NSData *)data {
    return [self.mutableData copy];
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.completionHandler(nil, self.response, error);
    
    self.state = SDLURLRequestTaskStateCompleted;
}


#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self addData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.response = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    self.completionHandler(self.data, self.response, nil);
    
    self.state = SDLURLRequestTaskStateCompleted;
}

@end

NS_ASSUME_NONNULL_END
