//  SDLTireStatus.h
//

#import "SDLRPCMessage.h"

@class SDLSingleTireStatus;
#import "SDLWarningLightStatus.h"

@interface SDLTireStatus : SDLRPCStruct

@property (strong) SDLWarningLightStatus pressureTelltale;
@property (strong) SDLSingleTireStatus *leftFront;
@property (strong) SDLSingleTireStatus *rightFront;
@property (strong) SDLSingleTireStatus *leftRear;
@property (strong) SDLSingleTireStatus *rightRear;
@property (strong) SDLSingleTireStatus *innerLeftRear;
@property (strong) SDLSingleTireStatus *innerRightRear;

@end
