//
//  SDLHMICapabilities.h
//  SmartDeviceLink-iOS

#import "SDLRPCStruct.h"

@interface SDLHMICapabilities : SDLRPCStruct

/**
 Availability of build in Nav. True: Available, False: Not Available
 
 Boolean value. Optional.
 */
@property (copy, nonatomic) NSNumber<SDLBool> *navigation;

/**
 Availability of build in phone. True: Available, False: Not Available
 
 Boolean value. Optional.
 */
@property (copy, nonatomic) NSNumber<SDLBool> *phoneCall;

@end
