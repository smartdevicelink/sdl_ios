//  SDLRPCMessageType.h
//

@import Foundation;

typedef NS_ENUM(Byte, SDLRPCMessageType) {
    SDLRPCMessageTypeRequest = 0,
    SDLRPCMessageTypeResponse,
    SDLRPCMessageTypeNotification
};
