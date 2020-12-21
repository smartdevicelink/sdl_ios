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
 */
@property (strong, nonatomic, nullable) SDLWarningLightStatus pressureTelltale;

/**
 The status of the left front tire.
 */
@property (strong, nonatomic, nullable) SDLSingleTireStatus *leftFront;

/**
 The status of the right front tire.
 */
@property (strong, nonatomic, nullable) SDLSingleTireStatus *rightFront;

/**
 The status of the left rear tire.
 */
@property (strong, nonatomic, nullable) SDLSingleTireStatus *leftRear;

/**
 The status of the right rear tire.
 */
@property (strong, nonatomic, nullable) SDLSingleTireStatus *rightRear;

/**
 The status of the inner left rear tire.
 */
@property (strong, nonatomic, nullable) SDLSingleTireStatus *innerLeftRear;

/**
 The status of the innter right rear tire.
 */
@property (strong, nonatomic, nullable) SDLSingleTireStatus *innerRightRear;

@end

NS_ASSUME_NONNULL_END
