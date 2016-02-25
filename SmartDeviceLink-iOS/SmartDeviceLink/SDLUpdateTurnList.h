//  SDLUpdateTurnList.h
//


#import "SDLRPCRequest.h"

/** Updates the list of next maneuvers, which can be requested by the user pressing the softbutton<br>
 * “Turns” on the Navigation base screen. Three softbuttons are predefined by the system: Up, Down, Close.
 *<p>
 * @since SmartDeviceLink 2.0
 */
@interface SDLUpdateTurnList : SDLRPCRequest {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 *  Optional, SDLTurn, 1 - 100 entries
 */
@property (strong) NSMutableArray *turnList;

/**
 *  Required, SDLSoftButton, 0 - 1 Entries
 */
@property (strong) NSMutableArray *softButtons;

@end
