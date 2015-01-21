//  SDLRPCMessageType.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>

/**
 *  Enumeration linking message types with function types.
 */
typedef NS_ENUM(Byte, SDLRPCMessageType){
    SDLRPCMessageTypeRequest = 0,
    SDLRPCMessageTypeResponse,
    SDLRPCMessageTypeNotification
};
