//
//  SDLSecondaryTransportPrimaryProtocolHandler.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 2018/08/09.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import "SDLProtocolListener.h"

@class SDLProtocol;
@class SDLSecondaryTransportManager;

NS_ASSUME_NONNULL_BEGIN

/**
 A class to receive event from primary transport.
 */
@interface SDLSecondaryTransportPrimaryProtocolHandler : NSObject <SDLProtocolListener>

/** The header of Start Service ACK frame received on primary transport. */
@property (copy, nonatomic) SDLProtocolHeader *primaryRPCHeader;

/**
 Create a new primary protocol handler with given SDLSecondaryTransportManager and SDLProtocol instances.

 @param manager instance of SDLSecondaryTransportManager
 @param primaryProtocol instance of SDLProtocol for the primary transport
 @return A new primary protocol handler
 */
- (instancetype)initWithSecondaryTransportManager:(SDLSecondaryTransportManager *)manager
                                  primaryProtocol:(SDLProtocol *)primaryProtocol;

/**
 *  Start the handler.
 */
- (void)start;

/**
 *  Stop the handler.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
