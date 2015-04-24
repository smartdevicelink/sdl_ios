//  SDLAudioType.h
//



#import "SDLEnum.h"

/**
 Describes different audio type options for PerformAudioPassThru
 */
@interface SDLAudioType : SDLEnum {}

/**
 * @abstract Convert String to SDLAudioType
 * @param value NSString
 * @result SDLAudioType
 */
+(SDLAudioType*) valueOf:(NSString*) value;

/**
 @abstract Store the enumeration of all possible SDLAudioType
 @result return an array that store all possible SDLAudioType
 */
+(NSArray*) values;

/**
 @abstract PCM raw audio
 @since <font color=red><b>SmartDeviceLink 2.0</b></font>
 @result SDLAudioType with value of <font color=gray><i>PCM</i></font>
 */
+(SDLAudioType*) PCM;

@end