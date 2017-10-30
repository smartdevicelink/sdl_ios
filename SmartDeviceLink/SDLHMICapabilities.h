//
//  SDLHMICapabilities.h
//  SmartDeviceLink-iOS

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLHMICapabilities : SDLRPCStruct

/**
 Availability of built in Nav. True: Available, False: Not Available
 
 Boolean value. Optional.
 */
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *navigation;

/**
 Availability of built in phone. True: Available, False: Not Available
 
 Boolean value. Optional.
 */
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *phoneCall;

/**
 Availability of built in video streaming. True: Available, False: Not Available

 Boolean value. Optional.
 */
@property (nullable, copy, nonatomic) NSNumber<SDLBool> *videoStreaming;

@end

NS_ASSUME_NONNULL_END
