//  SDLRPCMessageType.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>


typedef NS_ENUM(Byte, SDLRPCMessageType) {
    SDLRPCMessageTypeRequest,
    SDLRPCMessageTypeResponse,
    SDLRPCMessageTypeNotification
};