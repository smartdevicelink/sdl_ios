//  SDLAlertManeuver.h
//


#import "SDLRPCRequest.h"

/**
 *  @since SmartDeviceLink 1.0
 */
@interface SDLAlertManeuver : SDLRPCRequest

@property (strong) NSMutableArray *ttsChunks;
@property (strong) NSMutableArray *softButtons;

@end
