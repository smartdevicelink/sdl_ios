//  SDLTouchEventCapabilities.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

@interface SDLTouchEventCapabilities : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* pressAvailable;
@property(strong) NSNumber* multiTouchAvailable;
@property(strong) NSNumber* doublePressAvailable;

@end
