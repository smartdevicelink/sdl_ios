//
//  SDLProxyBaseInternal.h
//  SmartDeviceLink-iOS
//
//  Created by Aaron on 9/9/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#ifndef SmartDeviceLink_iOS_SDLProxyBaseInternal_h
#define SmartDeviceLink_iOS_SDLProxyBaseInternal_h

@interface SDLProxyBase ()

// Methods called by SDLProxyListenerBase in response to Events, and RPC Responses and Notifications
- (void)notifyDelegatesOfEvent:(enum SDLEvent)sdlEvent error:(NSException *)error;
- (void)runHandlersForResponse:(SDLRPCResponse *)response;
- (void)notifyDelegatesOfNotification:(SDLRPCNotification *)notification;

@end

#endif
