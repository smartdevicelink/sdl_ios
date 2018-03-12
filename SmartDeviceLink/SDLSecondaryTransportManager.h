//
//  SDLSecondaryTransportManager.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 2018/02/28.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import "SDLProtocolListener.h"
#import "SDLStreamingProtocolListener.h"

@class SDLProtocol;
@class SDLStateMachine;

NS_ASSUME_NONNULL_BEGIN

typedef NSString SDLSecondaryTransportState;
extern SDLSecondaryTransportState *const SDLSecondaryTransportStateStopped;
extern SDLSecondaryTransportState *const SDLSecondaryTransportStateStarted;
extern SDLSecondaryTransportState *const SDLSecondaryTransportStateConfigured;
extern SDLSecondaryTransportState *const SDLSecondaryTransportStateConnecting;
extern SDLSecondaryTransportState *const SDLSecondaryTransportStateRegistered;
extern SDLSecondaryTransportState *const SDLSecondaryTransportStateReconnecting;

/**
 A class to control and manage secondary transport feature.
 
 Secondary transport manager does most of the things required for the feature. It listens
 on the primary transport and receives necessary information through Version Negotiation
 and TransportEventUpdate control frame. It initiates secondary transport's connection
 and sets up SDLProtocol that runs on the transport. Then it starts streaming media
 manager with appropriate SDLProtocol instance. When the secondary transport is
 disconnected, this manager retries connection with a regular interval.
 */
@interface SDLSecondaryTransportManager : NSObject <SDLProtocolListener>

/// state of this manager
@property (strong, nonatomic, readonly) SDLStateMachine *stateMachine;

/**
 Create a new secondary transport manager.

 @param streamingProtocolListener a listener to handle updates on protocol instances
 @return A new secondary transport manager
 */
- (instancetype)initWithStreamingProtocolListener:(id<SDLStreamingProtocolListener>)streamingProtocolListener;

/**
 *  Start the manager.

 @param primaryProtocol protocol that runs on the main (primary) transport
 */
- (void)startWithProtocol:(SDLProtocol *)primaryProtocol;

/**
 *  Stop the manager.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
