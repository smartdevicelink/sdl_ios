//
//  SDLURLConnection.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/17/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SDLURLConnectionRequestCompletionHandler)(NSData *__nullable data, NSURLResponse *__nullable response, NSError *__nullable error);


NS_ASSUME_NONNULL_BEGIN

@interface SDLURLSession : NSObject

@property (assign, nonatomic) NSURLRequestCachePolicy cachePolicy;

/**
 *  If any task is started with a request that is at the default timeout (60.0 sec), it will be altered to this connection timeout (by default 45.0 sec).
 */
@property (assign, nonatomic) NSTimeInterval connectionTimeout;

/**
 *  Get the default session, a singleton.
 *
 *  @return The default session
 */
+ (instancetype)defaultSession;

/**
 *  Retrieves data from a specified URL. Default settings for timeout and cache policy will be used.
 *
 *  @param url               An NSURLRequest will be assembled for this URL
 *  @param completionHandler The completion handler that will be called when the request is complete
 */
- (void)dataFromURL:(NSURL *)url completionHandler:(SDLURLConnectionRequestCompletionHandler)completionHandler;

/**
 *  Starts a URL request using data supplied.
 *
 *  @param request           An NSURLRequest that provides the URL, cache policy, request method, etc. The HTTPBody data in this request will be ignored
 *  @param data              The data to be uploaded over HTTP
 *  @param completionHandler The completion handler that will be called when the request is complete
 */
- (void)uploadWithURLRequest:(NSURLRequest *)request data:(NSData *)data completionHandler:(SDLURLConnectionRequestCompletionHandler)completionHandler;

/**
 *  Tells all pending requests to cancel
 */
- (void)cancelAllTasks;

@end

NS_ASSUME_NONNULL_END
