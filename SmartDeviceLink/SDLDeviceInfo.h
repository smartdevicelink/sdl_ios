//  SDLDeviceInfo.h
//

#import "SDLRPCMessage.h"


@interface SDLDeviceInfo : SDLRPCStruct

@property (strong) NSString *hardware;
@property (strong) NSString *firmwareRev;
@property (strong) NSString *os;
@property (strong) NSString *osVersion;
@property (strong) NSString *carrier;
@property (strong) NSNumber<SDLInt> *maxNumberRFCOMMPorts;

@end
