//
//  SDLHMICapabilities.h
//  SmartDeviceLink-iOS

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Contains information about the HMI capabilities.

 Since SDL 3.0
**/
@interface SDLHMICapabilities : SDLRPCStruct

/**
 Availability of built in Nav. True: Available, False: Not Available
 
 Boolean value. Optional.

 Since SDL 3.0
 */
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *navigation;

/**
 Availability of built in phone. True: Available, False: Not Available
 
 Boolean value. Optional.

 Since SDL 3.0
 */
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *phoneCall;

/**
 Availability of built in video streaming. True: Available, False: Not Available

 Boolean value. Optional.

 Since SDL 4.5
 */
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *videoStreaming;

/**
 Availability of built in remote control. True: Available, False: Not Available

 Boolean value. Optional.

 Since SDL 4.5
**/
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *remoteControl;

/**
 Availability of app services. True: Available, False: Not Available

 App services is supported since SDL 5.1. If your connection is 5.1+, you can assume that app services is available even though between v5.1 and v6.0 this parameter is `nil`.

 Boolean value. Optional.

 Since SDL 6.0
**/
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *appServices;

/**
 Availability of displays. True: Available, False: Not Available

 Boolean value. Optional.

 Since SDL 6.0
**/
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *displays;

/**
 Availability of seatLocation. True: Available, False: Not Available

 Boolean value. Optional.

 Since SDL 6.0
 **/
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *seatLocation;

@end

NS_ASSUME_NONNULL_END
