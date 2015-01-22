//  SDLRPCResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLResult.h>

@interface SDLRPCResponse : SDLRPCMessage {}

@property(strong) NSNumber* correlationID;
@property(strong) NSNumber* success;
@property(strong) SDLResult* resultCode;
@property(strong) NSString* info;

@end
