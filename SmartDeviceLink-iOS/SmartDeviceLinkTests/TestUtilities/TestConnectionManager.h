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


@interface TestConnectionManager : NSObject<SDLConnectionManagerType>

@property (copy, nonatomic, readonly) NSMutableArray<__kindof SDLRPCRequest *> *receivedRequests;
@property (copy, nonatomic) SDLRequestCompletionHandler lastRequestBlock;

- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response;
- (void)respondToLastRequestWithResponse:(__kindof SDLRPCResponse *)response error:(NSError *)error;

@end
