//
//  SDLSecondaryTransportManager.h
//  SmartDeviceLink-iOS
//
//  Created by Sho Amano on 2018/02/28.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import "SDLProtocolListener.h"
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
@interface SDLSecondaryTransportManager : NSObject <SDLProtocolListener>

/** state of this manager */
@property (strong, nonatomic, readonly) SDLStateMachine *stateMachine;

/**
 Create a new secondary transport manager.

 @param streamingProtocolDelegate a delegate to handle updates on protocol instances
 @param queue a serial dispatch queue that the internal state machine runs on
 @return A new secondary transport manager
 */
- (instancetype)initWithStreamingProtocolDelegate:(id<SDLStreamingProtocolDelegate>)streamingProtocolDelegate
                                      serialQueue:(dispatch_queue_t)queue;

/**
 *  Start the manager.

 @param primaryProtocol protocol that runs on the main (primary) transport
 */
- (void)startWithPrimaryProtocol:(SDLProtocol *)primaryProtocol;

/**
 *  Stop the manager.
 */
- (void)stop;

/**
 * Call this method when Start Service ACK control frame is received on primary transport.

 @param payload payload of Start Service ACK frame received on the primary transport
 */
- (void)onStartServiceAckReceived:(SDLControlFramePayloadRPCStartServiceAck *)payload;

/**
 * Call this method when Transport Event Update control frame is received on primary transport.

 @param payload payload of Transport Event Update frame received on the primary transport
 */
- (void)onTransportEventUpdateReceived:(SDLControlFramePayloadTransportEventUpdate *)payload;

@end

NS_ASSUME_NONNULL_END
