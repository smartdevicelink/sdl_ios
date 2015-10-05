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

@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic, nullable) NSURLResponse *response;
@property (copy, nonatomic) SDLURLConnectionRequestCompletionHandler completionHandler;
@property (strong, nonatomic) NSMutableData *mutableData;

@end


@implementation SDLURLRequestTask

#pragma mark - Lifecycle

- (instancetype)init {
    NSAssert(NO, @"use initWithURLRequest:completionHandler instead");
    return nil;
}

- (instancetype)initWithURLRequest:(NSURLRequest *)request completionHandler:(SDLURLConnectionRequestCompletionHandler)completionHandler {
    self = [super init];
    if (!self) {
        return nil;
    }

    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    [_connection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [_connection start];

    _completionHandler = completionHandler;

    _mutableData = [NSMutableData data];
    _response = nil;
    _state = SDLURLRequestTaskStateRunning;

    return self;
}

+ (instancetype)taskWithURLRequest:(NSURLRequest *)request completionHandler:(SDLURLConnectionRequestCompletionHandler)completionHandler {
    return [[self alloc] initWithURLRequest:request completionHandler:completionHandler];
}

- (void)dealloc {
    [_connection cancel];
}


#pragma mark - Data Methods

- (void)sdl_addData:(NSData *)data {
    [self.mutableData appendData:data];
}


#pragma mark - Cancel

- (void)cancel {
    [self.connection cancel];
    [self connection:self.connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:kCFURLErrorCancelled userInfo:nil]];
}


#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.completionHandler(nil, self.response, error);

        self.state = SDLURLRequestTaskStateCompleted;
        [self.delegate taskDidFinish:self];
    });
}


#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self sdl_addData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.response = response;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.completionHandler([self.mutableData copy], self.response, nil);

        self.state = SDLURLRequestTaskStateCompleted;
        [self.delegate taskDidFinish:self];
    });
}

@end

NS_ASSUME_NONNULL_END
