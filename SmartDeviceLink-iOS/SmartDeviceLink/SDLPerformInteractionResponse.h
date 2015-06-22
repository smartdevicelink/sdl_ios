//  SDLPerformInteractionResponse.h
//


#import "SDLRPCResponse.h"

@class SDLTriggerSource;


/**
 * PerformInteraction Response is sent, when SDLPerformInteraction has been called
 *
 * @since SDL 1.0
 */
@interface SDLPerformInteractionResponse : SDLRPCResponse {
}

/**
 * @abstract Constructs a new SDLPerformInteractionResponse object
 */
- (instancetype)init;

/**
 * @abstract Constructs a new SDLPerformInteractionResponse object indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

/**
 * @abstract ID of the choice that was selected in response to PerformInteraction. 
 * 
 * @discussion Only is valid if general result is "success:true".
 *
 * Optional, Integer, 0 - 2,000,000,000
 */
@property (strong) NSNumber *choiceID;

/**
 * @abstract Manually entered text selection, e.g. through keyboard
 * 
 * @discussion Can be returned in lieu of choiceID, depending on trigger source
 *
 * Optional, Max length 500 chars
 */
@property (strong) NSString *manualTextEntry;

/**
 * @abstract A *SDLTriggerSource* object which will be shown in the HMI
 *
 * @discussion Only is valid if resultCode is SUCCESS.
 */
@property (strong) SDLTriggerSource *triggerSource;


@end
