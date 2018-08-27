//  SDLPerformInteractionResponse.h
//


#import "SDLRPCResponse.h"

#import "SDLTriggerSource.h"

/**
 PerformInteraction Response is sent, when SDLPerformInteraction has been called
 
 @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLPerformInteractionResponse : SDLRPCResponse

/**
 ID of the choice that was selected in response to PerformInteraction. Only is valid if general result is "success:true".

 Optional, Integer, 0 - 2,000,000,000
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *choiceID;

/**
 Manually entered text selection, e.g. through keyboard. Can be returned in lieu of choiceID, depending on the trigger source.

 Optional, Max length 500 chars
 */
@property (nullable, strong, nonatomic) NSString *manualTextEntry;

/**
 A *SDLTriggerSource* object which will be shown in the HMI. Only is valid if resultCode is SUCCESS.
 */
@property (nullable, strong, nonatomic) SDLTriggerSource triggerSource;


@end

NS_ASSUME_NONNULL_END
