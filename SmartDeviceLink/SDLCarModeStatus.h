//  SDLCarModeStatus.h
//


#import "SDLEnum.h"

/** Describes the carmode the vehicle is in.
 * <b>Since</b> SmartDeviceLink 2.0
 */
SDLEnum(SDLCarModeStatus);

/** Provides carmode NORMAL to each module.
 */
extern SDLCarModeStatus const SDLCarModeStatusNormal;

/** Provides carmode FACTORY to each module.
 */
extern SDLCarModeStatus const SDLCarModeStatusFactory;

/** Provides carmode TRANSPORT to each module.
 */
extern SDLCarModeStatus const SDLCarModeStatusTransport;

/** Provides carmode CRASH to each module.
 */
extern SDLCarModeStatus const SDLCarModeStatusCrash;
