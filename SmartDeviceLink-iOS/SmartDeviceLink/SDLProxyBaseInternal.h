//
//  SDLProxyBaseInternal.h
//  SmartDeviceLink-iOS
//
//  Created by Aaron on 9/9/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

@interface SDLManager ()

// Methods called by SDLProxyListenerBase in response to Events, and RPC Responses and Notifications
- (void)notifyDelegatesOfEvent:(SDLEvent)sdlEvent error:(NSException *)error;
- (void)runHandlersForResponse:(SDLRPCResponse *)response;
- (void)notifyDelegatesOfNotification:(SDLRPCNotification *)notification;

@end
