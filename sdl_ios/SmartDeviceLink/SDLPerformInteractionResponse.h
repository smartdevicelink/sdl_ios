//  SDLPerformInteractionResponse.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCResponse.h>

#import <SmartDeviceLink/SDLTriggerSource.h>

/**
 * PerformInteraction Response is sent, when SDLPerformInteraction has been called
 *
 * Since SmartDeviceLink 1.0
 */
@interface SDLPerformInteractionResponse : SDLRPCResponse {}

/**
 * @abstract Constructs a new SDLPerformInteractionResponse object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLPerformInteractionResponse object indicated by the NSMutableDictionary parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract The application-scoped identifier that uniquely identifies this choice.
 * <br/>choiceID Min: 0  Max: 65535
 */
@property(strong) NSNumber* choiceID;
/**
 * @abstract A string containing the entered text</p>
 */
@property(strong) NSString* manualTextEntry;
/**
 * @abstract A <I>TriggerSource</I> object which will be shown in the HMI</p>
 */
@property(strong) SDLTriggerSource* triggerSource;


@end
