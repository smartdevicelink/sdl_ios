//
//  SDLDisconnectReason.h
//  SmartDeviceLink
//
//  Copyright (c) 2015 FMC. All rights reserved.
//

typedef NS_ENUM(UInt8, SDLDisconnectReason) {
    SDLDisconnectReasonAppInterfaceUnregistered,
    SDLDisconnectReasonTransportDisconnected,
    SDLDisconnectReasonTransportError,
    SDLDisconnectReasonGenericError,
    SDLDisconnectReasonRegistrationError
};
