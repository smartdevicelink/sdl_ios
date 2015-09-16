//
//  SDLURLRequestTask.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/17/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLURLRequestTask;
@class SDLURLSession;


typedef void (^SDLURLConnectionRequestCompletionHandler)(NSData *__nullable data, NSURLResponse *__nullable response, NSError *__nullable error);

typedef NS_ENUM(NSUInteger, SDLURLRequestTaskState) {
    SDLURLRequestTaskStateRunning,
    SDLURLRequestTaskStateCompleted
};


NS_ASSUME_NONNULL_BEGIN

@protocol SDLURLRequestTaskDelegate <NSObject>

- (void)taskDidFinish:(SDLURLRequestTask *)task;

@end


@interface SDLURLRequestTask : NSObject

@property (weak, nonatomic) id<SDLURLRequestTaskDelegate> delegate;
@property (assign, nonatomic) SDLURLRequestTaskState state;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithURLRequest:(NSURLRequest *)request completionHandler:(SDLURLConnectionRequestCompletionHandler)completionHandler NS_DESIGNATED_INITIALIZER;

+ (instancetype)taskWithURLRequest:(NSURLRequest *)request completionHandler:(SDLURLConnectionRequestCompletionHandler)completionHandler;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
