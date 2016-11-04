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
@interface SDLDeleteInteractionChoiceSet : SDLRPCRequest {
}

/**
 * Constructs a new SDLDeleteInteractionChoiceSet object
 */
- (instancetype)init;
/**
 * Constructs a new SDLDeleteInteractionChoiceSet object indicated by the
 * NSMutableDictionary parameter
 * <p>
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithId:(UInt32)choiceId;

/**
 * @abstract a unique ID that identifies the Choice Set
 * @discussion a unique ID that identifies the Choice Set
 * <p>
 * <b>Notes: </b>Min Value: 0; Max Value: 2000000000
 */
@property (strong) NSNumber *interactionChoiceSetID;

@end
