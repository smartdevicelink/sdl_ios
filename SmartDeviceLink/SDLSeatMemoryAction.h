//  SDLSeatMemoryAction.h
//

#import "SDLRPCStruct.h"
#import "SDLSeatMemoryActionType.h"

/**
 * Specify the action to be performed.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLSeatMemoryAction : SDLRPCStruct


/**
 @abstract Constructs a newly allocated SDLSeatMemoryAction object with id, label (max length 100 chars) and action type

 @param id of the action to be performed
 @param action type of action to be performed
 @return A SDLSeatMemoryAction object
 */
- (instancetype)initWithId:(UInt8)id action:(SDLSeatMemoryActionType)action;

/**
 @abstract Constructs a newly allocated SDLSeatMemoryAction object with id, label (max length 100 chars) and action type

 @param id of the action to be performed
 @param label of the action to be performed.
 @param action type of action to be performed
 @return A SDLSeatMemoryAction object
 */
- (instancetype)initWithId:(UInt8)id label:(nullable NSString*) label action:(SDLSeatMemoryActionType)action;

/**
 * @abstract id of the action to be performed.
 *
 * Required, MinValue- 0 MaxValue= 10
 *
 */
@property (strong, nonatomic) NSNumber<SDLInt> *id;

/**
 * @abstract label of the action to be performed.
 *
 * Optional, Max length 100 chars
 */
@property (nullable, strong, nonatomic) NSString *label;

/**
 * @abstract type of action to be performed
 *
 * Required, @see SDLSeatMemoryActionType
 *
 */
@property (strong, nonatomic) SDLSeatMemoryActionType action;


@end

NS_ASSUME_NONNULL_END
