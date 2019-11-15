//  SDLDeleteInteractionChoiceSet.h
//


#import "SDLRPCRequest.h"

/**
 * Deletes an existing Choice Set identified by the parameter
 * interactionChoiceSetID. If the specified interactionChoiceSetID is currently
 * in use by an active <i> SDLPerformInteraction</i> this call to
 * delete the Choice Set will fail returning an IN_USE resultCode
 * <p>
 * Function Group: Base
 * <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUD</b><br/>
 * </p>
 *
 * Since <b>SmartDeviceLink 1.0</b><br>
 * see SDLCreateInteractionChoiceSet SDLPerformInteraction
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLDeleteInteractionChoiceSet : SDLRPCRequest

/// Convenience init to delete a choice set
///
/// @param choiceId A unique ID that identifies the Choice Set
/// @return An SDLDeleteInteractionChoiceSet object
- (instancetype)initWithId:(UInt32)choiceId;

/**
 * a unique ID that identifies the Choice Set
 * @discussion a unique ID that identifies the Choice Set
 * <p>
 * <b>Notes: </b>Min Value: 0; Max Value: 2000000000
 */
@property (strong, nonatomic) NSNumber<SDLInt> *interactionChoiceSetID;

@end

NS_ASSUME_NONNULL_END
