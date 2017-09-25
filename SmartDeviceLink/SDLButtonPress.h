//
//  SDLButtonPress.h
//

#import "SDLRPCRequest.h"
#import "SDLModuleType.h"
#import "SDLButtonName.h"
#import "SDLButtonPressMode.h"

/**
 * This RPC allows a remote control type mobile application to simulate a hardware button press event.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLButtonPress : SDLRPCRequest

- (instancetype)initWithButtonName:(SDLButtonName)buttonName moduleType:(SDLModuleType) moduleType;

/**
 * The module where the button should be pressed.
 *
 */
@property (strong, nonatomic) SDLModuleType moduleType;

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
