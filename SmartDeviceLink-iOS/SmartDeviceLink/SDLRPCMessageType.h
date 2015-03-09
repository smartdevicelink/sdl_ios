//  SDLRPCMessageType.h
//

@import Foundation;

typedef NS_ENUM(Byte, SDLRPCMessageType) {
    SDLRPCMessageTypeRequest,
    SDLRPCMessageTypeResponse,
    SDLRPCMessageTypeNotification
};
