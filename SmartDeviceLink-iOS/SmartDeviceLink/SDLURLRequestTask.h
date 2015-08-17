//
//  SDLURLRequestTask.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/17/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLURLSession;


typedef void (^SDLURLConnectionRequestCompletionHandler)(NSData *__nullable data, NSURLResponse *__nullable response, NSError *__nullable error);

typedef NS_ENUM(NSUInteger, SDLURLRequestTaskState) {
    SDLURLRequestTaskStateRunning,
    SDLURLRequestTaskStateCompleted
};

NS_ASSUME_NONNULL_BEGIN

@interface SDLURLRequestTask : NSObject

@property (copy, nonatomic, readonly) SDLURLConnectionRequestCompletionHandler completionHandler;
@property (strong, nonatomic, readonly) NSData *data;
@property (strong, nonatomic, nullable) NSURLResponse *response;
@property (assign, nonatomic) SDLURLRequestTaskState state;

- (instancetype)initWithURLRequest:(NSURLRequest *)request completionHandler:(SDLURLConnectionRequestCompletionHandler)completionHandler;

- (void)addData:(NSData *)data;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
