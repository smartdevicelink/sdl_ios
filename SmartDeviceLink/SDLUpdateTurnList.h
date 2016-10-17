//  SDLUpdateTurnList.h
//


#import "SDLRPCRequest.h"

@class SDLSoftButton;
@class SDLTurn;

/** Updates the list of next maneuvers, which can be requested by the user pressing the softbutton<br>
 * “Turns” on the Navigation base screen. Three softbuttons are predefined by the system: Up, Down, Close.
 *<p>
 * @since SmartDeviceLink 2.0
 */
@interface SDLUpdateTurnList : SDLRPCRequest

/**
 *  Optional, SDLTurn, 1 - 100 entries
 */
@property (strong) NSMutableArray<SDLTurn *> *turnList;

/**
 *  Required, SDLSoftButton, 0 - 1 Entries
 */
@property (strong) NSMutableArray<SDLSoftButton *> *softButtons;

@end
