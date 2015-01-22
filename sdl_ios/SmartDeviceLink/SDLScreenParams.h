//  SDLScreenParams.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLImageResolution.h>
#import <SmartDeviceLink/SDLTouchEventCapabilities.h>

@interface SDLScreenParams : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLImageResolution* resolution;
@property(strong) SDLTouchEventCapabilities* touchEventAvailable;

@end
