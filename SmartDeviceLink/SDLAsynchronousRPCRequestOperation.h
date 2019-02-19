//
//  SDLRPCRequestOperation.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 1/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLAsynchronousOperation.h"
#import "SDLLifecycleManager.h"

@class SDLRPCMessage;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

@interface SDLAsynchronousRPCRequestOperation : SDLAsynchronousOperation

//@property (copy, nonatomic) NSArray<SDLRPCRequest *> *requests;
@property (copy, nonatomic) NSArray<__kindof SDLRPCMessage *> *rpcs;

// TODO: NEW
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager rpc:(__kindof SDLRPCMessage *)rpc responseHandler:(nullable SDLResponseHandler)responseHandler;

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager rpcs:(NSArray<__kindof SDLRPCMessage *> *)rpcs progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler;

////

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager requests:(NSArray<SDLRPCRequest *> *)requests progressHandler:(nullable SDLMultipleAsyncRequestProgressHandler)progressHandler completionHandler:(nullable SDLMultipleRequestCompletionHandler)completionHandler;

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager request:(SDLRPCRequest *)request responseHandler:(nullable SDLResponseHandler)responseHandler;

@end

NS_ASSUME_NONNULL_END
