//  SDLHeadLampStatus.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessage.h>

#import <SmartDeviceLink/SDLAmbientLightStatus.h>

/**
 * Status of the head lamps
 */
@interface SDLHeadLampStatus : SDLRPCStruct {}

/**
 * @abstract Constructs a new SDLHeadLampStatus object
 */
-(id) init;

/**
 * @abstract Constructs a new SDLHeadLampStatus object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract A boolean value. Status of the low beam lamps.
 */
@property(strong) NSNumber* lowBeamsOn;
/**
 * @abstract A boolean value. Status of the high beam lamps.
 */
@property(strong) NSNumber* highBeamsOn;
@property(strong) SDLAmbientLightStatus* ambientLightSensorStatus;

@end
