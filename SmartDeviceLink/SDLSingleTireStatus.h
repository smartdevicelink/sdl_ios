//  SDLSingleTireStatus.h
//

#import "SDLRPCMessage.h"

#import "SDLComponentVolumeStatus.h"
#import "SDLTPMS.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Tire pressure status of a single tire.
 *
 * @since SmartDeviceLink 2.0
 */
@interface SDLSingleTireStatus : SDLRPCStruct

/**
 * The volume status of a single tire

 Required
 */
@property (strong, nonatomic) SDLComponentVolumeStatus status;

/**
 The status of TPMS for this particular tire

 Optional
 */
@property (strong, nonatomic, nullable) SDLTPMS monitoringSystemStatus;

/**
 The pressure value of this particular tire in kPa (kilopascals)

 Optional, Float, 0-2000
 */
@property (copy, nonatomic, nullable) NSNumber<SDLFloat> *pressure;

@end

NS_ASSUME_NONNULL_END
