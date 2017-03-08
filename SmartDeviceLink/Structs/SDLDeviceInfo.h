//  SDLDeviceInfo.h
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLDeviceInfo : SDLRPCStruct

+ (instancetype)currentDevice;

@property (nullable, strong, nonatomic) NSString *hardware;
@property (nullable, strong, nonatomic) NSString *firmwareRev;
@property (nullable, strong, nonatomic) NSString *os;
@property (nullable, strong, nonatomic) NSString *osVersion;
@property (nullable, strong, nonatomic) NSString *carrier;
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *maxNumberRFCOMMPorts;

@end

NS_ASSUME_NONNULL_END
