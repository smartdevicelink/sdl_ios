//
//  SDLURLConnection.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/17/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLURLSession.h"

#import "SDLURLRequestTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLURLSession ()

@property (strong, nonatomic) NSMutableSet *activeTasks;

@end


@implementation SDLURLSession


#pragma mark - Lifecycle

+ (instancetype)sharedSession {
    static SDLURLSession *sharedSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSession = [[self alloc] init];
    });
    
    return sharedSession;
}

- (void)dealloc {
    for (SDLURLRequestTask *task in self.activeTasks) {
        [task cancel];
        
        @try {
            [task removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
        } @catch (NSException *__unused exception) {}
    }
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _cachePolicy = NSURLRequestUseProtocolCachePolicy;
    _connectionTimeout = 15.0;
    
    _activeTasks = [NSMutableSet set];
    
    return self;
}


#pragma mark - URL Request Methods

- (void)dataFromURL:(NSURL *)url completionHandler:(SDLURLConnectionRequestCompletionHandler)completionHandler {
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:self.cachePolicy timeoutInterval:self.connectionTimeout];
    
    SDLURLRequestTask *task = [[SDLURLRequestTask alloc] initWithURLRequest:request completionHandler:completionHandler];
    
    [task addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.activeTasks addObject:task];
}

- (void)uploadWithURLRequest:(NSURLRequest *)request data:(NSData *)data completionHandler:(SDLURLConnectionRequestCompletionHandler)completionHandler {
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    mutableRequest.HTTPBody = data;
    
    SDLURLRequestTask *task = [[SDLURLRequestTask alloc] initWithURLRequest:request completionHandler:completionHandler];
    
    [task addObserver:self forKeyPath:NSStringFromSelector(@selector(state)) options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.activeTasks addObject:task];
}


#pragma mark - Cancel Methods

- (void)cancelAllTasks {
    for (SDLURLRequestTask *task in self.activeTasks) {
        [task cancel];
    }
}


#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        SDLURLRequestTask *task = object;
        
        if (task.state == SDLURLRequestTaskStateCompleted) {
            [task removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
            [self.activeTasks removeObject:object];
        }
    }
}

@end

NS_ASSUME_NONNULL_END
