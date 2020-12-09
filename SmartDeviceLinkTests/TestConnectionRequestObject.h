//
//  TestConnectionRequestObject.h
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 11/13/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SmartDeviceLink.h>

NS_ASSUME_NONNULL_BEGIN

@interface TestConnectionRequestObject : NSObject

@property (strong, nonatomic) __kindof SDLRPCMessage *message;
@property (copy, nonatomic, nullable) SDLResponseHandler responseHandler;

- (instancetype)initWithMessage:(__kindof SDLRPCMessage *)message responseHandler:(nullable SDLResponseHandler)handler;

@end

NS_ASSUME_NONNULL_END
