//  SDLDeviceInfo.h
//

#import "SDLRPCMessage.h"


@interface SDLDeviceInfo : SDLRPCStruct

+ (instancetype)currentDevice;

@property (strong, nonatomic) NSString *hardware;
@property (strong, nonatomic) NSString *firmwareRev;
@property (strong, nonatomic) NSString *os;
@property (strong, nonatomic) NSString *osVersion;
@property (strong, nonatomic) NSString *carrier;
@property (strong, nonatomic) NSNumber<SDLInt> *maxNumberRFCOMMPorts;

@end
