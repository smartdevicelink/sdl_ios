//
//  TestConnectionManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 11/6/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLConnectionManagerType.h"
#import "SDLNotificationConstants.h"
#import "TestConnectionRequestObject.h"


NS_ASSUME_NONNULL_BEGIN

@interface TestConnectionManager : NSObject <SDLConnectionManagerType>

@property (strong, nonatomic, nullable) SDLSystemInfo *systemInfo;

@property (copy, nonatomic, readonly) NSError *defaultError;

/**
 *  All received requests. Chronological order. The 0th element will be the first request received; the nth request will be the n+1th request received.
 */
@property (copy, nonatomic, readonly) NSMutableArray<__kindof TestConnectionRequestObject *> *receivedRequestObjects;

@property (copy, nonatomic, readonly) NSArray<__kindof SDLRPCMessage *> *receivedRequests;

@property (copy, nonatomic, nullable) NSMutableArray<SDLMultipleRequestCompletionHandler> *multipleCompletionBlocks;

/**
 *  Call the last request's block with a specific response.
 *
 *  @param response The RPC Response to pass into the last request's block.
 */
- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response;

/**
 * Call the last request's block with a specific response, request, and error.

 @param response    The RPC Response to pass into the last request's block.
 @param requestNumber The request to pass into the last request's block.
 @param error       The error to pass into the last request's block.
 */
- (void)respondToRequestWithResponse:(__kindof SDLRPCResponse *)response requestNumber:(NSInteger)requestNumber error:(nullable NSError *)error;

/**
 Call the last request's block with a specific response.

 @param response The RPC Response to pass into the last request's block.
 @param error The error to pass into the last request's block.
 */
- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response error:(nullable NSError *)error;

- (void)respondToLastMultipleRequestsWithSuccess:(BOOL)success;

/**
 *  Remove all received requests.
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END
