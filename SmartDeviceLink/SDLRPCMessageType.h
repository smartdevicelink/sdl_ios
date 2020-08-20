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

/// A type of RPC message
typedef SDLEnum SDLRPCMessageTypeName SDL_SWIFT_ENUM;

/// A request that will require a response
extern SDLRPCMessageTypeName const SDLRPCMessageTypeNameRequest;

/// A response to a request
extern SDLRPCMessageTypeName const SDLRPCMessageTypeNameResponse;

/// A message that does not have a response
extern SDLRPCMessageTypeName const SDLRPCMessageTypeNameNotification;
