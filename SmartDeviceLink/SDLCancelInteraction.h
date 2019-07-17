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
 *  Used to dismiss a modal view programmatically without needing to wait for the timeout to complete. Can be used to dismiss alerts, scrollable messages, sliders, and perform interactions (i.e. pop-up menus).
 *
 *  @see `SDLAlert`, `SDLScrollableMessage`, `SDLSlider`, `SDLPerformInteraction`
 */
@interface SDLCancelInteraction : SDLRPCRequest

/**
 *  Convenience init for dismissing an interaction type.
 *
 *  @param functionID           The ID of the type of interaction to dismiss
 *  @return                     A SDLPublishAppService object
 */
- (instancetype)initWithfunctionID:(UInt32)functionID;

/**
 *  Convenience init for dismissing a specific interaction.
 *
 *  @param functionID           The ID of the type of interaction to dismiss
 *  @param cancelID             The ID of the specific interaction to dismiss
 *  @return                     A SDLPublishAppService object
 */
- (instancetype)initWithfunctionID:(UInt32)functionID cancelID:(UInt32)cancelID;

/**
 *  The ID of the specific interaction to dismiss. If not set, the most recent of the RPC type set in functionID will be dismissed.
 *
 *  Integer, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *cancelID;

/**
 *  The ID of the type of interaction to dismiss.
 *
 *  Only values 10 (PerformInteractionID), 12 (AlertID), 25 (ScrollableMessageID), and 26 (SliderID) are permitted.
 *
 *  Integer, Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *functionID;

@end

NS_ASSUME_NONNULL_END
