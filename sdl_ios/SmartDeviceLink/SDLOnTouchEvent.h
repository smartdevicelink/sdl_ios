//  SDLOnTouchEvent.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCNotification.h>

#import <SmartDeviceLink/SDLTouchType.h>

@interface SDLOnTouchEvent : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLTouchType* type;
@property(strong) NSMutableArray* event;

@end
