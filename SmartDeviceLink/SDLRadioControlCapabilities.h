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

- (instancetype)initWithModuleName:(NSString *)moduleName radioEnableAvailable:(BOOL)radioEnableAvailable radioBandAvailable:(BOOL)radioBandAvailable radioFrequencyAvailable:(BOOL)radioFrequencyAvailable hdChannelAvailable:(BOOL)hdChannelAvailable rdsDataAvailable:(BOOL)rdsDataAvailable availableHDsAvailable:(BOOL)availableHDsAvailable stateAvailable:(BOOL)stateAvailable signalStrengthAvailable:(BOOL)signalStrengthAvailable signalChangeThresholdAvailable:(BOOL)signalChangeThresholdAvailable sisDataAvailable:(BOOL)sisDataAvailable;

/**
 * The short friendly name of the climate control module.
 
 * It should not be used to identify a module by mobile application.
 *
 * Max string length 100 chars
 */
@property (strong, nonatomic) NSString *moduleName;

/**
 * Availability of the control of enable/disable radio.

 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *radioEnableAvailable;

/**
 *  Availability of the control of radio band.

 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *radioBandAvailable;

/**
 * Availability of the control of radio frequency.

 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *radioFrequencyAvailable;

/**
 * Availability of the control of HD radio channel.

 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *hdChannelAvailable;

/**
 * Availability of the getting Radio Data System (RDS) data.

 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *rdsDataAvailable;

/**
 * Availability of the getting the number of available HD channels.

 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *availableHDsAvailable;

/**
 * Availability of the getting the Radio state.

 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *stateAvailable;

/**
 * Availability of the getting the signal strength.

 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *signalStrengthAvailable;

/**
 * Availability of the getting the signal Change Threshold

 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *signalChangeThresholdAvailable;

/**
 * @abstract Availability of the getting HD radio Station Information Service (SIS) data.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *sisDataAvailable;

@end

NS_ASSUME_NONNULL_END
