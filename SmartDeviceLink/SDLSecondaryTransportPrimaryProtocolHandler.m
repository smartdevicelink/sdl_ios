//
//  SDLSecondaryTransportPrimaryProtocolHandler.m
//  SmartDeviceLink
//
//  Created by Sho Amano on 2018/08/09.
//  Copyright © 2018 Xevo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLSecondaryTransportPrimaryProtocolHandler.h"

#import "SDLControlFramePayloadRPCStartServiceAck.h"
#import "SDLControlFramePayloadTransportEventUpdate.h"
#import "SDLLogMacros.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLSecondaryTransportManager.h"

@interface SDLSecondaryTransportPrimaryProtocolHandler ()
@property (weak, nonatomic) SDLSecondaryTransportManager *secondaryTransportManager;
@property (weak, nonatomic) SDLProtocol *primaryProtocol;
@end

@implementation SDLSecondaryTransportPrimaryProtocolHandler

- (instancetype)initWithSecondaryTransportManager:(SDLSecondaryTransportManager *)manager
                                  primaryProtocol:(SDLProtocol *)primaryProtocol {
    self = [super init];
    if (!self) {
        return nil;
    }

    _secondaryTransportManager = manager;
    _primaryProtocol = primaryProtocol;

    return self;
}

- (void)start {
    @synchronized(self.primaryProtocol.protocolDelegateTable) {
        [self.primaryProtocol.protocolDelegateTable addObject:self];
    }
}

- (void)stop {
    @synchronized(self.primaryProtocol.protocolDelegateTable) {
        [self.primaryProtocol.protocolDelegateTable removeObject:self];
    }
}

// called from protocol's _reeiveQueue of Primary Transport
- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    if (startServiceACK.header.serviceType != SDLServiceTypeRPC) {
        return;
    }

    SDLLogV(@"Received Start Service ACK header of RPC service on primary transport");

    // keep header to acquire Session ID
    self.primaryRPCHeader = startServiceACK.header;

    SDLControlFramePayloadRPCStartServiceAck *payload = [[SDLControlFramePayloadRPCStartServiceAck alloc] initWithData:startServiceACK.payload];

    [self.secondaryTransportManager onStartServiceAckReceived:payload];
}

// called from protocol's _reeiveQueue of Primary Transport
- (void)handleTransportEventUpdateMessage:(SDLProtocolMessage *)transportEventUpdate {
    SDLControlFramePayloadTransportEventUpdate *payload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithData:transportEventUpdate.payload];
    SDLLogV(@"Transport Config Update: %@", payload);

    [self.secondaryTransportManager onTransportEventUpdateReceived:payload];
}

@end
