//  SDLRPCMessageType.h
//

#import <Foundation/Foundation.h>

#import "SDLEnum.h"

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

typedef SDLEnum SDLRPCMessageTypeName SDL_SWIFT_ENUM;

extern SDLRPCMessageTypeName const SDLRPCMessageTypeNameRequest;
extern SDLRPCMessageTypeName const SDLRPCMessageTypeNameResponse;
extern SDLRPCMessageTypeName const SDLRPCMessageTypeNameNotification;
