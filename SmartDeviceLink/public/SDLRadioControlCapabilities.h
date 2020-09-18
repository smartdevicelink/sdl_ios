//
//  SDLRadioControlCapabilities.h
//

#import "SDLRPCMessage.h"
#import "SDLModuleInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Contains information about a radio control module's capabilities.
 */
@interface SDLRadioControlCapabilities : SDLRPCStruct

/**
 Constructs a newly allocated SDLRadioControlCapabilities object with given parameters.
 
 @param moduleName The short friendly name of the radio control module.
 @param moduleInfo Information about a RC module, including its id.
 @param radioEnableAvailable Availability of the control of enable/disable radio.
 @param radioBandAvailable Availability of the control of radio band.
 @param radioFrequencyAvailable Availability of the control of radio frequency.
 @param hdChannelAvailable Availability of the control of HD radio channel.
 @param rdsDataAvailable Availability of the getting Radio Data System (RDS) data.
 @param availableHDChannelsAvailable Availability of the list of available HD sub-channel indexes.
 @param stateAvailable Availability of the getting the Radio state.
 @param signalStrengthAvailable Availability of the getting the signal strength.
 @param signalChangeThresholdAvailable Availability of the getting the signal Change Threshold.
 @param hdRadioEnableAvailable Availability of the control of enable/disable HD radio.
 @param siriusXMRadioAvailable Availability of sirius XM radio.
 @param sisDataAvailable Availability of sis data.
 @return An instance of the SDLRadioControlCapabilities class
 */
- (instancetype)initWithModuleName:(NSString *)moduleName moduleInfo:(nullable SDLModuleInfo *)moduleInfo radioEnableAvailable:(BOOL)radioEnableAvailable radioBandAvailable:(BOOL)radioBandAvailable radioFrequencyAvailable:(BOOL)radioFrequencyAvailable hdChannelAvailable:(BOOL)hdChannelAvailable rdsDataAvailable:(BOOL)rdsDataAvailable availableHDChannelsAvailable:(BOOL)availableHDChannelsAvailable stateAvailable:(BOOL)stateAvailable signalStrengthAvailable:(BOOL)signalStrengthAvailable signalChangeThresholdAvailable:(BOOL)signalChangeThresholdAvailable hdRadioEnableAvailable:(BOOL)hdRadioEnableAvailable siriusXMRadioAvailable:(BOOL)siriusXMRadioAvailable sisDataAvailable:(BOOL)sisDataAvailable;

/**
 * The short friendly name of the radio control module.
 
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
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *availableHDsAvailable __deprecated_msg("Use availableHDChannelsAvailable instead.");

/**
 * Availability of the list of available HD sub-channel indexes.
 
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *availableHDChannelsAvailable;

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
 * Availability of the control of enable/disable HD radio.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *hdRadioEnableAvailable;

/**
 * Availability of sirius XM radio.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *siriusXMRadioAvailable;

/**
 * Availability of the getting HD radio Station Information Service (SIS) data.
 * True: Available, False: Not Available, Not present: Not Available.
 *
 * Optional, Boolean
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *sisDataAvailable;

/**
 *  Information about a RC module, including its id.
 *
 *  SDLModuleInfo
 */
@property (nullable, strong, nonatomic) SDLModuleInfo *moduleInfo;

@end

NS_ASSUME_NONNULL_END
