//
//  SDLPrimaryProtocolListener.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 2018/08/01.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "SDLProtocolListener.h"

@class SDLProtocol;

NS_ASSUME_NONNULL_BEGIN

/**
 A class to receive event from primary transport.
 */
@interface SDLPrimaryProtocolListener : NSObject <SDLProtocolListener>

/// The header of Start Service ACK frame received on primary transport.
@property (copy, nonatomic) SDLProtocolHeader *primaryRPCHeader;

/**
 Create a new primary protocol listener with given SDLProtocol instance.

 @param primaryProtocol instance of SDLProtocol for the primary transport
 @return A new primary protocol listener
 */
- (instancetype)initWithProtocol:(SDLProtocol *)primaryProtocol;

/**
 *  Start the listener.
 */
- (void)start;

/**
 *  Stop the listener.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
