//  SDLAlertManeuver.h
//


#import "SDLRPCRequest.h"

/**
 *  @since SmartDeviceLink 1.0
 */
@interface SDLAlertManeuver : SDLRPCRequest {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) NSMutableArray *ttsChunks;
@property (strong) NSMutableArray *softButtons;

@end
