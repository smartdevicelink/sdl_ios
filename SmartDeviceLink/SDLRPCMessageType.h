//  SDLRPCMessageType.h
//

#import <Foundation/Foundation.h>

/**
 The type of RPC message
 */
typedef NS_ENUM(Byte, SDLRPCMessageType) {
    /// A request from the app to the IVI system
    SDLRPCMessageTypeRequest = 0,

    /// A response from the IVI system to the app
    SDLRPCMessageTypeResponse,

    /// A notification from the IVI system to the app
    SDLRPCMessageTypeNotification
};
