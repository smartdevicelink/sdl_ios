//  SDLRPCMessageType.h
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(Byte, SDLRPCMessageType) {
    SDLRPCMessageTypeRequest = 0,
    SDLRPCMessageTypeResponse,
    SDLRPCMessageTypeNotification
};
