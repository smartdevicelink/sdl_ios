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


NS_ASSUME_NONNULL_BEGIN

@interface TestConnectionManager : NSObject <SDLConnectionManagerType>

/**
 *  All received requests. Chronological order. The 0th element will be the first request received; the nth request will be the n+1th request received.
 */
@property (copy, nonatomic, readonly) NSMutableArray<__kindof SDLRPCRequest *> *receivedRequests;

/**
 *  The block passed for the last request send with sendRequest:withCompletionHandler:
 */
@property (copy, nonatomic, nullable) SDLResponseHandler lastRequestBlock;

/**
 *  Call the last request's block with a specific response.
 *
 *  @param response The RPC Response to pass into the last request's block.
 */
- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response;

/**
 *  Call the last request's block with a specific response and error.
 *
 *  @param response The response to pass into the last request's block.
 *  @param error    The error to pass into the last request's block.
 */
- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *_Nullable)response error:( NSError *_Nullable)error;

/**
 *  Remove all received requests.
 */
- (void)reset;

@end

NS_ASSUME_NONNULL_END