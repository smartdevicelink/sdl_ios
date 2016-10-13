//  SDLAlertManeuver.h
//


#import "SDLRPCRequest.h"

@class SDLSoftButton;
@class SDLTTSChunk;

/**
 *  @since SmartDeviceLink 1.0
 */
@interface SDLAlertManeuver : SDLRPCRequest

@property (strong) NSMutableArray<SDLTTSChunk *> *ttsChunks;
@property (strong) NSMutableArray<SDLSoftButton *> *softButtons;

@end
