//
//  SDLSecondaryTransportManager.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 2018/02/28.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import "SDLProtocolDelegate.h"
#import "SDLStreamingProtocolDelegate.h"

@class SDLControlFramePayloadRPCStartServiceAck;
@class SDLControlFramePayloadTransportEventUpdate;
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
@interface SDLSecondaryTransportManager : NSObject <SDLProtocolDelegate>

/// Create a new secondary transport manager.
/// @param streamingProtocolDelegate a delegate to handle updates on protocol instances
/// @param queue a serial dispatch queue that the internal state machine runs on
- (instancetype)initWithStreamingProtocolDelegate:(id<SDLStreamingProtocolDelegate>)streamingProtocolDelegate
                                      serialQueue:(dispatch_queue_t)queue;

/// Start the manager.
/// @param primaryProtocol The protocol that runs on the main (primary) transport
- (void)startWithPrimaryProtocol:(SDLProtocol *)primaryProtocol;

/// Stop the manager
/// @param completionHandler Handler called when the manager has shutdown
- (void)stopWithCompletionHandler:(void (^)(void))completionHandler;

/// Destroys the secondary transport.
/// @param completionHandler Handler called when the session has been destroyed
- (void)disconnectSecondaryTransportWithCompletionHandler:(void (^)(void))completionHandler;

@end

NS_ASSUME_NONNULL_END
