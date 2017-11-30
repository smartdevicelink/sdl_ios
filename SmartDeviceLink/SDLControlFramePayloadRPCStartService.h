//
//  SDLControlFrameStartService.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/18/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadRPCStartService : NSObject <SDLControlFramePayloadType>

/// The max version of protocol version supported by client requesting service to start. Must be in the format "Major.Minor.Patch"
@property (copy, nonatomic, readonly, nullable) NSString *protocolVersion;

- (instancetype)initWithVersion:(nullable NSString *)stringVersion;

@end

NS_ASSUME_NONNULL_END
