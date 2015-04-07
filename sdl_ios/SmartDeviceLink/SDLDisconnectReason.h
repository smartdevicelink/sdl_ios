//
//  SDLDisconnectReason.h
//  SmartDeviceLink
//
//  Created by Militello, Kevin (K.) on 3/26/15.
//  Copyright (c) 2015 FMC. All rights reserved.
//

typedef NS_ENUM(UInt8, SDLDisconnectReason) {
    SDLDisconnectReasonAppInterfaceUnregistered,
    SDLDisconnectReasonTransportDisconnected,
    SDLDisconnectReasonTransportError,
    SDLDisconnectReasonGenericError,
    SDLDisconnectReasonRegistrationError
};
