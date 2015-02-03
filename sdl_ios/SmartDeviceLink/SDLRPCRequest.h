//  SDLRPCRequest.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

@interface SDLRPCRequest : SDLRPCMessage {}

@property(strong) NSNumber* correlationID;

@end
