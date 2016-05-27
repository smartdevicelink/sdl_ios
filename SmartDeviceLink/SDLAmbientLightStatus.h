//  SDLAmbientLightStatus.h
//


#import "SDLEnum.h"

/**
 * Reflects the status of the ambient light sensor
 * @since SDL 3.0
 */
@interface SDLAmbientLightStatus : SDLEnum {
}

+ (SDLAmbientLightStatus *)valueOf:(NSString *)value;
+ (NSArray *)values;

+ (SDLAmbientLightStatus *)NIGHT;
+ (SDLAmbientLightStatus *)TWILIGHT_1;
+ (SDLAmbientLightStatus *)TWILIGHT_2;
+ (SDLAmbientLightStatus *)TWILIGHT_3;
+ (SDLAmbientLightStatus *)TWILIGHT_4;
+ (SDLAmbientLightStatus *)DAY;
+ (SDLAmbientLightStatus *)UNKNOWN;
+ (SDLAmbientLightStatus *)INVALID;

@end
