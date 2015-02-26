//  SDLAlertManeuver.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

/**
 @Since SmartDeviceLink 1.0
 */
@interface SDLAlertManeuver : SDLRPCRequest {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSMutableArray* ttsChunks;
@property(strong) NSMutableArray* softButtons;

@end
