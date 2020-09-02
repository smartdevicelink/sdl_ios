//  SDLDeviceInfo.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Various information about connecting device. Referenced in RegisterAppInterface
 */
@interface SDLDeviceInfo : SDLRPCStruct

/// Convenience init. Object will contain all information about the connected device automatically.
///
/// @return An SDLDeviceInfo object
+ (instancetype)currentDevice;

/**
 Device model

 Optional
 */
@property (nullable, strong, nonatomic) NSString *hardware;

/**
 Device firmware version

 Optional
 */
@property (nullable, strong, nonatomic) NSString *firmwareRev;

/**
 Device OS

 Optional
 */
@property (nullable, strong, nonatomic) NSString *os;

/**
 Device OS version

 Optional
 */
@property (nullable, strong, nonatomic) NSString *osVersion;

/**
 Device mobile carrier

 Optional
 */
@property (nullable, strong, nonatomic) NSString *carrier;

/**
 Number of bluetooth RFCOMM ports available.

 Omitted if not connected via BT or on iOS

 Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *maxNumberRFCOMMPorts;

@end

NS_ASSUME_NONNULL_END
