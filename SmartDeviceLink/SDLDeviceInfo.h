//  SDLDeviceInfo.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLDeviceInfo : SDLRPCStruct

+ (instancetype)currentDevice;

@property (nullable, strong) NSString *hardware;
@property (nullable, strong) NSString *firmwareRev;
@property (nullable, strong) NSString *os;
@property (nullable, strong) NSString *osVersion;
@property (nullable, strong) NSString *carrier;
@property (nullable, strong) NSNumber<SDLInt> *maxNumberRFCOMMPorts;

@end

NS_ASSUME_NONNULL_END
