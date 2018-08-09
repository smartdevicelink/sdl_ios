//
//  SDLPrimaryProtocolDelegate.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 2018/08/09.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import "SDLProtocolListener.h"

@class SDLProtocol;

NS_ASSUME_NONNULL_BEGIN

/**
 A class to receive event from primary transport.
 */
@interface SDLPrimaryProtocolDelegate : NSObject <SDLProtocolListener>

/** The header of Start Service ACK frame received on primary transport. */
@property (copy, nonatomic) SDLProtocolHeader *primaryRPCHeader;

/**
 Create a new primary protocol delegate with given SDLProtocol instance.

 @param primaryProtocol instance of SDLProtocol for the primary transport
 @return A new primary protocol delegate
 */
- (instancetype)initWithProtocol:(SDLProtocol *)primaryProtocol;

/**
 *  Start the delegate.
 */
- (void)start;

/**
 *  Stop the delegate.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
