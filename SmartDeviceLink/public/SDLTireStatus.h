//  SDLTireStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLWarningLightStatus.h"

@class SDLSingleTireStatus;

NS_ASSUME_NONNULL_BEGIN

/**
 Struct used in Vehicle Data; the status and pressure of the tires.
 */
@interface SDLTireStatus : SDLRPCStruct

/**
 Status of the Tire Pressure Telltale. See WarningLightStatus.

 Required
 */
@property (strong, nonatomic) SDLWarningLightStatus pressureTelltale;

/**
 The status of the left front tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *leftFront;

/**
 The status of the right front tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *rightFront;

/**
 The status of the left rear tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *leftRear;

/**
 The status of the right rear tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *rightRear;

/**
 The status of the inner left rear tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *innerLeftRear;

/**
 The status of the innter right rear tire.

 Required
 */
@property (strong, nonatomic) SDLSingleTireStatus *innerRightRear;

@end

NS_ASSUME_NONNULL_END
