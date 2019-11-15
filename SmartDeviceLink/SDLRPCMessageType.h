//  SDLRPCMessageType.h
//

#import <Foundation/Foundation.h>

/**
 The type of RPC message
 */
typedef NS_ENUM(Byte, SDLRPCMessageType) {
    /// A request that will require a response
    SDLRPCMessageTypeRequest = 0,

    /// A response to a request
    SDLRPCMessageTypeResponse,

    /// A message that does not have a response
    SDLRPCMessageTypeNotification
};
