//  SDLAmbientLightStatus.h
//
//  
/** Reflects the status of the ambient light sensor.
 *
 * <b>Since</b> SmartDeviceLink 3.0
 *
 */
#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLAmbientLightStatus : SDLEnum {}

+(SDLAmbientLightStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLAmbientLightStatus*) NIGHT;
+(SDLAmbientLightStatus*) TWILIGHT_1;
+(SDLAmbientLightStatus*) TWILIGHT_2;
+(SDLAmbientLightStatus*) TWILIGHT_3;
+(SDLAmbientLightStatus*) TWILIGHT_4;
+(SDLAmbientLightStatus*) DAY;
+(SDLAmbientLightStatus*) UNKNOWN;
+(SDLAmbientLightStatus*) INVALID;

@end
