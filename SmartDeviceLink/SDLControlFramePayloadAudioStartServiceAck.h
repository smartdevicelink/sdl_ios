//
//  SDLControlFramePayloadAudioStartServiceAck.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/24/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLControlFramePayloadType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLControlFramePayloadAudioStartServiceAck : NSObject

@property (assign, nonatomic, readonly) int32_t hashId;
@property (assign, nonatomic, readonly) int64_t mtu;

- (instancetype)initWithHashId:(int32_t)hashId mtu:(int64_t)mtu;

@end

NS_ASSUME_NONNULL_END
