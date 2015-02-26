//  SDLOnKeyboardInput.h
//
// 

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

#import <SmartDeviceLink/SDLKeyboardEvent.h>

@interface SDLOnKeyboardInput : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLKeyboardEvent* event;
@property(strong) NSString* data;

@end
