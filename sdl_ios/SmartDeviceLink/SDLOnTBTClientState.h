//  SDLOnTBTClientState.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

#import <SmartDeviceLink/SDLTBTState.h>

@interface SDLOnTBTClientState : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLTBTState* state;

@end
