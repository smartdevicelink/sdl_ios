//
//  SDLNavigationInstruction.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"

#import "SDLDirection.h"
#import "SDLNavigationAction.h"
#import "SDLNavigationJunction.h"

@class SDLDateTime;
@class SDLImage;
@class SDLLocationDetails;


NS_ASSUME_NONNULL_BEGIN

/**
 *  A navigation instruction.
 */
@interface SDLNavigationInstruction : SDLRPCStruct

/**
 *  Convenience init for required parameters
 *
 *  @param locationDetails The location details
 *  @param action The navigation action
 *  @return A SDLNavigationInstruction object
 */
- (instancetype)initWithLocationDetails:(SDLLocationDetails *)locationDetails action:(SDLNavigationAction)action NS_DESIGNATED_INITIALIZER;

/**
 *  Convenience init for all parameters.
 *
 *  @param locationDetails The location details
 *  @param action The navigation action
 *  @param eta The estimated time of arrival
 *  @param bearing The angle at which this instruction takes place
 *  @param junctionType The navigation junction type
 *  @param drivingSide Used to infer which side of the road this instruction takes place
 *  @param details This is a string representation of this instruction, used to display instructions to the users
 *  @param image An image representation of this instruction
 *  @return A SDLNavigationInstruction object
 */
- (instancetype)initWithLocationDetails:(SDLLocationDetails *)locationDetails action:(SDLNavigationAction)action eta:(nullable SDLDateTime *)eta bearing:(UInt16)bearing junctionType:(nullable SDLNavigationJunction)junctionType drivingSide:(nullable SDLDirection)drivingSide details:(nullable NSString *)details image:(nullable SDLImage *)image;

/**
 *  The location details.
 *
 *  SDLLocationDetails, Required
 */
@property (strong, nonatomic) SDLLocationDetails *locationDetails;

/**
 *  The navigation action.
 *
 *  SDLNavigationAction, Required
 */
@property (strong, nonatomic) SDLNavigationAction action;

/**
 *  The estimated time of arrival.
 *
 *  SDLDateTime, Optional
 */
@property (nullable, strong, nonatomic) SDLDateTime *eta;

/**
 *  The angle at which this instruction takes place. For example, 0 would mean straight, <=45 is bearing right, >= 135 is sharp right, between 45 and 135 is a regular right, and 180 is a U-Turn, etc. 
 *
 *  Integer, Optional, minValue="0" maxValue="359"
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *bearing;

/**
 *  The navigation junction type.
 *
 *  SDLNavigationJunction, Optional
 */
@property (nullable, strong, nonatomic) SDLNavigationJunction junctionType;

/**
 *  Used to infer which side of the road this instruction takes place. For a U-Turn (action=TURN, bearing=180) this will determine which direction the turn should take place.
 *
 *  SDLDirection, Optional
 */
@property (nullable, strong, nonatomic) SDLDirection drivingSide;

/**
 *  This is a string representation of this instruction, used to display instructions to the users. This is not intended to be read aloud to the users, see the param prompt in `NavigationServiceData` for that.
 *
 *  String, Optional
 */
@property (nullable, strong, nonatomic) NSString *details;

/**
 *  An image representation of this instruction.
 *
 *  SDLImage, Optional
 */
@property (nullable, strong, nonatomic) SDLImage *image;

@end

NS_ASSUME_NONNULL_END
