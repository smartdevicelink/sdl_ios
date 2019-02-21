//
//  SDLRPCResponseOperation.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/20/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDLAsynchronousOperation.h"
#import "SDLLifecycleManager.h"

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCResponseOperation : SDLAsynchronousOperation

@property (copy, nonatomic) __kindof SDLRPCMessage *rpc;

- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager rpc:(__kindof SDLRPCMessage *)rpc;

@end

NS_ASSUME_NONNULL_END
