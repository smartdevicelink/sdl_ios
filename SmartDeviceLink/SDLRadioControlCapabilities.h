//
//  SDLRadioControlCapabilities.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Contains information about a radio control module's capabilities.
 */
@interface SDLRadioControlCapabilities : SDLRPCStruct

- (instancetype)initWithModuleName:(NSString *)moduleName radioEnableAvailable:(BOOL)radioEnableAvailable radioBandAvailable:(BOOL)radioBandAvailable radioFrequencyAvailable:(BOOL)radioFrequencyAvailable hdChannelAvailable:(BOOL)hdChannelAvailable rdsDataAvailable:(BOOL)rdsDataAvailable availableHDsAvailable:(BOOL)availableHDsAvailable stateAvailable:(BOOL)stateAvailable signalStrengthAvailable:(BOOL)signalStrengthAvailable signalChangeThresholdAvailable:(BOOL)signalChangeThresholdAvailable;

/**
 * @abstract The short friendly name of the climate control module.
 * It should not be used to identify a module by mobile application.
 *
 * Max string length 100 chars
 */
@property (strong, nonatomic) NSString *moduleName;

/**
 * @abstract Availability of the control of enable/disable radio.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *radioEnableAvailable;

/**
 * @abstract  Availability of the control of radio band.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *radioBandAvailable;

/**
 * @abstract Availability of the control of radio frequency.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *radioFrequencyAvailable;

/**
 * @abstract Availability of the control of HD radio channel.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *hdChannelAvailable;

/**
 * @abstract Availability of the getting Radio Data System (RDS) data.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rdsDataAvailable;

/**
 * @abstract Availability of the getting the number of available HD channels.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *availableHDsAvailable;

/**
 * @abstract Availability of the getting the Radio state.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *stateAvailable;

/**
 * @abstract Availability of the getting the signal strength.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *signalStrengthAvailable;

/**
 * @abstract Availability of the getting the signal Change Threshold
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *signalChangeThresholdAvailable;

@end

NS_ASSUME_NONNULL_END
