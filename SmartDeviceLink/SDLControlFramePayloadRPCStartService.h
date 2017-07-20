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

@property (copy, nonatomic, readonly) NSString *protocolVersion;

- (instancetype)initWithMajorVersion:(NSUInteger)majorVersion minorVersion:(NSUInteger)minorVersion patchVersion:(NSUInteger)patchVersion;
- (instancetype)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
