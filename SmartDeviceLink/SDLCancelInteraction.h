//
//  SDLCancelInteraction.h
//  SmartDeviceLink
//
//  Created by Nicole on 7/12/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

/*
 Used to dismiss a modal view programmatically without needing to wait for the timeout to complete. Can be used to dismiss alerts, scrollable messages, sliders, and perform interactions (i.e. pop-up menus).

 @see SDLAlert, SDLScrollableMessage, SDLSlider, SDLPerformInteraction
 */
@interface SDLCancelInteraction : SDLRPCRequest

/**
 Convenience init for dismissing the currently presented modal view (either an alert, slider, scrollable message, or perform interation).

 @param functionID           The ID of the type of modal view to dismiss
 @return                     A SDLCancelInteraction object
 */
- (instancetype)initWithFunctionID:(UInt32)functionID;

/**
 Convenience init for dismissing a specific view.

 @param functionID           The ID of the type of interaction to dismiss
 @param cancelID             The ID of the specific interaction to dismiss
 @return                     A SDLCancelInteraction object
 */
- (instancetype)initWithFunctionID:(UInt32)functionID cancelID:(UInt32)cancelID;

/**
 Convenience init for dismissing an alert.

 @param cancelID The ID of the specific interaction to dismiss
 @return         A SDLCancelInteraction object
 */
- (instancetype)initWithAlertCancelID:(UInt32)cancelID;

/**
 Convenience init for dismissing a slider.

 @param cancelID The ID of the specific interaction to dismiss
 @return         A SDLCancelInteraction object
 */
- (instancetype)initWithSliderCancelID:(UInt32)cancelID;

/**
 Convenience init for dismissing a scrollable message.

 @param cancelID The ID of the specific interaction to dismiss
 @return         A SDLCancelInteraction object
 */
- (instancetype)initWithScrollableMessageCancelID:(UInt32)cancelID;

/**
 Convenience init for dismissing a perform interaction.

 @param cancelID The ID of the specific interaction to dismiss
 @return         A SDLCancelInteraction object
 */
- (instancetype)initWithPerformInteractionCancelID:(UInt32)cancelID;

/**
 Convenience init for dismissing the currently presented alert.

 @return A SDLCancelInteraction object
 */
- (instancetype)initWithAlert;

/**
 Convenience init for dismissing the currently presented slider.

 @return A SDLCancelInteraction object
 */
- (instancetype)initWithSlider;

/**
 Convenience init for dismissing the currently presented scrollable message.

 @return A SDLCancelInteraction object
 */
- (instancetype)initWithScrollableMessage;

/**
 Convenience init for dismissing the currently presented perform interaction.

 @return A SDLCancelInteraction object
 */
- (instancetype)initWithPerformInteraction;

/**
 The ID of the specific interaction to dismiss. If not set, the most recent of the RPC type set in functionID will be dismissed.

 Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *cancelID;

/**
 The ID of the type of interaction to dismiss.

 Only values 10 (PerformInteractionID), 12 (AlertID), 25 (ScrollableMessageID), and 26 (SliderID) are permitted.

 Integer, Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *functionID;

@end

NS_ASSUME_NONNULL_END

