//  SDLRPCMessageType.h
//

#import <Foundation/Foundation.h>

/**
 The type of RPC message

 - SDLRPCMessageTypeRequest: A request from the app to the IVI system
 - SDLRPCMessageTypeResponse: A response from the IVI system to the app
 - SDLRPCMessageTypeNotification: A notification from the IVI system to the app
 */
typedef NS_ENUM(Byte, SDLRPCMessageType) {
    SDLRPCMessageTypeRequest = 0,
    SDLRPCMessageTypeResponse,
    SDLRPCMessageTypeNotification
};
