//  SDLSetMediaClockTimerResponse.h
//


#import "SDLRPCResponse.h"

/**
 * Set Media Clock Timer Response is sent, when SDLSetMediaClockTimer has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLSetMediaClockTimerResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLSetMediaClockTimerResponse object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLSetMediaClockTimerResponse object indicated by the NSMutableDictionary
 * parameter
 * <p>
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@end
