//
//  SDLPrimaryProtocolListener.m
//  SmartDeviceLink
//
//  Created by Sho Amano on 2018/08/01.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLPrimaryProtocolListener.h"

#import "SDLControlFramePayloadRPCStartServiceAck.h"
#import "SDLControlFramePayloadTransportEventUpdate.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLProtocol.h"
#import "SDLProtocolMessage.h"
#import "SDLSecondaryTransportManagerConstants.h"

@interface SDLPrimaryProtocolListener ()
@property (weak, nonatomic) SDLProtocol *primaryProtocol;
@end

@implementation SDLPrimaryProtocolListener

- (instancetype)initWithProtocol:(SDLProtocol *)primaryProtocol {
    self = [super init];
    if (!self) {
        return nil;
    }

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

    NSDictionary<NSString *, id> *userInfo = @{SDLNotificationUserInfoObject: payload};
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLStartSecondaryTransportManagerNotification object:self userInfo:userInfo];
}

// called from protocol's _reeiveQueue of Primary Transport
- (void)handleTransportEventUpdateMessage:(SDLProtocolMessage *)transportEventUpdate {
    SDLControlFramePayloadTransportEventUpdate *payload = [[SDLControlFramePayloadTransportEventUpdate alloc] initWithData:transportEventUpdate.payload];
    SDLLogV(@"Transport Config Update: %@", payload);

    NSDictionary<NSString *, id> *userInfo = @{SDLNotificationUserInfoObject: payload};
    [[NSNotificationCenter defaultCenter] postNotificationName:SDLTransportEventUpdateNotification object:self userInfo:userInfo];
}

@end
