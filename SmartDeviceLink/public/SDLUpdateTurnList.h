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

NS_ASSUME_NONNULL_BEGIN

@interface SDLUpdateTurnList : SDLRPCRequest

/// Convenience init to update a list of maneuvers for navigation
///
/// @param turnList A struct used in UpdateTurnList for Turn-by-Turn navigation applications
/// @param softButtons An array of softbuttons
- (instancetype)initWithTurnList:(nullable NSArray<SDLTurn *> *)turnList softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons;

/**
 *  Optional, SDLTurn, 1 - 100 entries
 */
@property (strong, nonatomic, nullable) NSArray<SDLTurn *> *turnList;

/**
 *  Required, SDLSoftButton, 0 - 1 Entries
 */
@property (strong, nonatomic, nullable) NSArray<SDLSoftButton *> *softButtons;

@end

NS_ASSUME_NONNULL_END
