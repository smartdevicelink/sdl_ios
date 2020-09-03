//
//  SDLButtonPress.h
//

#import "SDLRPCRequest.h"
#import "SDLModuleType.h"
#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"

NS_ASSUME_NONNULL_BEGIN

/**
 This RPC allows a remote control type mobile application to simulate a hardware button press event.

 @since RPC 4.5
*/
@interface SDLButtonPress : SDLRPCRequest

/**
Constructs a newly allocated SDLButtonPress object with the given parameters

@param buttonName the name of the button
@param moduleType the module where the button should be pressed
@param moduleId the id of the module
@param buttonPressMode indicates LONG or SHORT button press event

@return An instance of the SDLButtonPress class.
*/
- (instancetype)initWithButtonName:(SDLButtonName)buttonName moduleType:(SDLModuleType)moduleType moduleId:(nullable NSString *)moduleId buttonPressMode:(SDLButtonPressMode)buttonPressMode;

/**
 * The module where the button should be pressed.
 *
 */
@property (strong, nonatomic) SDLModuleType moduleType;

/**
 *  Id of a module, published by System Capability.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) NSString *moduleId;

/**
 * The name of supported RC climate or radio button.
 *
 */
@property (strong, nonatomic) SDLButtonName buttonName;

/**
 * Indicates whether this is a LONG or SHORT button press event.
 *
 */
@property (strong, nonatomic) SDLButtonPressMode buttonPressMode;

@end

NS_ASSUME_NONNULL_END
